
import UIKit

class SideMenuTVC: UITableViewController {
    //메뉴로 사용할 6개 항목과 이미지 저장
    let titles = ["메모작성","친구 새글","달력보기","공지사항","통계","계정관리"]
    let icons = [UIImage(named:"icon01.png"),UIImage(named:"icon02.png"),UIImage(named:"icon03.png")
        ,UIImage(named:"icon04.png"),UIImage(named:"icon05.png"),UIImage(named:"icon06.png"),]
    
    //디자인 레이블2개, 이미지뷰1개를 인스턴스 변수로 생성
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = UIColor.brown
        self.tableView.tableHeaderView = headerView
        
        nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        nameLabel.text = "JOAL"
        nameLabel.textColor = UIColor.white
        self.nameLabel.backgroundColor = UIColor.clear
        headerView.addSubview(nameLabel)
        
        emailLabel.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        emailLabel.text = "jjoal1867@gmail.com"
        emailLabel.textColor = UIColor.white
        self.emailLabel.backgroundColor = UIColor.clear
        headerView.addSubview(emailLabel)
        
        let defaultProfile = UIImage(named:"account.jpg")
        profileImage.image = defaultProfile
        profileImage.frame = CGRect(x:10,y:10,width:50,height:50)
        //네모난 이미지 뷰를 등글게 만들기
        profileImage.layer.cornerRadius = (profileImage.frame.width/2)
        profileImage.layer.borderWidth = 0
        profileImage.layer.masksToBounds = true
        headerView.addSubview(profileImage)
    }

    // MARK: - Table view data source
    //섹션의 개수를 설정하는 메소드
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //섹션별 행의 개수를 설정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    //셀을 만들어 주는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
       
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        

        return cell
    }
    
    
    //셀을 선택했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
            //사이드 바의 네비게이션 컨트롤러 찾아오기
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            //화면 출력
            target.pushViewController(uv, animated: true)
            //사이드 바 제거
            self.revealViewController()?.revealToggle(self)
        }else if indexPath.row == 5{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            //화면 출력
            target.pushViewController(uv, animated: true)
            //사이드 바 제거
            self.revealViewController()?.revealToggle(self)
        }
    }
    
}
