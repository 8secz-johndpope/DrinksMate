//
//  AppUtil.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/29/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class AppUtil: NSObject {
    
    public static let serverURL = "http://107.150.52.222:8088/"
    public static var user : DrinkUser!
    public static var otp : String!
    
    public static var config : [String : Any]!
    public static var categories : [MenuCategory]!
}
