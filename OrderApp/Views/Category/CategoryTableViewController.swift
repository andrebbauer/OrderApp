//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class CategoryTableViewController: UIViewController {
    
    var categories: [String] = []
    
    var tableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    weak var delegate: CategoryCoordinatorDelegate?
    var repository: RepositoryProtocol!
    
    // MARK: - Init
    
    convenience init(delegate: CategoryCoordinatorDelegate, repository: RepositoryProtocol) {
        self.init()
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
        
        repository.fetch(endpoint: Endpoint.categories) { (result: Result<CategoriesResponse, Error>) in
            switch result {
            case .success(let response):
                self.updateUI(with: response.categories)
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch categories")
            }
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        title = "Restaurant"
        
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
        UserActivityController.shared.updateUserActivity(with: .categories)
    }
    
    // MARK: - Functions
    
    private func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.categories = categories
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

extension CategoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.selectedCategory(categories[indexPath.row])
    }
}

extension CategoryTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        configure(cell, for: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = category.capitalized
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Categories"
    }
    
}
