import UIKit

class ViewController: UIViewController {
    //디자인 버튼1개와 이벤트 메소드 연결
    @IBAction func toMovieList(_ sender: Any) {
        //하위 뷰 컨트롤러 객체 만들기
        let movieListTVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListTVC") as! MovieListTVC
        
        let theaterListTVC =
            self.storyboard?.instantiateViewController(withIdentifier: "TheaterListTVC") as! TheaterListTVC

        //네비게이션 컨트롤러가 있을 경우 : 바로 푸시
        //네비게이션 컨트롤러가 없는 경우 : 네비게이션 컨트롤러를 만들고 present로 출력
        //이전화면으로 돌아가는 버튼 만들기
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "메인화면", style: .done, target: nil, action: nil)
        
        //탭 바 컨트롤러 생성
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [movieListTVC, theaterListTVC]
        
        //네비게이션으로 이동
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Main"
    }
}

