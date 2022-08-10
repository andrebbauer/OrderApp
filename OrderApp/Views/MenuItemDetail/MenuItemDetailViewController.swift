//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    private var contentView: MenuItemDetailView! { return view as? MenuItemDetailView }
    var item: MenuItem!
    var image: UIImage?
    
    weak var delegate: MenuItemDetailDelegate?
    var repository: RepositoryProtocol?
    
    convenience init(delegate: MenuItemDetailDelegate, item: MenuItem, image: UIImage?, repository: RepositoryProtocol) {
        self.init()
        self.item = item
        self.delegate = delegate
        self.image = image
        self.repository = repository
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        view = MenuItemDetailView()
        view.backgroundColor = .systemBackground
        if image == nil {
            repository?.fetchImage(url: item.imageURL, completion: { image in
                DispatchQueue.main.async {
                    self.contentView.setupImage(image)
                }
            })
        }
        contentView.setup(with: item, image: image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserActivityController.shared.updateUserActivity(with: .menuItemDetail(item))
    }
    
    // MARK: - Actions
    
    @objc
    func addButtonTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: []) {
            self.contentView.addButton.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            self.contentView.addButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        MenuController.order.menuItems.append(item)
        delegate?.orderedItem()
    }
}
