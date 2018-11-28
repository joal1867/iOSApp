import UIKit

class MemoListTVC: UITableViewController {
    //이벤트 처리에 사용할 메소드 : +버튼을 선택하면 작성모드로 이동
    @objc func add(_ barButtonItem: UIBarButtonItem){
        //MemoFormVC 화면 출력
        let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
        memoFormVC.navigationItem.title = "메모작성"
        self.navigationController?.pushViewController(memoFormVC, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //네비게이션 바 우측에 + 버튼 배치
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MemoListTVC.add(_:)))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
