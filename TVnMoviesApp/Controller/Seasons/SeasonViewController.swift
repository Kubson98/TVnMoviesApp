//
//  ViewController.swift
//  SuitsAppBeta
//
//  Created by Kuba on 07/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit


class SeasonViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SeasonsDelegate{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var seasonsManager = Manager()
    var seasonsArray = [Seasons]()
    let layout = UICollectionViewFlowLayout()
    var season = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 300, height: 434)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        seasonsManager.delegateSeasons = self
        collectionView.register(UINib(nibName: "SeasonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "seasonCell")
        
    }
    
    func giveSeasonsData(data: [SeasonData]) {
        seasonsArray = data[0].seasons!
        if seasonsArray[0].name == "Specials"{
            seasonsArray.removeFirst()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! SeasonCollectionViewCell
        configureCard(view: cell)
        if seasonsArray[indexPath.row].poster_path == nil {
            cell.seasonImage.image = UIImage(named: "noImage")
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w300\(seasonsArray[indexPath.row].poster_path!)")!
            if let data = try? Data(contentsOf: url) {
                cell.seasonImage.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "episodeVC") as? EpisodesListViewController
        vc?.season = indexPath.row + 1
        vc?.id = season
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func configureCard(view: UICollectionViewCell) {
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        seasonsManager.performRequestSeasons(idOfMovieOrTV: season)
        repeat{
            collectionView.reloadData()
        } while seasonsArray.count == 0
        
    }
    
    
}




