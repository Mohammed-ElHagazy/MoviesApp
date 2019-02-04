//
//  CustomTableViewCell.swift
//  movie
//
//  Created by Muhammad on 12/1/18.
//  Copyright © 2018 Muhammad. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var movieImage:UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYear:UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var RemoveButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
