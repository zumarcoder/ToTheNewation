//
//  EmployeeListCell.swift
//  ToTheNewation
//
//  Created by Akash Verma on 22/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class EmployeeListCell: UITableViewCell {
    
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        baseContentView.roundTheView(corner: 6)
        profilePictureView.roundTheView(corner : (profilePictureView.bounds.height/2))
        nameLabel.roundTheView(corner: 5)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
