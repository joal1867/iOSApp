
import UIKit

class MemoFormVC: UIViewController {
    //디자인 이미지뷰1개와 텍스트뷰1개 각각 변수연결
    @IBOutlet weak var memoImage: UIImageView!
    @IBOutlet weak var txtContents: UITextView!
    
    
    //이미지 피커의 타입을 매개변수로 받아 이미지 피커를 출력해주는 사용자정의 메소드
    func presentPicker(source : UIImagePickerController.SourceType){
        //유효한 SourceType이 아니면 중단
        guard UIImagePickerController.isSourceTypeAvailable(source) == true
            else{
                let alert = UIAlertController(title:"사용할 수 없는 타입입니다.",message:nil, preferredStyle:.alert)
                self.present(alert, animated: false)
                return
        }
        //이미지 피커 출력
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        
        self.present(picker, animated: true)
    }
    
    //디자인 navigation bar Item 1개(사진) 이벤트 메소드와 연결
    @IBAction func pickImage(_ sender: Any) {
        let select = UIAlertController(title:"원하는 이미지를 선택하세요",message:nil,preferredStyle:.actionSheet)
        select.addAction(UIAlertAction(title: "카메라", style:.default){
            (_) in self.presentPicker(source: .savedPhotosAlbum)
        })
        select.addAction(UIAlertAction(title: "라이브러리", style: .default){
            (_) in self.presentPicker(source: .photoLibrary)
        })
        self.present(select,animated: true)
    }
    
    
    //제목을 저장할 인스턴스 변수 선언
    var subject : String!
    
    
    //디자인 navigation bar Item 1개(메모저장) 이벤트 메소드와 연결
    //입력받은 데이터를 AppDelegate의 memoList에 저장 
    @IBAction func saveMemo(_ sender: Any) {
        //텍스트 뷰에 내용이 없으면 경고창을 출력하고 종료
        //조건을 만족하지 않으면 종료 : guard 사용
        //cf. 조건에 마자는 경우와 그렇지 않은 경우에 다른 처리 : if 사용
        
        //contents에 내용이 없으면 리턴
        guard self.txtContents.text.isEmpty == false else{
            let alert = UIAlertController(title: "텍스트 뷰에 내용을 작성해야 합니다. ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        //입력한 문자열이 있는 경우 데이터를 생성
        let memo = MemoListVO()
        memo.title = self.subject
        memo.contents = self.txtContents.text
        memo.image = self.memoImage.image
        memo.regdate = Date()
        print("memo:\(memo)")
        
        //데이터 변수를 소유하고 있는 AppDelegate 인스턴스에 대한 포인터 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //데이터 저장 : 이 작업 후에 memo데이터를 Core Data나 Server에 저장하고 다시 출력
        appDelegate.memoList.append(memo)
        print("memoList:\(appDelegate.memoList)")
        
        //이전 뷰 컨트롤러로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtContents.delegate = self

    }
}


//UIImagePickerControllerDelegate, UITextViewDelegate
extension MemoFormVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    //이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.memoImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        picker.dismiss(animated:false)
    }
    
    //텍스트를 입력하는 도중 호출되는 메소드
    func textViewDidChange(_ textView: UITextView){
        //입력된 문자열 가져오기 : 편리한 사용을 위해 형변환
        let contents = self.txtContents.text as NSString
        let length = (contents.length > 15) ? 15 : contents.length
        self.subject = contents.substring(with: NSRange(location:0, length:length))
        self.navigationItem.title = subject
    }
}
