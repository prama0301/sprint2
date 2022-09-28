//
//  CategoryTableViewCell.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/25/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
