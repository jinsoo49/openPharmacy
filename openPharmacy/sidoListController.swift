

import UIKit

class sidoListController: UITableViewController {
    
    
    var sidoset = ["seoul", "gyeonggi" , "incheon", "busan", "daegu", "daejeon", "gwangju", "ulsan", "kangwon", "sejong", "chungbuk", "chungnam", "jeonbuk", "jeonnam", "gyeongbuk", "gyeongnam", "jeju"]
    
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
        makeLogo()
    }
    
    // MARK:- 2단계로 넘길 값 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sigunguOpen" {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let sigunguVC = segue.destination as? sigunguListController
            sigunguVC?.mvo = self.list[path!.row]
        }
    }
    
    // 로고생성
    func makeLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "mainlogo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}

// MARK:- tableView 설정
extension sidoListController {
    
    // 전체 row 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 갯수에 따른 행 생성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let logoName = "logo_\(row.sidoLogo!).png"
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! sidoCell
        cell.thumbnail.image = UIImage(named: logoName)
        return cell
    }
    
    // 행에 이벤트 등록
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다.")
    }
    

}
