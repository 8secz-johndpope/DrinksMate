//
//  IntroCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/8/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit

class IntroCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro_collection_cell", for: indexPath)
        
        let imgView = cell.viewWithTag(10) as! UIImageView
        switch indexPath.row {
            case 0:
                imgView.image = UIImage(named: "carousal_1")
                break
            case 1:
                imgView.image = UIImage(named: "carousal_2")
                break
            case 2:
                imgView.image = UIImage(named: "carousal_3")
                break
            case 3:
                imgView.image = UIImage(named: "carousal_4")
                break
            case 4:
                imgView.image = UIImage(named: "carousal_5")
                break
            
            default:
                break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageCtrl.currentPage = indexPath.row
    }

}
