//
//  CalendarCollectionCell.swift
//  ConfigProject
//
//  Created by MBA0239P on 3/29/19.
//  Copyright © 2019 Tung Nguyen C.T. All rights reserved.
//

import UIKit

class CalendarCollectionCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for layer in layer.sublayers ?? [] where layer.name == "circle"{
            layer.removeFromSuperlayer()
        }
    }
}
