//
//  ViewController.swift
//  Eating around with nekoguma
//
//  Created by 鈴木雄大 on 2020/10/18.
//
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    //ロード時に呼ばれる
       override func viewDidLoad() {
           super.viewDidLoad()
           
           //シーンの作成
           sceneView.scene = SCNScene()
           
           //光源の有効化
           sceneView.autoenablesDefaultLighting = true;
           
           //ARSCNViewデリゲートの指定
           sceneView.delegate = self
       }
       
       //ビュー表示時に呼ばれる
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           //ARImageTrackingConfigurationの生成
           let configuration = ARImageTrackingConfiguration()

           //画像マーカーのリソースの指定
           configuration.trackingImages = ARReferenceImage.referenceImages(
               inGroupNamed: "AR Resources", bundle: nil)!
           
           //セッションの開始
           sceneView.session.run(configuration)
       }

       //ビュー非表示時に呼ばれる
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           //セッションの一時停止
           sceneView.session.pause()
       }
       
       //ARアンカー追加時に呼ばれる
       func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
           DispatchQueue.main.async {
               //ARAnchorの名前がbookの時
               if (anchor.name == "ippomarker2") {
                   //モデルノードの追加
                   let scene = SCNScene(named: "art.scnassets/ship.scn")
                   let modelNode = (scene?.rootNode.childNode(withName: "ship", recursively: false))!
                   modelNode.scale = SCNVector3(x: 40, y: 40, z: 40)
                   node.addChildNode(modelNode)
               }
           }
       }
    }
