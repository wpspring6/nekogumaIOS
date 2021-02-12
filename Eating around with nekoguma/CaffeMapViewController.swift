import UIKit
import MapKit
import CoreLocation

class CaffeMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let lm = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goBackCenter()
        //ピンのタップを通知
        mapView.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        
        let coordinate = CLLocationCoordinate2DMake(35.7992511,139.5995298)
        //ピンを生成
        let myPin = MKPointAnnotation()
        //ピンの座標設定
        myPin.coordinate = coordinate
        //タイトル、サブタイトルを設定
        myPin.title = "カフェモート"
        //mapViewにピンを追加
        mapView.addAnnotation(myPin)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            print(annotation.title!!)
        }
    }

    private func goBackCenter() {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: false)
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
