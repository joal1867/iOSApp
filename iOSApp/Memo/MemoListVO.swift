import Foundation
import UIKit
import CoreData

//데이터를 묶어서 하나로 저장할 VO클래스 생성 
class MemoListVO{
    var memoIdx:Int?
    var title:String?
    var contents:String?
    var image:UIImage?
    var regdate:Date?
    
    //MemoVO 가 코어 데이터에 저장된 MemoMO 인스턴스를 가리킬 수 있도록 변수 1개 추가
    //MemoMO인스턴스를 구별하기 위한 변수
    var objectID : NSManagedObjectID?
    
}
