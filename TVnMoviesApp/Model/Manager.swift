//
//  Manager.swift
//  SuitsApp
//
//  Created by Kuba on 07/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

protocol SeasonsDelegate: AnyObject {
    func giveSeasonsData(data: [SeasonData])
}

protocol EpisodesDelegate: AnyObject {
    func giveEpisodesData(data: [DataOfEpisode])
}

protocol SearchDelegate: AnyObject {
    func didUpdateMovie(_ data: SearchData)
}


class Manager {
    weak var delegateSeasons: SeasonsDelegate?
    weak var delegateEpisodes: EpisodesDelegate?
    weak var delegateSearch: SearchDelegate?
    
    
    // MARK: - URL REQUEST
    func performRequestSeasons(idOfMovieOrTV: Int) {
        let seasonsURL = "https://api.themoviedb.org/3/tv/\(idOfMovieOrTV)?api_key=\(apiKey)"
        if let url = URL(string: seasonsURL) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    let test = self?.parseJSONforSeasons(seasonData: safeData)
                    self?.delegateSeasons?.giveSeasonsData(data: test as! [SeasonData])
                }
            }
            task.resume()
        }
    }

    func performRequestMovieSeries(idOfMovieOrTV: String, typeToWatch: String) {
         let seasonsURL = "https://api.themoviedb.org/3/search/\(typeToWatch)?api_key=295a887b4441ab6428dca06b9bdb7469&language=en-US&page=1&include_adult=false&query=\(idOfMovieOrTV)"
         if let url = URL(string: seasonsURL) {
             print(seasonsURL)
             let session = URLSession.shared
             let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                 if error != nil {
                     return
                 }
                 if let safeData = data {
                     
                     let test = self?.parseJSONforMovies(seasonData: safeData)
                    self?.delegateSearch!.didUpdateMovie(test as! SearchData)
                 }
             }
             task.resume()
         }
     }
    
    func performRequestEpisode(idOfTV: Int, season: Int) {
        var episodesURL = "https://api.themoviedb.org/3/tv/\(idOfTV)/season/\(season)?api_key=\(apiKey)"
        if let url = URL(string: episodesURL) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    let  test = self?.parseJSONforEpisodes(episodeData: safeData)
                    self?.delegateEpisodes?.giveEpisodesData(data: test as! [DataOfEpisode])
                }
            }
            task.resume()
        }
    }
    
    // MARK: - JSON CONNECT
    private func parseJSONforSeasons(seasonData: Data) -> [SeasonData] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SeasonData.self, from: seasonData)
            let result = [decodedData.self]
            return result
        } catch {
            print(error)
            return error as! [SeasonData]
        }
    }
    
    private func parseJSONforEpisodes(episodeData: Data) -> [DataOfEpisode] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(EpisodeData.self, from: episodeData)
            let result = decodedData.episodes
            return result
        } catch {
            print(error)
            return error as! [DataOfEpisode]
        }
    }

        private func parseJSONforMovies(seasonData: Data) -> SearchData {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(SearchData.self, from: seasonData)
                let result = decodedData.self
                return result
            } catch {
                print(error)
                return error as! SearchData
            }
        }
    }

