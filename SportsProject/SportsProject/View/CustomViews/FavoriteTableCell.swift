

import UIKit

class FavoriteTableCell: UITableViewCell {

    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var favoriteLeagueName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
