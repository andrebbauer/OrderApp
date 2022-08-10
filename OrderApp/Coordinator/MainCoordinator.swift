//
//  AppTabBar.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class MainCoordinator: Coordinator {
    
    let window: UIWindow?
    var tabBar = UITabBarController()
    var menuNavigationController = UINavigationController()
    var orderNavigationController = UINavigationController()
    
    var repository = MenuController()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        menuNavigationController.pushViewController(CategoryTableViewController(delegate: self, repository: repository), animated: false)
        menuNavigationController.tabBarItem.image = UIImage(systemName: "list.bullet")
        menuNavigationController.tabBarItem.title = "Menu"
        
        orderNavigationController.pushViewController(OrderTableViewController(delegate: self, repository: repository), animated: false)
        orderNavigationController.tabBarItem.image = UIImage(systemName: "bag")
        orderNavigationController.tabBarItem.title = "Your Order"
        (window?.windowScene?.delegate as? SceneDelegate)?.orderTabBarItem = orderNavigationController.tabBarItem
        
        tabBar.viewControllers = [menuNavigationController, orderNavigationController]
        
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    func downloadPhoto(_ photo: String, time: UInt32) async -> String {
        sleep(time)
        print("Photo \(photo)")
        return "Photo \(photo)"
    }
}

extension MainCoordinator: CategoryCoordinatorDelegate {
    func selectedCategory(_ category: String) {
        menuNavigationController.pushViewController(MenuTableViewController(delegate: self, category: category, repository: repository), animated: true)
    }
}

extension MainCoordinator: MenuCoordinatorDelegate {
    func selected(_ item: MenuItem, image: UIImage?) {
        menuNavigationController.pushViewController(MenuItemDetailViewController(delegate: self, item: item, image: image, repository: repository), animated: true)
    }
}

extension MainCoordinator: MenuItemDetailDelegate {
    func orderedItem() {
        NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
    }
}

extension MainCoordinator: OrderTableViewDelegate {
    func submitOrder(minutesToPrepare: MinutesToPrepare) {
        orderNavigationController.present(OrderConfirmationViewController(minutesToPrepare: minutesToPrepare), animated: true)
    }
    
    
}
