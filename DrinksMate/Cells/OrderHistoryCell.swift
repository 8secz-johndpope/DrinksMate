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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
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
                
                let format = DateFormatter()
                
                if (self.order.paymentResponse != nil) {
                    
                    format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let due_date = format.date(from: self.order.paymentResponse.transactionDate!)
                    format.dateFormat = "MMM dd, yyyy HH:mm a"
                    format.amSymbol = "AM"
                    format.pmSymbol = "PM"
                    
                    priceLbl.text = format.string(from: due_date!)
                }
                else {
                    format.dateFormat = "MMM dd, yyyy HH:mm a"
                    format.amSymbol = "AM"
                    format.pmSymbol = "PM"
                    
                    priceLbl.text = format.string(from: Date(timeIntervalSince1970: TimeInterval(self.order.orderId! / 1000)))
                }
                
                return table_cell
            
            case self.order.orderedItems.count + 1:
                cell_id = "orderstatus_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let titleLbl = table_cell.viewWithTag(10) as! UILabel
                let priceLbl = table_cell.viewWithTag(11) as! UILabel
                
                titleLbl.text = "PAYMENT " + self.order.paymentStatus
                if (self.order.paymentStatus != "SUCCESSFUL") {
                    titleLbl.text = "PAYMENT DUE"
                }
                
                priceLbl.text = "$\(self.order.orderTotal!)"
                
                return table_cell
            
            default:
                cell_id = "orderitem_cell"
                let table_cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath)
                let titleLbl = table_cell.viewWithTag(10) as! UILabel
                let priceLbl = table_cell.viewWithTag(11) as! UILabel
                let menuItem = self.order.orderedItems[indexPath.row - 1]
                titleLbl.text = menuItem.menuitemName!
                priceLbl.text = "$\(menuItem.menuitemPurchasePrice!)"
                
                return table_cell
        }
    }

}
