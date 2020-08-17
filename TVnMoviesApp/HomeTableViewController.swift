//
//  HomeTableViewController.swift
//  SuitsAppBeta
//
//  Created by Kuba on 11/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, MoviesDelegate, SeasonsDelegate, giveId {

    var moviesArray = [MoviesData]()
    var tvArray = [SeasonData]()
    var albumArray = ["Movies": [13804,9799, 51497, 9615, 115782],
                      "TVSeries": [2691, 37680, 69050, 1668, 1408, 66788]
    ]
    var sectionArray = ["Movies", "TVSeries"]
    var manager = Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegateSeasons = self
        manager.delegateMovies = self
        let cellNib = UINib(nibName: "AlbumTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "albumTableCell")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumTableCell", for: indexPath) as! AlbumTableViewCell
        cell.categoryLabel.text = sectionArray[indexPath.row]
        cell.moviesArray = moviesArray
        cell.tvArray = tvArray
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func goToNextView(row: Int, typeOfAlbum: String) {
        let vcSeasons = storyboard?.instantiateViewController(withIdentifier: "seasonsVC") as? SeasonViewController
        let vcDetail = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? EpisodeDetailViewController
        var vc = UIViewController()
        if typeOfAlbum == "Movies" {
            vc = vcDetail!
            let rowMovies = moviesArray[row]
            let url = URL(string: "https://image.tmdb.org/t/p/w400\(rowMovies.backdrop_path)")!
            if let data = try? Data(contentsOf: url) {
                vcDetail?.image = UIImage(data: data)
            }
            let year = String((rowMovies.release_date).prefix(4))
            vcDetail?.overview = rowMovies.overview
            vcDetail?.titleEp = rowMovies.original_title
            vcDetail?.number = "(\(year))"
        } else {
            vc = vcSeasons!
            vcSeasons?.season = albumArray[typeOfAlbum]![row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func giveCell(row: Int, typeOfAlbum: String) {
        goToNextView(row: row, typeOfAlbum: typeOfAlbum)
    }
    
    func giveSeasonsData(data: [SeasonData]) {
        for x in 0...data.count - 1 {
            tvArray.append(data[x])
        }
    }
    
    func giveMoviesData(data: [MoviesData]) {
        for x in 0...data.count - 1 {
            moviesArray.append(data[x])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let item = albumArray as? [String: [Int]] {
            for (key, value) in item{
                for x in 0...value.count - 1 {
                    var typeWatch = "tv"
                    if key == "Movies" {
                        typeWatch = "movie"
                        manager.performRequestMovieSeries(idOfMovieOrTV: value[x], typeToWatch: typeWatch)
                    }else{
                        manager.performRequestSeasons(idOfMovieOrTV: value[x])
                    }
                }
            }
        }
        repeat {
            tableView.reloadData()
        } while moviesArray.count != albumArray["Movies"]!.count || tvArray.count != albumArray["TVSeries"]!.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moviesArray.removeAll()
        tvArray.removeAll()
    }
}
