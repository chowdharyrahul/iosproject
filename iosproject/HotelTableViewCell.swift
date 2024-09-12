/*
 
 Author: Kiret Oberoi
 
 */

import UIKit

// Custom table view cell to display hotel information
class HotelTableViewCell: UITableViewCell {
    
    // Outlets for displaying hotel information
    @IBOutlet var nameLabel: UILabel! // Label to display hotel name
    @IBOutlet var locationLabel: UILabel! // Label to display hotel location
    @IBOutlet var priceLabel: UILabel! // Label to display hotel price
    @IBOutlet var roomsLabel: UILabel! // Label to display number of rooms
    @IBOutlet var detailBtn: UIButton! // Button to show details or take action
    
    // Method called when the cell is initialized from the storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Method called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
