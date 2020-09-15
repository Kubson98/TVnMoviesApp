//
//  SeasonData.swift
//  SuitsAppBeta
//
//  Created by Kuba on 07/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct SeasonData: Codable {
    var seasons: [Seasons]
    var backdrop_path: String
    var overview: String
    var name: String
}

struct Seasons: Codable {
    var poster_path: String
    var name: String
}
