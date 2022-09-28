//
//  ProductTableViewCell.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/26/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
