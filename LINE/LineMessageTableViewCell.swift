//
//  LineMessageTableViewCell.swift
//  LINE
//
//  Created by HARADA REO on 2015/09/14.
//  Copyright (c) 2015年 reo harada. All rights reserved.
//

import UIKit

class LineMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var heightMessageImageView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
