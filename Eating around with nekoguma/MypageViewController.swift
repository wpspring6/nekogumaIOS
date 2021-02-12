//
//  MypageViewController.swift
//  Eating around with nekoguma
//
//  Created by 鈴木雄大 on 2021/01/17.
//

import UIKit

class MypageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var stampShopTable: UITableView!
    @IBAction func closeButton(_ sender: Any) {
        //自分を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var userIcon: UIImageView!
    
    @IBAction func editButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "modal")
        // delegateを設定
        vc?.presentationController?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    var articles: [[String: Any]] = [] {
        didSet {
            stampShopTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                navigationController?.navigationBar.setNeedsLayout()
            }
        let ud = UserDefaults.standard
        let un: String = ud.object(forKey: "userNames") as! String
        let userNameItem: String = un
        userName.text = userNameItem
        let urlString = "http://MacBook-Pro.local:1323/shops"
        guard let url = URLComponents(string: urlString) else { return }
        // HTTPメソッドを実行
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            do {
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                guard let _data = data else { return }
                print(_data)
                // JSONデコード
                let users = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                let articles = users.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
                DispatchQueue.main.async() { () -> Void in
                    self.articles = articles
                }
                print(articles)
            }
            catch {
                print(error)
            }
        }
        task.resume()
        userIcon.isUserInteractionEnabled = true

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.performSegue(withIdentifier: "userIconset", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Table Viewのセルの数を指定
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    //各セルの要素を設定する
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = stampShopTable.dequeueReusableCell(withIdentifier: "tableCell",
                                             for: indexPath)
        
        
        // Tag番号 1 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(1) as! UIImageView
        let image =  articles[indexPath.row]["Shop_img"] as? String ?? ""
        let imageUrl = "http://MacBook-Pro.local:5500/golang/images/\(image)"
        imageView.image = getImageByUrl(url:imageUrl)
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = String(describing: articles[indexPath.row]["Shop_name"] as? String ?? "")
        
        // Tag番号 ３ で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(3) as! UILabel
        label2.text = String(describing: articles[indexPath.row]["Shop_detail"] as? String ?? "")
        
        return cell
    }
    // Cell の高さを１２０にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}

extension MypageViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    // ChildViewControllerのDismissを検知
    viewDidLoad()
  }
}
