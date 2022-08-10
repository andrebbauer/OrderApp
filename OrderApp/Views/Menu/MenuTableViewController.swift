//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class MenuTableViewController: UIViewController {
    
    var items: [MenuItem] = []
    var category: String!
    
    var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    weak var delegate: MenuCoordinatorDelegate?
    var repository: RepositoryProtocol!
    
    convenience init(delegate: MenuCoordinatorDelegate, category: String, repository: RepositoryProtocol) {
        self.init()
        self.category = category
        self.delegate = delegate
        self.repository = repository
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        repository.fetch(endpoint: Endpoint.menu(category)) { (result: Result<MenuResponse, Error>) in
            switch result {
            case .success(let response):
                self.updateUI(with: response.items)
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch menu items for \(self.category!)")
            }
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        title = category.capitalized
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserActivityController.shared.updateUserActivity(with: .menu(category: category))
    }
    
    // MARK: - Functions
    
    private func updateUI(with items: [MenuItem]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.items = items
            self.tableView.reloadData()
        }
    }
    
    private func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let ac = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
}

extension MenuTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = tableView.cellForRow(at: indexPath)?.imageView?.image
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.selected(items[indexPath.row], image: image)
    }
}

extension MenuTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        update(cell, at: indexPath)
        
        return cell
    }
    
    func update(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.price.currency
        cell.imageView?.image = UIImage(systemName: "photo.on.rectangle")
        
        repository.fetchImage(url: item.imageURL) { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
}
