
import UIKit
import CoreLocation

class ListPharmacyController: UITableViewController, XMLParserDelegate, CLLocationManagerDelegate {
    
    var xmlParser = XMLParser()
    var viewWidth = 0
    var currentElement = ""                // 현재 Element
    var pharAllItems = [[String : String]]() // item Dictional Array
    var pharAllItem = [String: String]()     // item Dictionary
    var pharCloseItems = [[String : String]]() // item Dictional Array
    var pharCloseItem = [String: String]()     // item Dictionary
    var pharOpenItems = [[String : String]]() // item Dictional Array
    var pharOpenItem = [String: String]()     // item Dictionary
    
    var dutyName = ""           // 약국 이름
    var dutyAddr = ""           // 약국 주소
    var dutyAddrDetail = ""     // 상세 주소
    var dutyTell = ""           // 전화번호
    var dutyTimec = ""         // 오픈시간
    var dutyTimes = ""         // 종료시간
    var dutyLat = ""
    var dutyLon = ""
    var distance = ""
    
    var mvo: LocaleVO!
    var locationManager:CLLocationManager!
    
    var coorlat = 0.0
    var coorlon = 0.0
    // 시간 계산
    let cal = Calendar.current
    let date = Date()
    
    let section = ["영업 중", "영업 종료"]
    
    var temp = [String]()
    var count = 0
    
    lazy var list : [LocaleVO] = {
        var datalist = [LocaleVO]()
        for row in self.pharCloseItems{
            let mvo = LocaleVO()
            mvo.dutyName = self.pharCloseItems[count]
            
            datalist.append(mvo)
        }
        
        return datalist
    }()
    
    
    func requestMovieInfo(_ s1: String, _ s2: String) {
        // OPEN API 주소
        let sido = s1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let sigungu = s2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let weekday = cal.component(.weekday, from: date) - 1
        let urlStr = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=tksRzRc3Vk7YN6lfzN86PfaFhlZNsTGI1h2RxwYwpG7DBEX0ntu2%2F1ZjhiEQWnUR23s6fcj1qX8sHa355uKrlA%3D%3D&Q0=\(sido)&Q1=\(sigungu)&QT=\(weekday)&ORD=NAME&pageNo=1&startPage=1&numOfRows=100&pageSize=10"
        guard let xmlParser = XMLParser(contentsOf: URL(string: urlStr)!) else { return }
        
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if (elementName == "item") {
            pharAllItem = [String : String]()
            dutyName = ""
            dutyAddr = ""
            dutyAddrDetail = ""
            dutyTell = ""
            dutyTimec = ""
            dutyTimes = ""
            dutyLat = ""
            dutyLon = ""
            distance = ""
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            pharAllItem["dutyName"] = dutyName
            pharAllItem["dutyAddr"] = dutyAddr
            pharAllItem["dutyAddrDetail"] = dutyAddrDetail
            pharAllItem["dutyTell"] = dutyTell
            pharAllItem["dutyTimec"] = dutyTimec
            pharAllItem["dutyTimes"] = dutyTimes
            pharAllItem["dutyLat"] = dutyLat
            pharAllItem["dutyLon"] = dutyLon
            if let _ = Double(dutyLat) , let _ = Double(dutyLon){
                pharAllItem["distance"] = distanceKm(lat: Double(dutyLat)!, lon: Double(dutyLon)!)
            } else {
                pharAllItem["distance"] = "9999999999"
            }
            
            
            pharAllItems.append(pharAllItem)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        let weekday = cal.component(.weekday, from: date) - 1
        if (currentElement == "dutyAddr") {
            dutyAddr = string
        } else if (currentElement == "dutyName") {
            dutyName += string
        } else if (currentElement == "dutyMapimg") {
            dutyAddrDetail = string
        } else if (currentElement == "dutyTel1") {
            dutyTell = string
        } else if (currentElement == "dutyTime\(weekday)c") {
            dutyTimec = string
        } else if (currentElement == "dutyTime\(weekday)s") {
            dutyTimes = string
            if (string == "09  ") {
                dutyTimes = "0900"
            }
        } else if (currentElement == "wgs84Lat") {
            dutyLat = string
        } else if (currentElement == "wgs84Lon") {
            dutyLon = string
        }
    }
    
    // 거리별 정렬 메소드
    func sort() {
        
        let sortFunc = {
            (s1: [String:String], s2: [String:String]) -> Bool in
            if Double(s1["distance"]!)! < Double(s2["distance"]!)! {
                return true
            } else {
                return false
            }
        }
        
        pharOpenItems.sort(by: sortFunc)
        pharCloseItems.sort(by: sortFunc)
        
        
        tableView.reloadData()
    }
    
    
    
    
    
    override func viewDidLoad() {
        // 받은 값 확인
        NSLog("linkurl = \(self.mvo.sigungu!)")
        
        let locale = self.mvo.sigungu!.split(separator: " ")
        let sido = String(locale[locale.count-2])
        let sigungu = String(locale[locale.count-1])
        // 로고생성
        makeLogo()
        // backbutton수정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        getLocation()
        requestMovieInfo(sido, sigungu)
        itemDiv()
        sort()
        
        
    }

    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
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
    
    // MARK:- 2단계로 넘길 값 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenMap" {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let VC = segue.destination as? MapViewController
            
            if path?.section == 0 {
//                VC?.mvo.dutyName = pharOpenItems[(path?.row)!]["dutyName"]
//                VC?.mvo.dutyAddr = pharOpenItems[(path?.row)!]["dutyAddr"]
            } else if path?.section == 1 {
                count = (path?.row)!
                NSLog("\(self.list[path!.row]))")
                VC?.mvo = self.list[path!.row]
                
            }
            
        }
    }
}

