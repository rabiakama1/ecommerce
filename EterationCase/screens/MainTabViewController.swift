//
//  MainTabViewController.swift
//  EterationCase
//
//  Created by aşkımcım on 29.07.2025.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = UIColor.systemBlue
        tabBar.backgroundColor = UIColor.white
        tabBar.isTranslucent = false
    }
    
    private func setupViewControllers() {
        let homeVC = ProductListCollectionViewController(nibName: "ProductListCollectionViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let cartVC = CartViewController(nibName: "CartViewController", bundle: nil)
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        
        let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        viewControllers = [homeNav, cartNav, favoritesNav]
        
        // Cart badge observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
        updateCartBadge()
    }
    
    @objc private func updateCartBadge() {
        let cartCount = CoreDataManager.shared.getCartItemCount()
        if let cartTab = viewControllers?[1] {
            cartTab.tabBarItem.badgeValue = cartCount > 0 ? "\(cartCount)" : nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
