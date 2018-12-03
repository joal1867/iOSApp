
import Foundation
import UIKit
import CoreData

//Entity작업을 위한 DAO클래스 생성
class MemoDAO{
    //AppDelegate에 있는 CoreData사용을 위해 존재하는 변수에 접근하는 변수를 생성
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //전체 데이터를 가져오는 메소드
    func fetch() -> [MemoListVO]{
        //리스트 생성
        var memoList = [MemoListVO]()
        //요청객체 생성
        let fetchRequest:NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        //2개이상의 데이터를 가져올 때는 정렬조건을 추가
        let regDataDesc = NSSortDescriptor(key:"regdate", ascending:false)
        fetchRequest.sortDescriptors = [regDataDesc]
        do{
            //데이터 가져오기
            let resultSet = try self.context.fetch(fetchRequest)
            //데이터 순회
            for record in resultSet{
                //1개의 데이터를 저장할 객체를 생성
                let data = MemoListVO()
                data.title = record.title
                data.contents = record.contents
                //날짜는 형변환 후, 저장
                data.regdate = record.regdate! as Date
                //ID저장
                data.objectID = record.objectID
                //image는 존재하면 반환해서 저장
                if let image = record.image as Data?{
                    data.image = UIImage(data:image)
                }
                //목록에 저장
                memoList.append(data)
            }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
        return memoList
    }
    
    //데이터를 삽입하는 메소드
    func insert(_ data:MemoListVO){
        //새로 저장할 객체를 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        object .title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        if let image = data.image{
            //읽어온 이미지를 데이터로 변환해서 저장 *최신API
            object.image = image.pngData()
        }
        //데이터 저장
        do{
            try self.context.save()
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
    }
    
    //삭제하는 메소드
    func delete(_ objectID: NSManagedObjectID) -> Bool{
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do{
            try self.context.save()
            return true
        }catch let e as NSError{
            print("\(e.localizedDescription)")
            return false
        }
    }
}
