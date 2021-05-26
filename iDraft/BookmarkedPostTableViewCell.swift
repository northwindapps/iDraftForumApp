//
//  BookmarkedPostTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/20.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class BookmarkedPostTableViewCell: UITableViewCell {

    @IBOutlet weak var bookMarkPostLabel: UILabel!
    
    @IBOutlet weak var bookMarkPostDateLabel: UILabel!
    
    @IBOutlet weak var bookMarkPostEdit: UIButton!
    
    @IBOutlet weak var bookMarkPostDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
