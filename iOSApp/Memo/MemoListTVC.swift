import UIKit

class MemoListTVC: UITableViewController {
    //이벤트 처리에 사용할 메소드 : +버튼을 선택하면 작성모드로 이동
    @objc func add(_ barButtonItem: UIBarButtonItem){
        //MemoFormVC 화면 출력
        let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
        memoFormVC.navigationItem.title = "메모작성"
        self.navigationController?.pushViewController(memoFormVC, animated: true)
    }
    
    
    //AppDelegate객체에 대한 참조형 변수를 인스턴스 변수로 생성
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //네비게이션 바 우측에 + 버튼 배치
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MemoListTVC.add(_:)))
    }
    
    
    //*데이터가 변경되면 재출력 요청 필요!
    //why? *GUI Programming에서는 View에 데이터를 직접 출력하는 경우가 거의 없습니다.
    //비동기적으로 이미지 출력
    //뷰가 출력될 때 마다 호출되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    //셀을 원하는 모양으로 디자인하고, 셀의 데이터를 저장하기 위해 Cell클래스를 생성해서 출력
    // MARK: - Table view data source
    
    //섹션의 개수를 설정하는 메소드 : 없으면 1을 리턴(*그룹화를 하지 않을 거라면 삭제 또는 1을 리턴하도록 해야합니다.)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //그룹별 행의 개수를 설정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memoList.count
    }
    
    //셀을 만들어주는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //행번호에 해당하는 데이터 찾기
        let memo = appDelegate.memoList[indexPath.row]
        
        //image 존재 여부에 따라 셀의 아이디를 설정
        //if indexPath.row % 2 == 0  이용하면 이미지 있을 때, 없을 때 메모의 색을 다르게 지정할 수 있다. cf.웹-게시판
        let cellId = memo.image == nil ? "BasicMemoCell" : "ImageMemoCell"
        
        //셀 만들기
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        //데이터 출력
        cell.subject.text = memo.title
        cell.contents.text = memo.contents
        //cell.regdate.text = memo.regdate
        //*날짜를 원하는 형식의 문자열로 만들어주는 객체를 생성
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        cell.regdate.text = formatter.string(from: memo.regdate!)
        //데이터가 nil인 경우, 그렇지 않은 경우 둘다 사용할때는 ?를 이용합니다.
        cell.img?.image = memo.image
     
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //셀을 선택했을 때 호출되는 메소드 재정의
    //ㄴ셀을 선택했을 때 하위 뷰 컨트롤러에게 데이터를 넘겨주고 네비게이션으로 이동하는 작업
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //데이터 전달
        let memo = appDelegate.memoList[indexPath.row]
        let memoDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoDetailVC") as! MemoDetailVC
        memoDetailVC.memo = memo
        //네비게이션으로 이동
        self.navigationController?.pushViewController(memoDetailVC, animated: true)
    }
}
