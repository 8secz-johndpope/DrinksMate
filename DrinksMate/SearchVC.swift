//
//  SearchVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/4/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var menuItemTable: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var notFoundLbl: UILabel!
    
    var menuItems = [] as! [MenuItem]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (self.menuItems.count == 0) {
            self.notFoundLbl.isHidden = false
        }
        else {
            self.notFoundLbl.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitem_cell", for: indexPath) as! CategoryItemCell
        
        let menuItem = self.menuItems[indexPath.row]
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
        vc.menuItem = self.menuItems[indexPath.row]
        
        self.present(vc, animated: false, completion: nil)
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
