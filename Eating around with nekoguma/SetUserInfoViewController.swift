//
//  SetUserInfoViewController.swift
//  Eating around with nekoguma
//
//  Created by 鈴木雄大 on 2021/01/25.
//

import UIKit

class SetUserInfoViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var UserName: UITextField!
    @IBAction func SaveButton(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(UserName.text, forKey: "userNames")
        //自分を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        //自分を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName.delegate = self
        let ud = UserDefaults.standard
        let un: String = ud.object(forKey: "userNames") as! String
        if(un != ""){
            UserName.text = un
        }
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        UserName.resignFirstResponder()
        return true
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            super.dismiss(animated: flag, completion: completion)
            guard let presentationController = presentationController else {
                return
            }
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }

}
