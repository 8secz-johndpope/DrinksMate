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
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    
    var totalBudget : Double!
    var urlStr : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HUD.show(.progress)
        
        self.webView.delegate = self
        let request = URLRequest(url: URL(string: self.urlStr)!)
        self.webView.loadRequest(request)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {

        //webView.loadRequest(URLRequest(url: URL(string: "")!))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let urlStr = request.url!.absoluteString
        if (urlStr.contains("https://app/")) {
            
            let url = URL(string: AppUtil.serverURL + "payment/status?orderId=" + AppUtil.orderId)!
            
            let headers = AppUtil.user.getAuthentification()
            //let params = ["orderId" : AppUtil.orderId]
            
            HUD.show(.progress)
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers).validate().responseJSON { response in
                
                HUD.hide()
                self.paymentView.isHidden = false
                
                guard response.result.isSuccess else {

                    return
                }
                
                let order = Order(order: response.result.value as! [String : Any])
                
                if (order.paymentStatus != "SUCCESSFUL") {
                    self.statusLbl.text = "PAYMENT DUE!"
                    self.subLbl.isHidden = false
                }
                else {
                    self.statusLbl.text = "PAYMENT SUCCESSFUL!"
                    self.subLbl.isHidden = true
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    timer.invalidate()

                    AppUtil.cartsList = []
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
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
