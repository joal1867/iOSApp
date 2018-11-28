
import UIKit
import MapKit

class TheaterMapVC: UIViewController {
    //상위 뷰 컨트롤러로부터 데이터를 넘겨받을 변수 선언 : 위도, 경도가 포함된 dictionary
    var theater :NSDictionary?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       //타이틀에 극장 명 출력
        self.navigationItem.title = theater?["상영관명"] as? String
        //위도와 경도 찾기 : '위도', '경도'키로 저장되어있는 것을 정수로 변환
        let lat = (theater!["위도"]as? NSString)?.doubleValue
        let lng = (theater!["경도"]as? NSString)?.doubleValue
        //지도에 출력할 영역만들기
        //지도의 중심점 좌표 생성
        let location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        let coordinateRegion = MKCoordinateRegion(center:location, latitudinalMeters:1000, longitudinalMeters:1000)
        //지도에 출력
        mapView.setRegion(coordinateRegion, animated: true)
        
        //영화관 위치에 Annotation(Marker) 출력
        let point = MKPointAnnotation()
        point.coordinate = location
        point.title = theater!["상영관명"] as? String
        mapView.addAnnotation(point)
    }
}
