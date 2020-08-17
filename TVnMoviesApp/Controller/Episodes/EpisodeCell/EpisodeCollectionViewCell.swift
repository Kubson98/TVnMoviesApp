//
//  CollectionViewCell.swift
//  SuitsAppBeta
//
//  Created by Kuba on 08/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var seasonAndEpisode: UILabel!
    @IBOutlet weak var titleOfEpisode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
