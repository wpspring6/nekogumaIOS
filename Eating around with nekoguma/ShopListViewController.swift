//
//  ShopListViewController.swift
//  Eating around with nekoguma
//
//  Created by 鈴木雄大 on 2020/10/18.
//

import UIKit
 
class ShopListViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var table:UITableView!
    @IBOutlet weak var serchBar: UISearchBar!
    @IBAction func userInfoButton(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.register(defaults: ["userNames" : ""])
        let un: String = ud.object(forKey: "userNames") as! String
        if(un != ""){
            self.performSegue(withIdentifier: "registered", sender: nil)
        }else{
            self.performSegue(withIdentifier: "unregistered", sender: nil)
        }
    }
    
    
        
    // section毎の画像配列
    let imgArray: NSArray = [
        "coffe_image","coffe_image",
        "coffe_image","coffe_image",
        "coffe_image","coffe_image",
        "coffe_image","coffe_image",
        "coffe_image","coffe_image",
        "coffe_image","coffe_image",
        "coffe_image","coffe_image"]
    
    struct User: Codable {
        var Shop_id: Int
        var Shop_name: String
        var Shop_detail: String
        var Created_at: Date
        var Updated_at: Date
    }
    
    //検索結果配列
    var searchResult: [[String: Any]] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    var articles: [[String: Any]] = [] {
        didSet {
            table.reloadData()
        }
    }
    var shopId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デリゲート先を自分に設定する。
        serchBar.delegate = self
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
                    self.searchResult = articles
                }
                print(articles)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Table Viewのセルの数を指定
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    //各セルの要素を設定する
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell",
                                             for: indexPath)
        
        
        // Tag番号 1 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(1) as! UIImageView
        let image =  searchResult[indexPath.row]["ShopImage"] as? String ?? ""
        let imageUrl = "http://MacBook-Pro.local:5500/golang/images/\(image)"
        print(imageUrl);
        imageView.image = getImageByUrl(url:imageUrl)
        
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = String(describing: searchResult[indexPath.row]["ShopName"] as? String ?? "")
        
        // Tag番号 ３ で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(3) as! UILabel
        label2.text = String(describing: searchResult[indexPath.row]["ShopComment"] as? String ?? "")
        
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
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath){
        table.deselectRow(at: indexPath, animated: true)
        shopId = searchResult[indexPath.row]["ShopID"] as? Int
        performSegue(withIdentifier: "shopSegue",sender: shopId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopSegue" {
            let secondViewController = segue.destination as! ShopInfoViewController
            secondViewController.received = sender as? Int
        }
    }
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる。
        serchBar.endEditing(true)
    }
    
    //テキスト変更時の呼び出しメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //検索結果配列を空にする。
            searchResult.removeAll()
            
            if(serchBar.text == "") {
                //検索文字列が空の場合はすべてを表示する。
                searchResult = articles
            } else {
                //検索文字列を含むデータを検索結果配列に追加する。
                for data in articles {
                    let shopData: String = data["ShopName"]! as! String
                    if shopData.contains(serchBar.text!) {
                        searchResult.append(data)
                    }
                }
            }
            //テーブルを再読み込みする。
            table.reloadData()
        }
}

