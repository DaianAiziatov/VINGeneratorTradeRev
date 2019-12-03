//
//  AppDelegate.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let rootController = RandomVinGeneratorViewController(nibName: nil, bundle: nil)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
        return true
    }
}

