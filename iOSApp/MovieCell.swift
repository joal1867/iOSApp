import UIKit

class MovieCell: UITableViewCell {

    //디자인 이미지뷰 1개와 레이블 3개 각각 변수와 연결
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
