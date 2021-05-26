//
//  CommentTableViewCell.swift
//  iDraft
//
//  Created by yujin on 2020/07/16.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

 
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var thumbupButton: UIButton!
    @IBOutlet weak var buycolaButton: UIButton!
    @IBOutlet weak var commentBodyTextView: UITextView!
    @IBOutlet weak var answerer: UIButton!
    
    @IBOutlet weak var commentPlayAudio: UIButton!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var commentBodyLargeTextView: UITextView!
    @IBOutlet weak var commentShowCorrection: UIButton!
    
    @IBOutlet weak var commentBodyTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentImageViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
