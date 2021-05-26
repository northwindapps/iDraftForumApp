//
//  CreateCommentTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/17.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class CreateCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var createCommentTextView: UITextView!
    @IBOutlet weak var indexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
