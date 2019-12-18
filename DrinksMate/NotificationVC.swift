//
//  NotificationVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/9/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire

class NotificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate  {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var notificationTable: UITableView!
    
    var notificationList : [Notification]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.notificationList = []
        self.loadNotifications()
    }
    
    func loadNotifications() {
        let url = URL(string: AppUtil.serverURL + "notification/list")
        let headers = AppUtil.user.getAuthentification()

        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                
                return
            }

            let value = response.result.value as! [[String : Any]]
            
            self.notificationList = []
            for noti in value {
                let notification = Notification(notification: noti)
                self.notificationList.append(notification)
            }
            
            self.notificationTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification_cell", for: indexPath)
        
        let notification = self.notificationList[indexPath.row]
  
        let titleLbl = cell.viewWithTag(10) as! UILabel
        let bodyLbl = cell.viewWithTag(12) as! UILabel
        let dateLbl = cell.viewWithTag(11) as! UILabel
        
        titleLbl.text = notification.notificationTitle!
        bodyLbl.text = notification.notificationBody!
        
        let sendDateStr = "\(notification.notificationSendDate["month"]!)-\(notification.notificationSendDate["day"]!) \(notification.notificationSendDate["year"]!)"
        dateLbl.text = sendDateStr
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
