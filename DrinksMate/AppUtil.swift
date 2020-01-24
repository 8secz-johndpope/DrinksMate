//
//  AppUtil.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/29/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AppUtil: NSObject {
    
    public static let serverURL = "http://107.150.52.222:8088/"
    public static var user : DrinkUser!
    public static var otp : String!
    
    public static var config : [String : Any]!
    public static var tax : TaxConfig!
    public static var pay : PayConfig!
    
    public static var categories : [MenuCategory]!
    public static var selectedCategory : Int!
    public static var isAddressSelected : Bool!
    
    public static var wishlist : [MenuItem]!
    public static var cartsList : [MenuItem]!
    public static var addressList : [UserAddress]!
    
    public static var fcmToken : String!
    public static var orderId : String!
    
    public static var openTime : String!
    public static var closeTime : String!
}
