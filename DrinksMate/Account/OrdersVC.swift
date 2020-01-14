//
//  OrdersVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip

class OrdersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider  {
    
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var fromWhere : Bool! = false
    var orderList : [Order]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (self.fromWhere) {
            self.headerView.isHidden = true
            self.headerHeight.constant = -20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.orderList = []
        self.loadOrderHistory()
    }
    
    @IBAction func goHomeAction(_ sender: Any) {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
        mainVC?.modalPresentationStyle = .fullScreen
        self.present(mainVC!, animated: true, completion: nil)
    }
    
    
    func loadOrderHistory() {
        let url = URL(string: AppUtil.serverURL + "order/previousorders")
        let headers = AppUtil.user.getAuthentification()
        let params = ["offset": 0, "limit":10]
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                
                return
            }

            let value = response.result.value as! [[String : Any]]
            
            self.orderList = []
            for order in value {
                let orderHistory = Order(order: order)
                self.orderList.append(orderHistory)
            }
            
            self.ordersTable.reloadData()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Orders"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let orderItem = self.orderList[indexPath.row]
        return CGFloat(30 * (orderItem.orderedItems.count + 2) + 24)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_cell", for: indexPath) as! OrderHistoryCell
        cell.order = self.orderList[indexPath.row]
        cell.orderCellTable.reloadData()
        
        return cell
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
