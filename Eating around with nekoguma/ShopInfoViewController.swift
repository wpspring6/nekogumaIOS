//
//  ShopInfoViewController.swift
//  cooper
//
//  Created by 鈴木雄大 on 2020/06/01.
//  Copyright © 2020 y.suzuki. All rights reserved.
//

import UIKit

class ShopInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    // section毎の画像配列
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    let imgArray: NSArray = [
        "banana","banana",
        "banana","banana",
        "banana","banana",
        "banana","banana"]
    var received : Int?
    @IBOutlet weak var shopImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shopId: Int? = self.received! - 1
        
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
                DispatchQueue.main.async {
                    // メインスレッドで表示
                    self.label.text = String(describing: articles[shopId ?? 0]["ShopName"] as? String ?? "")
                    self.label2.text = String(describing: articles[shopId ?? 0]["ShopComment"] as? String ?? "")
                    let image =  articles[shopId ?? 0]["ShopImage"] as? String ?? ""
                    let imageUrl = "http://MacBook-Pro.local:5500/golang/images/\(image)"
                    self.shopImage.image = self.getImageByUrl(url:imageUrl)
                }
                print(articles)
            }
            catch {
                print(error)
            }
        }
            task.resume()
        // Container
        // Do any additional setup after loading the view.
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

    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //セルの数を指定する
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
       }
       //セルの中身を指定する（ここでは背景色を指定）
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // "Cell" はストーリーボードで設定したセルのID
       let testCell:UICollectionViewCell =
           collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                              for: indexPath)
       // Tag番号を使ってImageViewのインスタンス生成
       let imageView = testCell.contentView.viewWithTag(1) as! UIImageView
        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        let cellImage = UIImage(named: imgArray[indexPath.row] as! String)
       // UIImageをUIImageViewのimageとして設定
       imageView.image = cellImage
       return testCell
       }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            // section数は１つ
            return 1
        }
}
