

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var mvo: LocaleVO!
    var coorlat = 0.0
    var coorlon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLogo()
        print("\(self.mvo.dutyName!)")
    }
    

    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        getLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: coorlat, longitude: coorlon, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coorlat, longitude: coorlon)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func getLocation(){
        //현재위치 가져오기
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let coor = locationManager.location?.coordinate
        coorlat = coor!.latitude
        coorlon = coor!.longitude
        print("latitude : " + String(describing: coor!.latitude) + " / longitude : " + String(describing: coor!.longitude))
        
    }
}
