import UIKit

class TheaterListTVC: UITableViewController {
    //필요한 인스턴스 변수 선언
    //파싱한 결과를 저장할 Dictionary의 배열 변수 *VO대신 Dictionary사용
    var data = [NSDictionary]()
    //데이터를 읽을 시작위치를 저장할 변수
    var startLocation = 0
    
    //웹에서 데이터를 다운로드 받아서 파싱한 후 결과를 저장하는 메소드 생성
    func download(){
        //다운로드 받을 URL생성
        let addr = "http://swiftapi.rubypaper.co.kr:2029/theater/list?s_page=\(startLocation)&s_list=10"
        let url = URL(string:addr)
        
        //*Data는 다운로드 받지만, Dictionary나 Array로 변활할때 문제가 발생한다면 대부분의 경우 원인 : Encoding문제
        //  ㄴ해결 : 문자열로 다운로드 받은 Data로 변환해서 작업을 진행합니다.
        /*let apiData = try! Data(contentsOf: url!)
        //데이터 받아오는 것 확인 : 데이터가 출력되지 않으면 url확인, 인터넷 권한 부분을 확인
        //print(apidata)
        //데이터 파싱
        let result = try! JSONSerialization.jsonObject(with: apiData, options: []) as? NSArray
        //파싱 확인 : 안될 경우, 대부분의 원인은 인코딩 문제!
        print(result)*/
        
        //문자열로 다운로드 받기
        let stringData = try! NSString(contentsOf: url!, encoding: 0x80_000_422)
        //print(stringdata)
        //문자열을 바이트 배열로 변환
        let encData = stringData.data(using: String.Encoding.utf8.rawValue)
        let result = try! JSONSerialization.jsonObject(with: encData!, options: []) as? NSArray
        //파싱확인
        //print(result)
        //배열의 데이터를 순회하면서 데이터를 self.data에 추가
        for imsi in result!{
            self.data.append(imsi as! NSDictionary)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        
        self.navigationItem.title = "영화관 목록"
        self.title = "영화관 목록"
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    // 섹션의 개수를 설정하는 메소드
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //행의 개수를 설정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    //셀을 만드는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheaterCell", for: indexPath) as! TheaterCell
        //출력할 데이터 찾아오기
        let theater = self.data[indexPath.row]
        //데이터 출력
        cell.lblTheaterName.text = theater["상영관명"] as? String
        cell.lblTheaterPhone.text = theater["연락처"] as? String
        cell.lblTheaterAddr.text = theater["소재지지번주소"] as? String
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    
    //셀을 선택했을 때 호출되는 메소드 : TheaterMapVC를 화면에 출력하고 데이터 넘겨주기
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //선택한 행번호에 해당하는 데이터 찾아오기
        let theater = self.data[indexPath.row]
        //하위 뷰 컨트롤러 인스턴스 생성
        let theaterMapVC = self.storyboard?.instantiateViewController(withIdentifier: "TheaterMapVC") as? TheaterMapVC
        //데이터 넘겨주기
        theaterMapVC?.theater = theater
        //비동기적으로 푸시
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(theaterMapVC!, animated: true)
        }
       
    }
}
