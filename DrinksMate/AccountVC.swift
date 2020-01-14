//
//  AccountVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/4/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import IQKeyboardManager

class AccountVC: ButtonBarPagerTabStripViewController, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var menuBtn: UIButton!
    var fromWhere: Int!
    
    override func viewDidLoad() {
        self.settings.style.selectedBarHeight = 2
        self.settings.style.buttonBarItemBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemTitleColor = UIColor.systemBlue
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = self.view.frame.width / 2 - self.buttonBarView.selectedBar.frame.width / 2
        self.settings.style.buttonBarRightContentInset = self.view.frame.width / 2 - self.buttonBarView.selectedBar.frame.width / 2
        self.settings.style.buttonBarMinimumInteritemSpacing = 70
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ButtonBar Type
        self.buttonBarView.selectedBar.backgroundColor = UIColor.systemBlue
        self.containerView.shouldIgnoreScrollingAdjustment = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear (true)
        
        if (self.fromWhere == 1) {
            self.moveToViewController(at: 1)
        }
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func showMenuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountMenuVC") as! AccountMenuVC
        
        vc.accountVC = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            vc.preferredContentSize = CGSize(width: 200, height: 240)
            
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            
            popover.permittedArrowDirections = .any
            popover.sourceView = self.view
            popover.sourceRect = self.menuBtn.frame
            popover.delegate = self
            
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
    
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let resetPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassVC") as! ResetPassVC
        let wishVC = self.storyboard?.instantiateViewController(withIdentifier: "WishListVC") as! WishListVC
        let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        ordersVC.fromWhere = true
        
        return [profileVC, ordersVC, wishVC, resetPassVC]
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
