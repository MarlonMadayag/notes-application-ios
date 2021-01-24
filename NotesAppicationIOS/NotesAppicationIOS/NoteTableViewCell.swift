import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let identifier = "NoteTableViewCell"
    
    @IBOutlet weak var lblNoteTitle: UILabel!
    @IBOutlet weak var lblNoteDetail: UILabel!
    @IBOutlet weak var lblNoteCreatedDate: UILabel!
    @IBOutlet weak var viewCellContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