// MARK: - Table view data source
extension ListPharmacyController {
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // 세션 구현
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 46/255, green: 118/255, blue: 185/255, alpha: 0.6)
        let label = UILabel()
        viewWidth = Int(self.view.bounds.width) - 40
        label.frame = CGRect(x: 20, y: 12, width: viewWidth, height: 10)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .right
        // 가로로 변경할때 label 위치 버그있음
        
        switch section {
        case 0:
            label.text = self.section[0]
        case 1:
            label.text = self.section[1]
        default:
            label.text = ""
        }
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.pharOpenItems.count
        case 1:
            return self.pharCloseItems.count

        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dutyListCell", for: indexPath) as! dutyListCell

        // Configure the cell...
        if indexPath.section == 0 {
            var openTime = pharOpenItems[indexPath.row]["dutyTimes"]!
            var closeTime = pharOpenItems[indexPath.row]["dutyTimec"]!
            openTime.insert(":", at: openTime.index(openTime.startIndex, offsetBy: 2))
            closeTime.insert(":", at: closeTime.index(closeTime.startIndex, offsetBy: 2))
            cell.dutyName?.text = pharOpenItems[indexPath.row]["dutyName"]
            cell.dutyAddr?.text = pharOpenItems[indexPath.row]["dutyAddr"]
            cell.dutyTime?.text = "영업시간 \(openTime) ~ \(closeTime)"
            
            if "9999999999" == pharOpenItems[indexPath.row]["distance"]! {
                cell.dutyKm?.text = "정보 없음"
            } else {
                cell.dutyKm?.text = "\(pharOpenItems[indexPath.row]["distance"]!)km"
            }
            cell.dutyIcon?.image = UIImage(named: "icon_green.png")
        } else {
            var openTime = pharCloseItems[indexPath.row]["dutyTimes"]!
            var closeTime = pharCloseItems[indexPath.row]["dutyTimec"]!
            openTime.insert(":", at: openTime.index(openTime.startIndex, offsetBy: 2))
            closeTime.insert(":", at: closeTime.index(closeTime.startIndex, offsetBy: 2))
            cell.dutyName?.text = pharCloseItems[indexPath.row]["dutyName"]
            cell.dutyAddr?.text = pharCloseItems[indexPath.row]["dutyAddr"]
            cell.dutyTime?.text = "영업시간 \(openTime) ~ \(closeTime)"
            if "9999999999" == pharCloseItems[indexPath.row]["distance"]! {
                cell.dutyKm?.text = "정보 없음"
            } else {
                cell.dutyKm?.text = "\(pharCloseItems[indexPath.row]["distance"]!)km"
            }
            cell.dutyIcon?.image = UIImage(named: "icon_red.png")
        }
        
        
        return cell
    }
}

// MARK:- 거리 계산, 배열 나누기
extension ListPharmacyController {
    // 구 삼각법을 기준으로 대원거리(m단위) 요청
    func distanceKm(lat: Double, lon: Double) -> String {
        let myLocation = CLLocation(latitude: coorlat, longitude: coorlon)
        let myBuddysLocation = CLLocation(latitude: lat, longitude: lon)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000
        
        return String(format: "%.2f", distance)
    }
    
    func itemDiv() {
        let hour = cal.component(.hour, from: date)
        let min = cal.component(.minute, from: date)
        var hourStr = ""
        var minStr = ""
        
        if min < 10 {
            minStr = "0" + String(min)
        } else {
            minStr = String(min)
        }
        if hour < 10 {
            hourStr = "0" + String(hour)
        } else {
            hourStr = String(hour)
        }
        
        
        let nowTime = Int(hourStr+minStr)!
        print("nowTime : \(nowTime)")
        for i in 0..<pharAllItems.count {
            let closeTime = pharAllItems[i]["dutyTimec"]!
            let openTime = pharAllItems[i]["dutyTimes"]!
            if nowTime < Int(closeTime)! && Int(openTime)! < nowTime {
                pharOpenItems.append(pharAllItems[i])
            } else {
                pharCloseItems.append(pharAllItems[i])
            }
        }
    }
}
