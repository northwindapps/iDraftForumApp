//
//  ShowProfileTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/23.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class ShowProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var postTitleButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
