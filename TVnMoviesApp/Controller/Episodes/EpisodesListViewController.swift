//
//  EpisodesListViewController.swift
//  SuitsAppBeta
//
//  Created by Kuba on 08/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class EpisodesListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, EpisodesDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var seasonsVC = SeasonViewController()
    var episodesArray = [DataOfEpisode]()
    var episodesManager = Manager()
    let layout = UICollectionViewFlowLayout()
    var season = Int()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 360, height: 225)
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.dataSource = self
        episodesManager.delegateEpisodes = self
        collectionView.register(UINib(nibName: "EpisodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "episodeCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as! EpisodeCollectionViewCell
        seasonsVC.configureCard(view: cell)
        let row = episodesArray[indexPath.row]
        if row.still_path == nil {
            cell.backgroundImage.image = UIImage(named: "noImage2")
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w400\(row.still_path!)")!
            if let data = try? Data(contentsOf: url) {
                cell.backgroundImage.image = UIImage(data: data)
            }
        }
        cell.seasonAndEpisode.text = "Season \(row.season_number!) Episode \(row.episode_number!)"
        cell.titleOfEpisode.text = row.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? EpisodeDetailViewController
        let row = episodesArray[indexPath.row]
        if row.still_path == nil {
            vc?.image = UIImage(named: "noImage2")
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w400\(row.still_path!)")!
            if let data = try? Data(contentsOf: url) {
                vc?.image = UIImage(data: data)
            }
        }
        vc?.number = "Season \(row.season_number!) Episode \(row.episode_number!)"
        vc?.overview = row.overview
        vc?.titleEp = row.name
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func giveEpisodesData(data: [DataOfEpisode]) {
        episodesArray = data
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodesManager.performRequestEpisode(idOfTV: id, season: season)
        repeat {
            collectionView.reloadData()
        } while episodesArray.count == 0
    }
}
