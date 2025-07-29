//
//  EterationCaseApp.swift
//  EterationCase
//
//  Created by rabiakama on 27.07.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = ProductListCollectionViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
