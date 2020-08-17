//
//  SeasonCollectionViewCell.swift
//  SuitsAppBeta
//
//  Created by Kuba on 07/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class SeasonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var seasonImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: UIImage) {
        seasonImage.image = image
    }

}
