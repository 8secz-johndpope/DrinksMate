//
//  CategoryVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/12/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import iOSDropDown
import SDWebImage

class CategoryVC: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var sortTxt: DropDown!
    @IBOutlet weak var menuItemTable: UITableView!
    
    var barVC : BarVC!
    var isSub : Bool!
    var category : MenuCategory!
    var subCategory : SubCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // The list of array to display. Can be changed dynamically
        self.sortTxt.optionArray = ["A - Z", "Z - A", "Price: Low to High", "Price: High to Low"]
        self.sortTxt.didSelect { (selectedText , index ,id) in
            self.sortByIndex(index: index)
        }
    }
    
    func sortByIndex(index : Int) {
        switch index {
            case 0:
                if (self.isSub) {
                    self.subCategory.menuItems = self.subCategory.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemName ?? ""
                       let Obj2_Name = Obj2.menuitemName ?? ""
                       return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                    })
                }
                else {
                    self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemName ?? ""
                       let Obj2_Name = Obj2.menuitemName ?? ""
                       return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                    })
                }

                break
            case 1:
                if (self.isSub) {
                    self.subCategory.menuItems = self.subCategory.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemName ?? ""
                       let Obj2_Name = Obj2.menuitemName ?? ""
                       return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedDescending)
                    })
                }
                else {
                    self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemName ?? ""
                       let Obj2_Name = Obj2.menuitemName ?? ""
                       return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedDescending)
                    })
                }
                
                break
            case 2:
                if (self.isSub) {
                    self.subCategory.menuItems = self.subCategory.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemPrice ?? 0
                       let Obj2_Name = Obj2.menuitemPrice ?? 0
                       return (Obj1_Name < Obj2_Name)
                    })
                }
                else {
                    self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemPrice ?? 0
                       let Obj2_Name = Obj2.menuitemPrice ?? 0
                       return (Obj1_Name < Obj2_Name)
                    })
                }
                
                break
            case 3:
                if (self.isSub) {
                    self.subCategory.menuItems = self.subCategory.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemPrice ?? 0
                       let Obj2_Name = Obj2.menuitemPrice ?? 0
                       return (Obj1_Name > Obj2_Name)
                    })
                }
                else {
                    self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                       let Obj1_Name = Obj1.menuitemPrice ?? 0
                       let Obj2_Name = Obj2.menuitemPrice ?? 0
                       return (Obj1_Name > Obj2_Name)
                    })
                }

                break
            default:
                break
        }
        
        self.menuItemTable.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return self.isSub ? IndicatorInfo(title: self.subCategory.subcategoryName!) : IndicatorInfo(title: self.category.categoryName!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSub ? self.subCategory.menuItems.count : self.category.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitem_cell", for: indexPath) as! CategoryItemCell
        
        let menuItem = self.isSub ? self.subCategory.menuItems[indexPath.row] : self.category.menuItems[indexPath.row]
        cell.menuItem = menuItem
        cell.checkCarts()
        cell.barVC = self.barVC
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        let titleLbl = cell.viewWithTag(11) as! UILabel
        let priceLbl = cell.viewWithTag(12) as! UILabel
        
        imageView.sd_setImage(with: URL(string: menuItem.menuitemPhoto!), placeholderImage: UIImage(named: "beer_full.png"))
        
        titleLbl.text = menuItem.menuitemName!
        priceLbl.text = "$\(menuItem.menuitemPrice!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuItemVC") as! MenuItemVC
        vc.menuItem = self.isSub ? self.subCategory.menuItems[indexPath.row] : self.category.menuItems[indexPath.row]
        
        self.present(vc, animated: false, completion: nil)
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
