

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    var locationManager:CLLocationManager!
    var mvo: LocaleVO!
    var coorlat = 0.0
    var coorlon = 0.0

    var mapView: GMSMapView!


    // 리스트에서 받을 인자들
    var prepareOpenData: [[String:String]]!
    var prepareCloseData: [[String:String]]!
    var prepareOneData: [String:String]!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(prepareOneData["dutyLat"]!)!, longitude: Double(prepareOneData["dutyLon"]!)!, zoom: 17.0)
        
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        
        
        
//        self.view.addSubview(self.mapView)
        view = mapView
        self.mapView.delegate = self
        
//        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        mapView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0)
//        mapView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0)
        
        for item in prepareOpenData {
            let marker = GMSMarker()
            guard item["dutyLat"] != "" || item["dutyLon"] != "" else {
                continue
            }
            marker.position = CLLocationCoordinate2D(latitude: Double(item["dutyLat"]!)!, longitude: Double(item["dutyLon"]!)!)
            marker.title = item["dutyName"]
            marker.snippet = item["dutyAddr"]
            marker.userData = item
            marker.map = mapView
        }
        
        for item in prepareCloseData {
            let marker = GMSMarker()
            guard item["dutyLat"] != "" || item["dutyLon"] != "" else {
                continue
            }
            marker.position = CLLocationCoordinate2D(latitude: Double(item["dutyLat"]!)!, longitude: Double(item["dutyLon"]!)!)
            marker.title = item["dutyName"]
            marker.snippet = item["dutyAddr"]
            marker.userData = item
            marker.map = mapView
        }
        
        
        
        
        print("print : \(prepareOneData!)")
        makeLogo()
    }
    // 상단 로고생성
    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    
    // viewdidload보다 빠르게 지도 생성 및 마커 생성
    override func loadView() {
        super.loadView()
        
        
        
    }
    
    ///////////
    class func instanceFromNib() -> CustomInfoWindow {
        return UINib(nibName: "CustomInfoWindow", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomInfoWindow
    }
    var tappedMarker = GMSMarker()
    var infoWindow = CustomInfoWindow()
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let index:Int! = Int(marker.accessibilityLabel!)
        print(index)
        
        let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        tappedMarker = marker
        infoWindow.removeFromSuperview()
        
        infoWindow = MapViewController.instanceFromNib()
        
        let dictionary = marker.userData as! [String : AnyObject]
        var openTime = dictionary["dutyTimes"] as? String
        var closeTime = dictionary["dutyTimec"] as? String
        openTime!.insert(":", at: openTime!.index(openTime!.startIndex, offsetBy: 2))
        closeTime!.insert(":", at: closeTime!.index(closeTime!.startIndex, offsetBy: 2))
        
        
        infoWindow.infoName.text = marker.title
        infoWindow.infoAddr.text = marker.snippet
        infoWindow.infoTell.text = dictionary["dutyTell"] as? String
        infoWindow.infoTime.text = "영업시간 : \(String(describing: openTime!)) ~ \(String(describing: closeTime!))"
        switch dictionary["dutyStatus"] as? String {
        case "영업 종료":
            infoWindow.infoStatus.textColor = UIColor.red
            infoWindow.infoStatus.text = dictionary["dutyStatus"] as? String
        default:
            infoWindow.infoStatus.text = dictionary["dutyStatus"] as? String
        }
        infoWindow.infoDist.text = "\(dictionary["distance"] as! String)km"
        
        infoWindow.center = mapView.projection.point(for: location)
        
        infoWindow.center.y = infoWindow.center.y - 107
//        infoWindow.infoBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        infoWindow.layer.cornerRadius = 5;
//        infoWindow.layer.masksToBounds = true
        
        infoWindow.layer.borderColor = UIColor(red: 46/255, green: 118/255, blue: 185/255, alpha: 1).cgColor
        infoWindow.layer.borderWidth = 3
        
        infoWindow.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        infoWindow.layer.shadowColor = UIColor.black.cgColor
        infoWindow.layer.shadowRadius = 4;
        infoWindow.layer.shadowOpacity = 0.9;
        
        self.view.addSubview(infoWindow)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 107
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
        
    }
    
    
    
    @objc func buttonTapped(sender: UIButton) {
        print("Yeah! Button is tapped!")
        
    }

    
}
