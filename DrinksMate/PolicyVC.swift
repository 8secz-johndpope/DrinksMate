//
//  PolicyVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/29/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import WebKit

class PolicyVC: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var isPolicy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var url = Bundle.main.url(forResource: "terms_conditions", withExtension: "htm", subdirectory: nil)!
        
        if (self.isPolicy) {
            url = Bundle.main.url(forResource: "privacy_policy", withExtension: "htm", subdirectory: nil)!
        }
        
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
