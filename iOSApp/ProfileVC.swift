
import UIKit

//UITableViewDelegate,UITableViewDataSource 프로토콜을 conform하고 메소드 구현
class ProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    //프로필에 이미지,내용출력을 위한 이미지 뷰와 테이블 뷰 인스턴스 생성
    let profileImage = UIImageView()
    let tv = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //배경이미지 설정
        let bg = UIImage(named:"profile-bg")
        let bgimg = UIImageView(image: bg)
        bgimg.frame.size = CGSize(width: bgimg.frame.width, height: bgimg.frame.height)
        bgimg.center = CGPoint(x:self.view.frame.width/2, y:40)
        
        //이미지 뷰의 옵션 설정
        bgimg.layer.cornerRadius = bgimg.frame.size.width/2
        bgimg.layer.borderWidth = 0
        bgimg.layer.masksToBounds = true
        
        self.view.addSubview(bgimg)
        
        //프로필 이미지를 저장할 이미지 뷰를 생성, 배치
        let image = UIImage(named:"account.jpg")
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width:100, height:100)
        self.profileImage.center = CGPoint(x:self.view.frame.width/2, y:270)
        
        //이미지 뷰의 모양 변경
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        //이미지 뷰 추가
        self.view.addSubview(profileImage)
        
        self.tv.frame = CGRect(x:0, y:self.profileImage.frame.origin.y+self.profileImage.frame.height+20, width:self.view.frame.width, height:100)
        self.tv.dataSource = self
        self.tv.delegate = self
        self.view.addSubview(self.tv)
        
    }
    
    
    //테이블 뷰 출력 관련 메소드 : extension으로 class밖에서 만들어 주는 것도 가능
    //섹션별 행의 개수를 설정하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //셀을 만들어주는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "닉네임"
                cell.detailTextLabel?.text = "joal"
            case 1:
                cell.textLabel?.text = "이메일"
                cell.detailTextLabel?.text = "joal1867@naver.com"
            default:
                ()
        }
        return cell
    }
}

