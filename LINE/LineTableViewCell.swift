//
//  LineTableViewCell.swift
//  LINE
//
//  Created by HARADA REO on 2015/09/14.
//  Copyright (c) 2015年 reo harada. All rights reserved.
//

import UIKit

class LineTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
