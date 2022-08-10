//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?
    var orderTabBarItem: UITabBarItem!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        coordinator = MainCoordinator(window: window)
        coordinator?.start()
        
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            configureScene(for: userActivity)
        }
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return UserActivityController.shared.userActivity
    }
    
    func configureScene(for userActivity: NSUserActivity) {
        if let restoredOrder = userActivity.order {
            MenuController.order = restoredOrder
        }
        
        guard let restorationController = StateRestorationController(userActivity: userActivity),
              let coordinator = coordinator as? MainCoordinator
        else { return }
        let tabBarController = coordinator.tabBar
        guard tabBarController.viewControllers?.count == 2,
              let categoryTableViewController = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController
        else { return }
        
        switch restorationController {
        case .categories:
            break
        case .order:
            tabBarController.selectedIndex = 1
        case .menu(let category):
            let menuTableViewController = MenuTableViewController(delegate: coordinator, category: category, repository: coordinator.repository)
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
        case .menuItemDetail(let menuItem):
            let menuTableViewController = MenuTableViewController(delegate: coordinator, category: menuItem.category, repository: coordinator.repository)
            let menuItemDetailViewController = MenuItemDetailViewController(delegate: coordinator, item: menuItem, image: nil, repository: coordinator.repository)
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
            categoryTableViewController.navigationController?.pushViewController(menuItemDetailViewController, animated: true)
        }
    }
    
    @objc
    func updateOrderBadge() {
        let cartCount = MenuController.order.menuItems.count
        orderTabBarItem.badgeValue = cartCount == 0 ? nil : String(cartCount)
    }

}

