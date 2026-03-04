//
//  DashBoardTableCell.swift
//  Fluffbotics
//
//  Created by Equipp on 28/11/25.
//

import UIKit

class DashBoardTableCell: UITableViewCell {
    
    @IBOutlet weak var cellViewRef: UIView!
    @IBOutlet weak var cellImgRef: UIImageView!
    @IBOutlet weak var cellnameLblRef: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
