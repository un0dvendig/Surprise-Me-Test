//
//  AppDelegate.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var coordinator: MainCoordinator?
    var window: UIWindow?

    // MARK: - UIApplicationDelegate methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupCoordinator()
               
        return true
       }
       
       // MARK: - Private methods
       
       private func setupCoordinator() {
           let navigationController = UINavigationController()
           coordinator = MainCoordinator(navigationController: navigationController)
           coordinator?.start()
           
           window = UIWindow(frame: UIScreen.main.bounds)
           window?.rootViewController = navigationController
           window?.makeKeyAndVisible()
       }

}

