//
//  EpisodeData.swift
//  SuitsApp
//
//  Created by Kuba on 07/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct EpisodeData: Codable {
    var episodes: [DataOfEpisode]?
}

struct DataOfEpisode: Codable {
    var episode_number: Int?
    var name: String?
    var overview: String?
    var season_number: Int?
    var still_path: String?
}

