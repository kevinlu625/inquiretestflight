//
//  PfpCollectionViewCell.swift
//  Inquire
//
//  Created by Kevin Lu on 8/10/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit

class PfpCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pfp: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       pfp.layer.cornerRadius = 50//pfp.frame.size.width/2
       self.pfp.clipsToBounds = true
    }


}
