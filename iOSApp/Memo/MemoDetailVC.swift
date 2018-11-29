import UIKit

class MemoDetailVC: UIViewController {
    //디자인 레이블 2개와 이미지뷰 1개 변수와 연결
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    //데이터를 넘겨받을 변수를 인스턴스 변수로 선언
    var memo : MemoListVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subject.text = memo?.title
        self.contents.text = memo?.contents
        self.img.image = memo?.image
        self.navigationController?.title="상세보기"
    }
}
