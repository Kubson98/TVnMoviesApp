//
//  SearchData.swift
//  SuitsApp
//
//  Created by Kuba on 12/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct SearchData: Codable {
    var results: [ResultOfSearch]
}

struct ResultOfSearch: Codable {
    var original_name: String?
    var original_title: String?
    var poster_path: String?
    var backdrop_path: String?
    var release_date: String?
    var overview: String?
    var id: Int?
}
