//
//  OrderCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/12/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import SDWebImage

class OrderCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var orders : [MenuItem]!
    var type : Bool!
    var title : String!
    var homeVC : HomeVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.orders = []
        self.type = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadOrders() {
        self.typeLbl.text = self.title
        if (self.orders.count > 0) {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "order_collection_cell", for: indexPath)
        
        let menuItem = self.orders[indexPath.row]
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        let titleLbl = cell.viewWithTag(11) as! UILabel
        let priceLbl = cell.viewWithTag(12) as! UILabel
        
        imageView.sd_setImage(with: URL(string: menuItem.menuitemPhoto!), placeholderImage: UIImage(named: "beer_full.png"))
        
        titleLbl.text = menuItem.menuitemName!
        priceLbl.text = "$\(menuItem.menuitemPrice!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellSize = CGSize(width: 135, height: 135)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.homeVC.storyboard?.instantiateViewController(withIdentifier: "MenuItemVC") as! MenuItemVC
        vc.menuItem = self.orders[indexPath.row]
        
        self.homeVC.present(vc, animated: false, completion: nil)
    }

}
