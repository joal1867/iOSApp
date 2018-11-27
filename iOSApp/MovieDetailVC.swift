import UIKit
import WebKit

class MovieDetailVC: UIViewController {
    //MovieListTVC로부터 넘겨받을 데이터의 변수를 인스턴스 변수로 생성
    var linkUrl : String?
    //디자인 웹 킷뷰와 변수 연결
    @IBOutlet weak var webView: WKWebView!
    //디자인 indicatorView와 변수연결(*작업 중 표시)
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //linkUrl의 데이터가 있으면 - 예외가 발생하지 않도록 하기 위해서
        //이런 형태로 코드를 작성
        //java 코드라면 변수 != null
        if let addr = linkUrl{
            //URL 객체로 만들어 졌다면
            if let url = URL(string:addr){
                let request = URLRequest(url:url)
                //웹 뷰가 로딩
                webView.load(request)
                webView.uiDelegate = self
                webView.navigationDelegate = self
            }
                //URL 객체로 만드는데 실패했다면
            else{
                let alert = UIAlertController(title: "잘못된 URL 입니다.", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
            //linkUrl에 데이터가 없다면
        else{
            let alert = UIAlertController(title: "URL이 없습니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}


extension  MovieDetailVC : WKNavigationDelegate, WKUIDelegate{
    //웹 뷰가 로딩을 시작했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.indicatorView.startAnimating()
    }
    //웹 뷰가 로딩을 종료했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
    
    //웹 뷰가 로딩에 실패했을 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.indicatorView.stopAnimating()
    }
}
