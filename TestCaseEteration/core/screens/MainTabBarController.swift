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
        //setupTabs()
        setupViewControllers()
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
        self.delegate = self
    }
    
    private func setupTabs() {
        let homeVC = ProductListCollectionViewController(nibName: "ProductListCollectionViewController", bundle: nil)
        let cartVC = CartViewController(nibName: "CartViewController", bundle: nil)
        let favoriteVC = FavoriteTableViewController(nibName: "FavoriteTableViewController", bundle: nil)
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        let cartNav = UINavigationController(rootViewController: cartVC)
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        homeNav.tabBarItem = UITabBarItem(title: "Liste", image: UIImage(systemName: "house"), tag: 0)
        cartNav.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "basket"), tag: 1)
        favoriteNav.tabBarItem = UITabBarItem(title: "Favori", image: UIImage(systemName: "star"), tag: 2)
        profileNav.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        homeVC.title = "E-Market"
        cartVC.title = "Sepetim"
        favoriteVC.title = "Favoriler"
        profileVC.title = "Profil"
        setViewControllers([homeNav, cartNav, favoriteNav, profileNav], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
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
        
        let favoritesVC = ProductDetailViewController(product: Product())
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Detay", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        viewControllers = [homeNav, favoritesNav,cartNav]
        
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
