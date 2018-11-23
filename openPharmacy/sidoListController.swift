

import UIKit
import CoreLocation

class sidoListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    
    var sidoset = ["seoul", "gyeonggi" , "incheon", "busan", "daegu", "daejeon", "gwangju", "ulsan", "kangwon", "sejong", "chungbuk", "chungnam", "jeonbuk", "jeonnam", "gyeongbuk", "gyeongnam", "jeju"]
    var locationManager:CLLocationManager!
    
    lazy var list : [LocaleVO] = {
        var datalist = [LocaleVO]()
        
        for (sidoLogo) in self.sidoset {
            let mvo = LocaleVO()
            mvo.sidoLogo = sidoLogo
            
            datalist.append(mvo)
        }
        return datalist
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 1
        })
        getLocation()
        makeLogo()
    }
    
    @IBAction func gotoHome(_ sender: UIStoryboardSegue){
    }
    
    // MARK:- 2단계로 넘길 값 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sigunguOpen" {
            let path = self.collectionView.indexPath(for: sender as! UICollectionViewCell)

            let sigunguVC = segue.destination as? sigunguListController
            sigunguVC?.mvo = self.list[path!.row]
        }
    }
    
    // MARK:- 로고생성
    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    // MARK:- GPS 권한 요청
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
}

// MARK:- collectionView 설정
extension sidoListController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! sidoCell
        let row = self.list[indexPath.row]
        let logoName = "logo_\(row.sidoLogo!).png"
        cell.thumbnail.image = UIImage(named: logoName)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size/2-10, height: size/2-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    

}
