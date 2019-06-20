//
//  AppDelegate.swift
//  ConfigProject
//
//  Created by MBA0239P on 3/18/19.
//  Copyright © 2019 Tung Nguyen C.T. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeViewController()
        configFabric()
        return true
    }

    private func configFabric() {
        Fabric.with([Crashlytics.self])
    }
}
