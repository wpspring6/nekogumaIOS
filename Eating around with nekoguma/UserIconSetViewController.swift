//
//  UserIconSetViewController.swift
//  Eating around with nekoguma
//
//  Created by 鈴木雄大 on 2021/01/29.
//

import UIKit
import Photos

class UserIconSetViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBAction func backAction(_ sender: Any) {
        //自分を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func editUserIcon(_ sender: Any) {
        confirmPhotoLibraryAuthenticationStatus()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        let cameraAction = UIAlertAction(title: "写真を撮る", style: .default) { (action) in
          if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                // トリミングを可能にする
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
        let albumAction = UIAlertAction(title: "写真を選択", style: .default) { (action) in
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
            }
        }
        // キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
    private func confirmPhotoLibraryAuthenticationStatus() {
            //権限の現状確認(許可されているかどうか)
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                //許可(authorized)されていない・ここで初回のアラートが出る
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    //もし状態(status)が、初回(notDetermined)もしくは拒否されている(denied)の場合
                    case .notDetermined, .denied:
                    //許可しなおして欲しいので、設定アプリへの導線をおく
                        self.appearChangeStatusAlert()
                    default:
                        break
                    }
                }
            }
        }
    
    private func appearChangeStatusAlert() {
            //フォトライブラリへのアクセスを許可していないユーザーに対して設定のし直しを促す。
            //タイトルとメッセージを設定しアラートモーダルを作成する
            let alert = UIAlertController(title: "Not authorized", message: "we need to access photo library to upload video", preferredStyle: .alert)
            //アラートには設定アプリを起動するアクションとキャンセルアクションを設置
            let settingAction = UIAlertAction(title: "setting", style: .default, handler: { (_) in
                guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
            })
            let closeAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            //アラートに上記の２つのアクションを追加
            alert.addAction(settingAction)
            alert.addAction(closeAction)
            //アラートを表示させる
            self.present(alert, animated: true, completion: nil)
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
