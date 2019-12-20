//
//  FirstVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 10/28/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import NotificationBannerSwift
import MediaPlayer

class FirstVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var homeImg: UIImageView!
    
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 3, animations: {
            self.logoImg.center.x = self.logoImg.center.x + 200
        }) { (isComplete) in
            // Do any additional setup after loading the view.
            self.playVideo()
        }
    }
    
    func playVideo() {

        let filepath: String? = Bundle.main.path(forResource: "splash_video", ofType: "mp4")
        if let filepath = filepath {
            let fileURL = URL.init(fileURLWithPath: filepath)
            player = AVPlayer(url: fileURL)
            
            playerLayer = AVPlayerLayer(player: player)

            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                timer.invalidate()
                
                let url = URL(string: AppUtil.serverURL + "features/6")
                // Config api
                Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in

                    self.player.pause()
                    
                    guard response.result.isSuccess else {
                        return
                    }

                    AppUtil.config = response.result.value as? [String: Any]
                    self.showMessage(msg: "Configuration Up To Date!")

                    self.homeImg.isHidden = true
                    self.logoImg.isHidden = true

                    let loginStatus = UserDefaults.standard.bool(forKey : "user_login")

                    if (loginStatus) {
                        self.backView.isHidden = true
                        self.ageView.isHidden = true

                        self.autoLogin()
                    }
                    else {
                        self.playerLayer.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func autoLogin() {
        let url = URL(string: AppUtil.serverURL + "auth/login")
        let params : Parameters = ["clientId": 6, "userEmail":UserDefaults.standard.string(forKey: "user_email")!, "userHashPassword": UserDefaults.standard.string(forKey: "user_password")!]

        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                
                self.playerLayer.removeFromSuperlayer()
                self.showErrorMessage(message: "Login Error!")
                return
            }

            let value = response.result.value as! [String: Any]
            let status = value["userHashPassword"] as! String
            
            if (status == "_invalid_password_") {
                self.showErrorMessage(message: "Invalid Password!")
            }
            else {
                AppUtil.user = DrinkUser()
                AppUtil.user.setDrinkUser(user: value)
            
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func showErrorMessage(message: String) {
        let banner = NotificationBanner(title: nil, subtitle: message, style: .danger)
        banner.duration = 1
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
    }
    
    @IBAction func yesAction(_ sender: Any) {
        self.backView.isHidden = true
        self.ageView.isHidden = true
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.backView.isHidden = true
        self.ageView.isHidden = true
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        vc.modalPresentationStyle = .popover
        vc.isPolicy = 2
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

    @IBAction func goSigninAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    @IBAction func goRegisterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false, completion: nil)
    }
    
    func showMessage(msg: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: msg)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
            // Completion Handler
            self.signinBtn.isHidden = false
            self.registerBtn.isHidden = false
            self.backView.isHidden = false
            self.ageView.isHidden = false
        }
    }
    
}
