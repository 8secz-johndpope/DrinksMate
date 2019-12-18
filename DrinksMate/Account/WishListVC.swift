//
//  WishListVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/27/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PKHUD
import NotificationBannerSwift
import Alamofire

class WishListVC: UIViewController,UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var wishTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var notFoundLbl: UILabel!
    
    var isSub : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (self.isSub) {
            self.headerView.isHidden = true
            self.headerHeight.constant = -20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        AppUtil.wishlist = []
        
        let headers = AppUtil.user.getAuthentification()
        let url = URL(string: AppUtil.serverURL + "wishlist/list")
        HUD.show(.progress)
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {
                
                self.showErrorMessage(message: "Loading Failed!")
                return
            }

            let value = response.result.value as! [[String: Any]]
            
            AppUtil.wishlist = []
            for item in value {
                let menuItem = MenuItem()
                menuItem.setMenuItem(item: item)
                
                AppUtil.wishlist.append(menuItem)
            }
            
            if (AppUtil.wishlist.count == 0) {
                self.notFoundLbl.isHidden = false
            }
            else {
                self.notFoundLbl.isHidden = true
            }
            
            self.wishTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppUtil.wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitem_cell", for: indexPath) as! WishlistCell
        
        let menuItem = AppUtil.wishlist[indexPath.row]
        
        cell.tableView = tableView
        cell.menuItem = menuItem
        cell.checkCarts()
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        let titleLbl = cell.viewWithTag(11) as! UILabel
        let priceLbl = cell.viewWithTag(12) as! UILabel
        
        imageView.sd_setImage(with: URL(string: menuItem.menuitemPhoto!)) { (image, error, type, url) in
            imageView.image = image
        }
        
        titleLbl.text = menuItem.menuitemName!
        priceLbl.text = "$\(menuItem.menuitemPrice!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuItemVC") as! MenuItemVC
        vc.menuItem = AppUtil.wishlist[indexPath.row]
        
        self.present(vc, animated: false, completion: nil)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        self.isSub = true
        return "Wish List"
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: 200, height: 360)
        
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        
        popover.permittedArrowDirections = .any
        popover.sourceView = self.view
        popover.sourceRect = self.menuBtn.frame
        popover.delegate = self
        
        vc.homeVC = self
        present(vc, animated: false, completion: nil)
        //self.present(vc, animated: false, completion: nil)
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
