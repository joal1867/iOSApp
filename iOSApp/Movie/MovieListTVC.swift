import UIKit

class MovieListTVC: UITableViewController {

    //파싱한 결과를 저장할 List변수를 인스턴스변수로 선언 (*지연생성이용 : 변수를 처음부터 만들지 않고 처음 사용할때 만들기 위해서 사용)
    lazy var list : [MovieListVO] = {
        var datalist = [MovieListVO]()
        return datalist
    }()
    
    //현재 출력 중인 데이터의 마지막 페이지 번호를 저장할 변수 선언
    var page = 1
    
    
    //데이터를 다운로드 받는 메소드
    func download(){
        //다운로드 받을 URL만들기
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(page)&count=30&genreId=&order=releasedateasc"
        //주소가 이렇게변수를 통해 한번 거쳐서 가면 접속하지 않아도 주소가 잘못 된 것을 알 수 있습니다.
        let apiURI : URL! = URL(string: url)
        //print(apiURI)
        
        //REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        //print(apidata)
        
        //데이터 전송 결과를 로그로 출력
        //let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        //print("API Result=\( log )")
        
        
        //데이터를 파싱해서 list에 저장
        //예외처리
        do{
            //전체데이터를 dictionary로 만들기
            let apiDict = try JSONSerialization.jsonObject(with:apidata,options:[]) as! NSDictionary
            //hoppin키의 값을 dictionary로 가져오기
            let hoppin = apiDict["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let ar = movies["movie"] as! NSArray
            //배열 순회
            for row in ar{
                let imsi = row as! NSDictionary
                var movie = MovieListVO()
                movie.title = (imsi["title"] as! String)
                movie.genreNames = (imsi["genreNames"] as! String)
                movie.linkUrl = (imsi["linkUrl"] as! String)
                movie.ratingAverage = (imsi["ratingAverage"] as! NSString).doubleValue
                movie.thumbnailImage = (imsi["thumbnailImage"] as! String)
                
                //이미지 URL을 가지고 이미지 데이터를 다운로드 받아서 저장
                let url = URL(string: movie.thumbnailImage!)
                //데이터 다운로드
                let imageData = try Data(contentsOf : url!)
                //저장
                movie.image = UIImage(data:imageData)
                self.list.append(movie)
                //이메일을 받아오는 거였으면 아래의 방법을 이용했을 것입니다.
                //self.list.insert(movie, at:0)
            }
            //print(self.list)
            //테이블 뷰 재출력
            self.tableView.reloadData()
            
            //전체 데이터를 표시한 경우에는 refreshController를 숨김
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            if totalCount <= self.list.count{
                self.refreshControl?.isHidden = true
                self.refreshControl = nil
            }
        }catch {
            print("파싱에서 예외 발생")
        }
    }
    
    
    //refreshControl이 화면에 보여질때 호출할 메소드를 생성 (*앞에 반드시 @objc붙입니다.)
    @objc func handleRequest(_ refreshControl:UIRefreshControl){
        //페이지 번호를 1증가 시키고 데이터 다시 받아오기
        self.page = self.page+1
        self.download()
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //화면에 뷰가 보여질 때 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        //추상메소드가 아니면 상위클래스의 메소드를 호출하고 기능을 추가
        super.viewDidDisappear(animated)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MovieListTVC.handleRequest(_:)), for:.valueChanged)
        self.refreshControl?.tintColor = UIColor.blue
        download()
        self.navigationItem.title="영화 목록"
    }
    
    
    //인덱스에 해당하는 UIImage를 리턴하는 메소드
    func getThumbnailImage(_ index : Int) -> UIImage{
        //배열에서 인덱스에 해당하는 데이터 가져오기
        var movie = self.list[index]
        //이미지가 있으면 바로 리턴
        if let savedImage = movie.image{
            return savedImage
        }else{
            //이미지가 없으면 다운로드 받아서 리턴
            let url : URL! = URL(string:movie.thumbnailImage!)
            let imageData = try! Data(contentsOf: url)
            movie.image = UIImage(data:imageData)
            return movie.image!
        }
    }
    
   
    //테이블 뷰 출력 메소드 재정의
    // MARK: - Table view data source
    
    //섹션의 개수를 설정하는 메소드 *없으면 1을 리턴하는 것으로 간주
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //섹션(그룹)별 행의 개수를 설정하는 메소드(required) *없으면 에러발생
    //cf. TableViewController의 경우, 없으면 1을 리턴하는 것으로 간주
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    //셀의 모양을 만드는 메소드(required) *없으면 에러발생
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //사용자 정의 셀 만들기
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //행번호에 해당하는 데이터 찾기
        let movie = self.list[indexPath.row]
        //데이터 출력
        cell.lblTitle.text = movie.title!
        cell.lblGenre.text = movie.genreNames!
        cell.lblRating.text = "\(movie.ratingAverage!)"
        //cell.thumbnailImage.image = movie.image!
        //비동기적으로 이미지 출력
        DispatchQueue.main.async(execute: {
            cell.thumbnailImage.image = self.getThumbnailImage(indexPath.row)
        })
        
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    
    //셀을 클릭했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //선택한 행번호에 해당하는 데이터 찾아오기
        let movie = self.list[indexPath.row]
        //하위 뷰 컨트롤러 인스턴스 생성
        let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC
        //데이터 넘겨주기
        movieDetailVC?.linkUrl = movie.linkUrl
        movieDetailVC?.title = movie.title
        //네비게이션으로 출력
        self.navigationController?.pushViewController(
            movieDetailVC!, animated: true)
    }
}
