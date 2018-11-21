

import UIKit

class sigunguListController: UITableViewController {
    
    // 하단 switch문에서 해당되는 지역 배열을 복사
    var temp = [String]()
    
    var seoul = ["종로구", "중구", "용산구", "성동구", "광진구", "동대문구", "중랑구", "성북구", "강북구", "도봉구", "노원구", "은평구",
                 "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구", "강동구"]
    
    var gyeonggi = ["수원시 장안구", "수원시 권선구", "수원시 팔달구", "수원시 영통구", "성남시 중원구", "성남시 수정구", "성남시 분당구",
                   "용인시 처인구", "용인시 기흥구", "용인시 수지구", "안양시 만안구", "안양시 동안구",
                  "안산시 단원구", "안산시 상록구", "과천시", "광명시", "광주시", "군포시", "부천시", "시흥시", "김포시", "안성시", "오산시", "의왕시",
                  "이천시", "평택시", "하남시", "화성시", "여주시", "양평군", "고양시 덕양구", "고양시 일산서구", "고양시 일산동구", "구리시",
                  "남양주시", "동두천시", "양주시", "의정부시", "파주시", "포천시", "연천군", "가평군"]
    
    var incheon = ["중구", "동구", "미추홀구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"]
    
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
//        case "서울특별시":
//            <#code#>
//        case "서울특별시":
//            <#code#>
//        case "서울특별시":
//            <#code#>
//        case "서울특별시":
//            <#code#>
//        case "서울특별시":
//            <#code#>
//        case "서울특별시":

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
    
    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    

}

// MARK:- tableView 설정
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
    
    // 행에 이벤트 등록
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}


