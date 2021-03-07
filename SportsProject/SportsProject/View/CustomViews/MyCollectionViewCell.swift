

import UIKit
import SDWebImage


class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView : UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image : UIImage,with text :String){
      
        imageView.image = image
        
        textView.text = text
    }
    static func nib()->UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}
