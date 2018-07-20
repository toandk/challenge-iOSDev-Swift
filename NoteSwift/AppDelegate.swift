//
//  AppDelegate.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DatabaseHelper.migrateRealm()
        setupGGMap()
        setupFabric()
        setupViewController()
        
        return true
    }
    
    func setupViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navc = UINavigationController(rootViewController: firstVC)
        
        self.window?.rootViewController = navc
        navc.navigationBar.isTranslucent = false
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
    }
    
    func setupFabric() {
        Fabric.with([Crashlytics.self])
    }
    
    func setupGGMap() {
        GMSServices.provideAPIKey(AppConstants.GOOGLE_MAP_API_KEY)
    }
}

