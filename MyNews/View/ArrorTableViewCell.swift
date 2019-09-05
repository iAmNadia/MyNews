//
//  ArrorTableViewCell.swift
//  MyNews
//
//  Created by Надежда Морозова on 04/09/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class ArrorTableViewCell: UITableViewCell {

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
