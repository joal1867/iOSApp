import Foundation
import Alamofire
import CoreData

class DataSync{
    //코어데이터를 사용하려면 코어데이터에 접근하기 위한 포인터가 필요하다.
    //코어데이터에 접근하는 포인터 생성
    lazy var context:NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    //날짜를 사용하는 경우 날짜 포맷을 맞춰주는 메소드를 별도로 만들어 두는 것이 좋다.
    //Database <-> iOS나 Android 이 방식의 통신은 안 된다.
    //Database <-> RestAPI <-> iOS, Android
    
    //날짜를 데이터베이스에 yyyy-mm-dd HH:mm:ss 형식으로 저장
    //서버와 클라이언트 모두 저 형식에 맞추어서 데이터를 전송하고 받아야 한다.
    
    //String -> Date
    func stringToDate(_ value:String)->Date{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: value)!
    }
    
    //Date -> String
    func dateToString(_ value:Date)->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: value as Date)
    }
    func downloadData(){
        //이 메소드를 한 번 호출해서 데이터를 다운로드받으면, 앱을 지우기 전까지는 다시는 다운로드받지 않도록 생성한다. 개임 에플리케이션에서 초기 데이터를 가져올 때 사용하는 방법이다.
        //UserDefaults : 앱의 설정 파일
        //앱을 지우기 전까지는 내용을 보존
        
        let userDefaults = UserDefaults.standard
        //특정 키의 값이 nil이 아니면 리턴
        //guard는 조건에 맞지 않으면 작업을 수행하지 않도록 하기 위해 사용하는 경우가 많다.
        guard userDefaults.value(forKey:"download")==nil
            else{
                return
        }
        //다운로드받을 서버의 url만들기
        let url = "http://192.168.2.3:8080/server/memo/memolist"
        //요청보내기
        let get = Alamofire.request(url, method:.get, encoding:JSONEncoding.default, headers:nil)
        //응답처리
        get.responseJSON{
            res in
            //데이터 전체를 딕셔너리로 변경
            guard let jsonObject = res.result.value as? NSDictionary else{return}
            //memos 키의 데이터를 list로 변환
            guard let list = jsonObject["memos"] as? NSArray else{return}
            //배열 순회
            for item in list{
                //각 항목을 dictionary로 변경
                guard let record = item as? NSDictionary
                    else{return}
                //CoreData의 자료형인 MemoMO객체 만들기
                let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into:self.context) as! MemoMO
                //데이터 저장
                object.num = (record["NUM"] as! Int32)
                object.title = (record["TITLE"] as! String)
                object.contents = (record["CONTENTS"] as! String)
                object.regdate = self.stringToDate(record["REGDATE"] as! String)
                if let imagePath = record["IMAGE_PATH"] as? String {
                    if imagePath != "" {
                        let url = URL(string:"http://192.168.2.3:8080/server/images/memoimages/\(imagePath)")
                        object.image = try! Data(contentsOf:url!)
                    }
                }
            }
            //데이터를 코어 데이터에 저장
            do{
                try self.context.save()
            }catch let e as NSError{
                print("\(e.localizedDescription)")
            }
            //다운로드 받았다는 사실을 저장
            userDefaults.setValue(true, forKey: "download")
        }
    }
}
