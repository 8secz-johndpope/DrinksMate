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
    
    var category : MenuCategory!

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
                self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                   let Obj1_Name = Obj1.menuitemName ?? ""
                   let Obj2_Name = Obj2.menuitemName ?? ""
                   return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                })
                break
            case 1:
                self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                   let Obj1_Name = Obj1.menuitemName ?? ""
                   let Obj2_Name = Obj2.menuitemName ?? ""
                   return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedDescending)
                })
                break
            case 2:
                self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                   let Obj1_Name = Obj1.menuitemPrice ?? 0
                   let Obj2_Name = Obj2.menuitemPrice ?? 0
                   return (Obj1_Name < Obj2_Name)
                })
                break
            case 3:
                self.category.menuItems = self.category.menuItems.sorted(by: { (Obj1, Obj2) -> Bool in
                   let Obj1_Name = Obj1.menuitemPrice ?? 0
                   let Obj2_Name = Obj2.menuitemPrice ?? 0
                   return (Obj1_Name > Obj2_Name)
                })
                break
            default:
                break
        }
        
        self.menuItemTable.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.category.categoryName!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitem_cell", for: indexPath)
        
        let menuItem = self.category.menuItems[indexPath.row]
        
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
        vc.menuItem = self.category.menuItems[indexPath.row]
        
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
