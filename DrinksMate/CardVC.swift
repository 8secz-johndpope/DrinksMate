//
//  CardVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 1/22/20.
//  Copyright © 2020 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SWXMLHash

class CardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cardsTable: UITableView!
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    
    var params : [String : Any]!
    var cardsList : [PayCard]!
    var selectedCard : PayCard!
    var totalBudget : Double!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.hideBackView))
        self.backView.addGestureRecognizer(gesture)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadCards()
    }
    
    @objc func hideBackView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func loadCards() {
        self.cardsList = []
        if (self.cardsList.count == 0) {
            self.cardsTable.isHidden = true
            self.savedBtn.isHidden = true
        }
        
        let url = URL(string: AppUtil.serverURL + "checkout/savedcards")
        let headers = AppUtil.user.getAuthentification()
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            guard response.result.isSuccess else {

                return
            }
            
            let value = response.result.value as! [[String : Any]]
            
            for card in value {
                let payCard = PayCard(card: card)
                
                if (payCard.isDefault) {
                    self.selectedCard = payCard
                }
                self.cardsList.append(payCard)
            }
        
            if (self.cardsList.count > 0) {
                self.cardsTable.isHidden = false
                self.savedBtn.isHidden = false
            }
            self.cardsTable.reloadData()
        }
    }
    
    @IBAction func goSavedCardAction(_ sender: Any) {
        let url = URL(string: AppUtil.serverURL + "checkout/updateorder")

        let headers = AppUtil.user.getAuthentification()
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: self.params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
                        
            self.loadSavedPaymark()
        }
    }
    
    
    @IBAction func goNewCardAction(_ sender: Any) {
        let url = URL(string: AppUtil.serverURL + "checkout/updateorder")

        let headers = AppUtil.user.getAuthentification()
        
        HUD.show(.progress)
        Alamofire.request(url!, method: .post, parameters: self.params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            self.loadPaymark(orderId: AppUtil.orderId, totalBudget: self.totalBudget!)
        }
    }
    
    func loadSavedPaymark() {
        let url = URL(string: "https://demo.paymarkclick.co.nz/api/transaction/purchase/" + self.selectedCard.cardToken!)

        let headers = self.getPayAuthentification()
        let params = ["accountId" : AppUtil.pay.accountId!, "amount" : self.totalBudget!] as [String : Any]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            //HUD.hide()
            
            guard response.result.isSuccess else {

                return
            }
            
            self.completePay(paymarkJson: self.jsonToString(json: response.result.value! as! [String : Any]))
        }
    }
    
    func jsonToString(json: [String : Any]) -> String! {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            var convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            convertedString = convertedString!.replacingOccurrences(of: "\n", with: "")
            
            return convertedString
        } catch _ {
            return ""
        }

    }
    
    func getPayAuthentification() -> [String : String] {
        let user = AppUtil.pay.username!
        let password = AppUtil.pay.password!
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        return headers
    }
    
    func completePay(paymarkJson : String) {
        let url = URL(string: AppUtil.serverURL + "payment/completepaymarkwithpaymarkjson")

        let headers = AppUtil.user.getAuthentification()
        let params = ["applicationConfigurationId":AppUtil.pay.applicationConfigurationId!,"orderId":AppUtil.orderId!, "paymarkJson":paymarkJson] as [String : Any]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            HUD.hide()
            self.paymentView.isHidden = false
            
            guard response.result.isSuccess else {

                return
            }
            
            let order = Order(order: response.result.value as! [String : Any])
            
            if (order.paymentStatus != "SUCCESSFUL") {
                self.statusLbl.text = "PAYMENT DUE!"
                self.subLbl.isHidden = false
            }
            else {
                self.statusLbl.text = "PAYMENT SUCCESSFUL!"
                self.subLbl.isHidden = true
            }
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                timer.invalidate()

                AppUtil.cartsList = []
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func loadPaymark(orderId : String, totalBudget: Double) {
        let returnUrl = "http://107.150.52.222:8088/payment/completepaymark?orderId=\(orderId)&applicationConfigurationId=\(AppUtil.config["configurationId"]!)"
        let url = URL(string: "https://demo.paymarkclick.co.nz/api/webpayments/paymentservice/rest/WPRequest")!
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = ["username": 103969, "password": "OBh3C03ijPzBCm2a", "account_id": 625352, "cmd": "_xclick", "amount": totalBudget, "return_url": returnUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!, "store_payment_token" : 1, "tokenReference": AppUtil.user.userId!] as [String : Any]
                
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseString { response in
            
            HUD.hide()
            guard response.result.isSuccess else {

                return
            }
            
            let urlStr = SWXMLHash.parse(response.result.value!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayMarkVC") as! PayMarkVC
            vc.urlStr = urlStr["string"].element!.text
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "card_cell", for: indexPath) as! CardCell
        
        cell.cardVC = self
        cell.cardTable = tableView
        cell.loadCardCell(card: self.cardsList[indexPath.row])
        
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
