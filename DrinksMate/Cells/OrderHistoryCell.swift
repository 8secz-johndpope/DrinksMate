//
//  OrderHistoryCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 12/8/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class OrderHistoryCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderCellTable: UITableView!
    
    var order : Order!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.order != nil) {
            return self.order.orderedItems.count + 2
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell_id = ""
        
        switch indexPath.row {
            case 0:
                cell_id = "orderid_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let titleLbl = table_cell.viewWithTag(10) as! UILabel
                let priceLbl = table_cell.viewWithTag(11) as! UILabel
                
                titleLbl.text = "#\(self.order.orderId!)"
                priceLbl.text = self.order.paymentResponse.transactionDate
                
                return table_cell
            
            case self.order.orderedItems.count + 1:
                cell_id = "orderstatus_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let titleLbl = table_cell.viewWithTag(10) as! UILabel
                let priceLbl = table_cell.viewWithTag(11) as! UILabel
                
                titleLbl.text = self.order.paymentStatus
                priceLbl.text = "$\(self.order.orderTotal!)"
                
                return table_cell
            
            default:
                cell_id = "orderitem_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let titleLbl = table_cell.viewWithTag(10) as! UILabel
                let priceLbl = table_cell.viewWithTag(11) as! UILabel
                let menuItem = self.order.orderedItems[indexPath.row - 1]
 //               titleLbl.text = menuItem.menuitemName!
                priceLbl.text = "$\(menuItem.menuitemPurchasePrice!)"
                
                return table_cell
        }
    }

}
