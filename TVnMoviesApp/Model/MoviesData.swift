//
//  AlbumData.swift
//  SuitsAppBeta
//
//  Created by Kuba on 12/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct MoviesData: Codable {
    var backdrop_path: String
    var overview: String
    var original_title: String
    var id: Int
    var release_date: String
    var vote_average: Float
}
