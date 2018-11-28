import UIKit

class TheaterCell: UITableViewCell {
    //디자인 레이블3개와 변수 연결
    @IBOutlet weak var lblTheaterName: UILabel!
    @IBOutlet weak var lblTheaterPhone: UILabel!
    @IBOutlet weak var lblTheaterAddr: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
