

import UIKit

class sigunguListController: UITableViewController {
    
    // 하단 switch문에서 해당되는 지역 배열을 복사
    var temp = [String]()
    //["seoul", "gyeonggi" , "incheon", "busan", "daegu", "daejeon", "gwangju", "ulsan", "kangwon", "sejong", "chungbuk", "chungnam", "jeonbuk", "jeonnam", "gyeongbuk", "gyeongnam", "jeju"]
    let seoul = ["종로구", "중구", "용산구", "성동구", "광진구", "동대문구", "중랑구", "성북구", "강북구", "도봉구", "노원구", "은평구",
                 "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구", "강동구"]
    
    let gyeonggi = ["수원시 장안구", "수원시 권선구", "수원시 팔달구", "수원시 영통구", "성남시 중원구", "성남시 수정구", "성남시 분당구",
                   "용인시 처인구", "용인시 기흥구", "용인시 수지구", "안양시 만안구", "안양시 동안구",
                  "안산시 단원구", "안산시 상록구", "과천시", "광명시", "광주시", "군포시", "부천시", "시흥시", "김포시", "안성시", "오산시", "의왕시",
                  "이천시", "평택시", "하남시", "화성시", "여주시", "양평군", "고양시 덕양구", "고양시 일산서구", "고양시 일산동구", "구리시",
                  "남양주시", "동두천시", "양주시", "의정부시", "파주시", "포천시", "연천군", "가평군"]
    
    let incheon = ["중구", "동구", "미추홀구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"]
    
    let busan = ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"]
    
    let daegu = ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"]
    
    let daejeon = ["동구", "중구", "서구", "유성구", "대덕구"]
    
    let gwangju = ["서구", "동구", "남구", "북구", "광산구"]
    
    let ulsan = ["중구", "남구", "동구", "북구", "울주군"]
    
    let sejong = ["조치원읍", "연기면", "연동면", "부강면", "금남면", "장군면", "연서면", "전의면", "전동면", "소정면", "한솔동", "새롬동", "도담동", "아름동", "종촌동", "고운동", "보람동", "대평동", "소담동"]
    
    let kangwon = ["원주시", "춘천시", "강릉시", "동해시", "속초시", "삼척시", "태백시", "홍천군", "철원군", "횡성군", "평창군", "정선군", "영월군", "인제군", "고성군", "양양군", "화천군", "양구군"]
    
    let chungbuk = ["청주시", "충주시", "제천시", "보은군", "옥천군", "영동군", "증평군", "진천군", "괴산군", "음성군", "단양군"]
    
    let chungnam = ["천안시", "공주시", "보령시", "아산시", "서산시", "논산시", "계룡시", "당진시", "금산군", "부여군", "서천군", "청양군", "홍성군", "예산군", "태안군"]
    
    let jeonbuk = ["전주시", "익산시", "군산시", "정읍시", "김제시", "남원시", "완주군", "고창군", "부안군", "임실군", "순창군", "진안군", "무주군", "장수군"]
    
    let jeonnam = ["목포시", "여수시", "순천시", "나주시", "광양시", "담양군", "곡성군", "구례군", "고흥군", "보성군", "화순군", "장흥군", "강진군", "해남군", "영암군", "무안군", "함평군", "영광군", "장성군", "완도군", "진도군", "신안군"]
    
    let gyeongbuk = ["포항시", "경주시", "김천시", "안동시", "구미시", "영주시", "영천시", "상주시", "문경시", "경산시", "군위군", "의성군", "청송군", "영양군", "영덕군", "청도군", "고령군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군"]
    
    let gyeongnam = ["창원시", "김해시", "진주시", "양산시", "거제시", "통영시", "사천시", "밀양시", "함안군", "거창군", "창녕군", "고성군", "하동군", "합천군", "남해군", "함양군", "산청군", "의령군"]
    
    let jeju = ["제주시", "서귀포시"]
    
    
    var mvo: LocaleVO!              // 시,도 정보를 받아야함
    var sidoName = ""
    var indicator = UIActivityIndicatorView()
    
    lazy var list : [LocaleVO] = {
        var datalist = [LocaleVO]()
        
        for row in self.temp {
            let mvo = LocaleVO()
            mvo.sigungu = "\(sidoName) \(row)"
            
            datalist.append(mvo)
        }
        return datalist
    }()
    
    override func viewDidLoad() {
        
        // 로고생성
        makeLogo()
        // backbutton수정
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        NSLog("linkurl = \(self.mvo.sidoLogo!)")
        
        switch self.mvo.sidoLogo! {
        case "seoul":
            temp = seoul
            sidoName = "서울특별시"
        case "gyeonggi":
            temp = gyeonggi
            sidoName = "경기도"
        case "incheon":
            temp = incheon
            sidoName = "인천광역시"
        case "busan":
            temp = busan
            sidoName = "부산광역시"
        case "daegu":
            temp = daegu
            sidoName = "대구광역시"
        case "daejeon":
            temp = daejeon
            sidoName = "대전광역시"
        case "gwangju":
            temp = gwangju
            sidoName = "광주광역시"
        case "ulsan":
            temp = ulsan
            sidoName = "울산광역시"
        case "kangwon":
            temp = kangwon
            sidoName = "강원도"
        case "sejong":
            temp = sejong
            sidoName = "세종특별자치시"
        case "chungbuk":
            temp = chungbuk
            sidoName = "충청북도"
        case "chungnam":
            temp = chungnam
            sidoName = "충청남도"
        case "jeonbuk":
            temp = jeonbuk
            sidoName = "전라북도"
        case "jeonnam":
            temp = jeonnam
            sidoName = "전라남도"
        case "gyeongbuk":
            temp = gyeongbuk
            sidoName = "경상북도"
        case "gyeongnam":
            temp = gyeongnam
            sidoName = "경상남도"
        case "jeju":
            temp = jeju
            sidoName = "제주특별자치도"
        default:
            NSLog("오류")
        }
        
        
    }
    
    // MARK:- 2단계로 넘길 값 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListOpen" {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let sigunguVC = segue.destination as? ListPharmacyController
            sigunguVC?.mvo = self.list[path!.row]
        }
    }
    
    // MARK:- 로고 생성
    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    

}

// MARK:- tableView 설정 - extension
extension sigunguListController {
    
    // 전체 row 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 갯수에 따른 행 생성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell2")!
        cell.textLabel?.text = row.sigungu
        
        
        
        return cell
    }
    
    
}

