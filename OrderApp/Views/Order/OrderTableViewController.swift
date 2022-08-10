//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class OrderTableViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView = UITableView()
    
    var repository: RepositoryProtocol!
    weak var delegate: OrderTableViewDelegate?
    
    // MARK: - Init
    
    convenience init(delegate: OrderTableViewDelegate, repository: RepositoryProtocol) {
        self.init()
        self.delegate = delegate
        self.repository = repository
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )
        
        navigationItem.leftBarButtonItem = editButtonItem
        let submitOrderButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitOrderButtonTapped))
        navigationItem.rightBarButtonItem = submitOrderButton
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        title = "Your Order"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserActivityController.shared.updateUserActivity(with: .order)
    }
    
    // MARK: - Actions
    
    @objc
    private func submitOrderButtonTapped() {
        let orderTotal = MenuController.order.menuItems.reduce(0.0) { $0 + $1.price }.currency
        
        let ac = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(orderTotal)", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            self.uploadOrder()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func uploadOrder() {
        let menuIds = MenuController.order.menuItems.map { $0.id }
        
        repository.submitOrder(forMenuIDs: menuIds) { result in
            switch result {
            case .success(let minutesToPrepare):
                DispatchQueue.main.async {
                    self.delegate?.submitOrder(minutesToPrepare: minutesToPrepare)
                }
            case .failure(let error):
                self.displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    private func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(ac, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension OrderTableViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension OrderTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuController.order.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        configure(cell, for: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let item = MenuController.order.menuItems[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Delicious Items"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.order.menuItems.remove(at: indexPath.row)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if MenuController.order.menuItems.isEmpty {
            return "Your order is empty"
        } else {
            return "Total: \(MenuController.order.menuItems.reduce(0.0) {$0 + $1.price}.currency)"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 40, width: tableView.frame.width, height: 44))
        
        let line = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.width-20, height: 1.0))
        line.backgroundColor = .secondaryLabel
        view.addSubview(line)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        view.addSubview(stackView)
        
        let label = UILabel()
        let total = MenuController.order.menuItems.reduce(0.0) {$0 + $1.price}
        if total == 0 {
            label.textAlignment = .center
            label.text = "No items added yet."
            stackView.addArrangedSubview(label)
        } else {
            label.textAlignment = .left
            label.text = "Total:"
            let valueLabel = UILabel()
            valueLabel.text = total.currency
            valueLabel.textAlignment = .right
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(valueLabel)
        }
        
        line.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
}
