//
//  QuestionTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/15.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var avaterImg: UIImageView!
    
    @IBOutlet weak var BgView: UIView!
    @IBOutlet weak var avaterLabel: UILabel!
    @IBOutlet weak var postBody: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
