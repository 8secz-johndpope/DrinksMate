//
//  AppDelegate.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyAlwVsZwxcZiZhg4Zf1kJLDJmZodI194wc")
        GMSPlacesClient.provideAPIKey("AIzaSyAlwVsZwxcZiZhg4Zf1kJLDJmZodI194wc")
        
//        GMSServices.provideAPIKey("AIzaSyAPR4vfKibR2e2vNjr4YsZI2v-UOTtScGw")
//        GMSPlacesClient.provideAPIKey("AIzaSyAPR4vfKibR2e2vNjr4YsZI2v-UOTtScGw")
        return true
    }

}

