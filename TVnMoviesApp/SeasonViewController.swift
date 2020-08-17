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
    var suitsArray = [Seasons]()
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
        suitsArray = data[0].seasons
        if suitsArray[0].name == "Specials"{
            suitsArray.removeFirst()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suitsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! SeasonCollectionViewCell
        configureCard(view: cell)
        var url = URL(string: "https://image.tmdb.org/t/p/w300\(suitsArray[indexPath.row].poster_path)")!
        if let data = try? Data(contentsOf: url) {
            cell.seasonImage.image = UIImage(data: data)
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
        } while suitsArray.count == 0
        
    }
    
    
}




