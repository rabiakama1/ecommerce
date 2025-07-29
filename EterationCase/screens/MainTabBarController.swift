//
//  MainTabBarController.swift
//  EterationCase
//
//  Created by rabiakama on 29.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.selectedIndex = 1
        self.tabBar.tintColor = .green
        self.tabBar.unselectedItemTintColor = .purple
        self.delegate = self
        //setupViewControllers()
    }
    
    private func setupTabs() {
        let list = self.createNav(with: "Liste", and: UIImage(systemName: "house"), vc: ProductListCollectionViewController())
        let detail = self.createNav(with: "Detay", and: UIImage(systemName: "house"), vc: ProductDetailViewController(product: Product()))
        let cart = self.createNav(with: "Sepet", and: UIImage(systemName: "house"), vc: CartViewController())
        setViewControllers([list,detail,cart], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if self.selectedIndex == 1 {
            let alert = UIAlertController(title: "Hello", message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupTabBar() {
        tabBar.tintColor = UIColor.systemBlue
        tabBar.backgroundColor = UIColor.white
        tabBar.isTranslucent = false
    }
    
    private func setupViewControllers() {
        // XIB olmadan view controller oluşturma
        let homeVC = ProductListCollectionViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let cartVC = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        
        let favoritesVC = FavoritesViewController()
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
