//
//  AccountVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/4/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AccountVC: ButtonBarPagerTabStripViewController, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ButtonBar Type
        self.buttonBarView.selectedBar.backgroundColor = UIColor.systemBlue
        self.settings.style.selectedBarHeight = 2
        self.settings.style.buttonBarItemBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemTitleColor = UIColor.systemBlue
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func showMenuAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountMenuVC") as! AccountMenuVC
        
        vc.accountVC = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            vc.preferredContentSize = CGSize(width: 240, height: 320)
            
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
        let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsVC") as! RewardsVC
        
        return [profileVC, resetPassVC, addressVC, ordersVC, rewardsVC]
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
