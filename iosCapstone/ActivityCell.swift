//
//  ActivityCell.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//
import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var CellImage: UIImageView!
    @IBOutlet weak var actTime: UILabel!
    @IBOutlet weak var items: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //get number of items
        CellImage.contentMode = .ScaleAspectFit
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
