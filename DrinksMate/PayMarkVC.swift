//
//  PayMarkVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import PKHUD

class PayMarkVC: UIViewController, UIPopoverPresentationControllerDelegate, UIWebViewDelegate {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var orderId : Int!
    var totalBudget : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.delegate = self
        loadPaymark()
    }
    
    func loadPaymark() {
        let returnUrl = "http://107.150.52.222:8088/payment/completepaymark?orderId=\(self.orderId!)&applicationConfigurationId=\(AppUtil.config["configurationId"]!)"
        let url = URL(string: "https://demo.paymarkclick.co.nz/api/webpayments/paymentservice/rest/WPRequest")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = ["username": 103969, "password": "OBh3C03ijPzBCm2a", "account_id": 625352, "cmd": "_xclick", "amount": self.totalBudget!, "return_url": returnUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!] as [String : Any]
                
        HUD.show(.progress)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseString { response in
            
            HUD.hide()
            guard response.result.isSuccess else {

                return
            }

            let urlStr = SWXMLHash.parse(response.result.value!)
            
            
            let request = URLRequest(url: URL(string: urlStr["string"].element!.text)!)

            self.webView.loadRequest(request)
        }
        
    }
    
    
    @IBAction func notificationAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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