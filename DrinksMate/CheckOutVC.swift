//
//  CheckOutVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/30/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire

class CheckOutVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var selectedAddress : UserAddress!
    
    var totalBudget : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AppUtil.isAddressSelected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let url = URL(string: AppUtil.serverURL + "checkout/addresses")
        let headers = AppUtil.user.getAuthentification()
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                
                return
            }

            let value = response.result.value as! [[String : Any]]
            
            AppUtil.addressList = []
            for address in value {
                let userAddress = UserAddress(address: address)
                
                if (AppUtil.isAddressSelected && userAddress.isDefault) {
                    self.selectedAddress = userAddress
                    AppUtil.isAddressSelected = false
                }
                
                AppUtil.addressList.append(userAddress)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
            case AppUtil.cartsList.count:
                return 90
            case AppUtil.cartsList.count + 2:
                return 740
            default:
                return 45
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return AppUtil.cartsList.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell_id = ""
        
        switch indexPath.row {
            
            case AppUtil.cartsList.count:
                cell_id = "fee_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let totalLbl = table_cell.viewWithTag(10) as! UILabel
                
                self.totalBudget = 0.0
                
                for item in AppUtil.cartsList {
                    let menuitemPrice = item.menuitemPrice! * Double(item.cartsNumber!)
                    
                    self.totalBudget = self.totalBudget + menuitemPrice
                }
                
                totalLbl.text = "$\(self.totalBudget!)"
                
                return table_cell
            case AppUtil.cartsList.count + 1:
                cell_id = "total_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                
                let totalLbl = table_cell.viewWithTag(10) as! UILabel
                let total = self.totalBudget! + 6.99
                
                totalLbl.text = String.init(format: "$%.2f", total)
                
                return table_cell
            
            case AppUtil.cartsList.count + 2:
                cell_id = "last_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CheckoutCell
                table_cell.checkoutVC = self
                table_cell.tableView = tableView
                if (self.selectedAddress != nil) {
                    table_cell.selectedAddress = self.selectedAddress
                    table_cell.loadSelectedAddress()
                    self.selectedAddress = nil
                }
                
                return table_cell
            
            default:
                cell_id = "cart_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! CartCell
                table_cell.setMenuItemCell(item: AppUtil.cartsList[indexPath.row])
                table_cell.tableView = tableView
                return table_cell
        }
    }
    
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
