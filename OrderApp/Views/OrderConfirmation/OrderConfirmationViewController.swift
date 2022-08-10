//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 06/08/22.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    var contentView: OrderConfirmationView { return view as! OrderConfirmationView}
    
    var minutesToPrepare: MinutesToPrepare?
    
    convenience init(minutesToPrepare: MinutesToPrepare) {
        self.init()
        self.minutesToPrepare = minutesToPrepare
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let minutes = minutesToPrepare else { return }
        contentView.confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutes) minutes."
        contentView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        view = OrderConfirmationView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MenuController.order.menuItems.removeAll()
    }
    
    @objc
    func submitTapped() {
        dismiss(animated: true)
    }
}
