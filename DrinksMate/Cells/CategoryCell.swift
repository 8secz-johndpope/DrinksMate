//
//  CategoryCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/13/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var homeVC : HomeVC!
    
    private let sectionInsets = UIEdgeInsets(top: 8.0,
                                             left: 8.0,
                                             bottom: 8.0,
                                             right: 8.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppUtil.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_collection_cell", for: indexPath)
        
        let category = AppUtil.categories[indexPath.row]
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        let titleLbl = cell.viewWithTag(11) as! UILabel
        
        imageView.sd_setImage(with: URL(string: category.photo!)) { (image, error, type, url) in
            imageView.image = image
        }
        
        titleLbl.text = category.categoryName!
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //2
        let paddingSpace = self.sectionInsets.left * (3 + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AppUtil.selectedCategory = indexPath.row
        
        let vc = self.homeVC.storyboard?.instantiateViewController(withIdentifier: "BarVC") as! BarVC
        self.homeVC.present(vc, animated: true , completion: nil)
        //self.homeVC.tabBarController?.selectedIndex = 2
    }
    
    func loadCategories() {
        
        if (AppUtil.categories.count > 0) {
            self.collectionView.reloadData()
        }        
    }

}
