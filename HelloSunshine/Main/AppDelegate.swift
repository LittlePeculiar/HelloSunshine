//
//  AppDelegate.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var homeVC: HomeVC!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        homeVC = HomeVC(viewModel: HomeVM())
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
        
        return true
    }
}

