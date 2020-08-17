//
//  EpisodeDetailViewController.swift
//  SuitsAppBeta
//
//  Created by Kuba on 10/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageEpisode: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage?
    var number: String?
    var titleEp: String?
    var overview: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageEpisode.image = image
        numberLabel.text = number
        titleLabel.text = titleEp
        overviewLabel.text = overview

    }

}
