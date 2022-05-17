

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var userName : UILabel!
    @IBOutlet var userAvtar : ImageLoader!
    @IBOutlet var imgViewNote : UIImageView!

    var dataArray : UsersListModel!{
        didSet{
            /*self.firstNameLabel.text = dataArray.firstName
            self.lastNameLabel.text = dataArray.lastName
            self.avtarImageView.image = UIImage.init(data: dataArray.imageData)*/
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
