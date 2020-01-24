//
//  CardCell.swift
//  DrinksMate
//
//  Created by LeemingJin on 1/22/20.
//  Copyright © 2020 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class CardCell: UITableViewCell {
    
    @IBOutlet weak var optionImg: UIImageView!
    @IBOutlet weak var cardNameLbl: UILabel!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var cardExpyLbl: UILabel!
    
    var payCard : PayCard!
    var cardTable : UITableView!
    var cardVC : CardVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func loadCardCell(card : PayCard) {
        self.payCard = card
        
        self.cardExpyLbl.text = "Expiry:" + card.cardExpiry
        self.cardNameLbl.text = card.cardType
        self.cardNumberLbl.text = card.cardNumber
        self.optionImg.isHidden = !card.isDefault
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let url = URL(string: AppUtil.serverURL + "checkout/deletecard")
        let headers = AppUtil.user.getAuthentification()
        let params = ["cardId" : self.payCard.cardId!] as [String : Any]
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            
            self.cardVC.loadCards()
        }
    }
    
    @IBAction func selectAction(_ sender: Any) {
        if (!self.payCard.isDefault) {
            self.optionImg.isHidden = self.payCard.isDefault
            self.payCard.isDefault = !self.payCard.isDefault
            
            self.setDefaultCard()
        }
    }
    
    func setDefaultCard() {
        let url = URL(string: AppUtil.serverURL + "checkout/carddefault")
        let headers = AppUtil.user.getAuthentification()
        let params = ["cardId" : self.payCard.cardId!, "userId" : self.payCard.userId!] as [String : Any]
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            
            self.cardVC.loadCards()
        }
    }
}
