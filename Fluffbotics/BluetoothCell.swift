//
//  BluetoothCell.swift
//  Fluffbotics
//
//  Created by Ashish on 17/11/25.
//

import UIKit

class BluetoothCell: UITableViewCell {
    
    @IBOutlet weak var cellViewRef: UIView!
    @IBOutlet weak var cellLblRef: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cellViewRef.layer.cornerRadius = 10
        cellViewRef.clipsToBounds = true
        cellLblRef.layer.cornerRadius = 10
        cellLblRef.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
