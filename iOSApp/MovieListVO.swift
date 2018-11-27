import Foundation
import UIKit
//필요한 데이터를 하나로 묶어서 표현할 VO클래스 cf.구조체도 가능
struct MovieListVO{
    //필요한 각각의 데이터를 저장할 변수선언
    var title : String?
    var genreNames : String?
    var linkUrl : String?
    var ratingAverage : Double?
    var thumbnailImage : String?
    
    //thumbnailImage에서 다운로드 받은 이미지를 저장할 변수
    var image : UIImage?
   
}
