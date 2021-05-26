//
//  BookmarkedUserTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/20.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class BookmarkedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var bookMarkNewMessageImg: UIImageView!
    @IBOutlet weak var bookMarkUserLabel: UILabel!
    @IBOutlet weak var bookMarkUserDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
