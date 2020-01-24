//
//  RewardsVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class RewardsVC: UIViewController, IndicatorInfoProvider, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var rewardsImg1: UIImageView!
    @IBOutlet weak var rewardsImg2: UIImageView!
    @IBOutlet weak var rewardsImg3: UIImageView!
    @IBOutlet weak var rewardsImg4: UIImageView!
    @IBOutlet weak var rewardsImg5: UIImageView!
    @IBOutlet weak var rewardsImg6: UIImageView!
    @IBOutlet weak var rewardsImg7: UIImageView!
    @IBOutlet weak var rewardsImg8: UIImageView!
    @IBOutlet weak var rewardsImg9: UIImageView!
    
    public var rewardsImages = ["beer_empty", "beer_empty", "beer_empty", "beer_empty", "beer_empty", "beer_empty", "beer_empty", "beer_empty", "beer_empty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let url = URL(string: AppUtil.serverURL + "order/rewards")
        let headers = AppUtil.user.getAuthentification()
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
            
            guard response.result.isSuccess else {

                return
            }

            let value = response.result.value!
            let count = Int(value)!

            for i in 0...8 {
                if (i < count) {
                    self.rewardsImages[i] = "beer_full"
                }
            }

            self.displayRewards(imgs: self.rewardsImages)
        }
    }
    
    func displayRewards(imgs : [String]) {
        self.rewardsImg1.image = UIImage(named: imgs[0])
        self.rewardsImg2.image = UIImage(named: imgs[1])
        self.rewardsImg3.image = UIImage(named: imgs[2])
        self.rewardsImg4.image = UIImage(named: imgs[3])
        self.rewardsImg5.image = UIImage(named: imgs[4])
        self.rewardsImg6.image = UIImage(named: imgs[5])
        self.rewardsImg7.image = UIImage(named: imgs[6])
        self.rewardsImg8.image = UIImage(named: imgs[7])
        self.rewardsImg9.image = UIImage(named: imgs[8])
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Rewards"
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
