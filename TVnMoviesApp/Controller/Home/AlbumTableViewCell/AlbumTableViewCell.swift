//
//  AlbumTableViewCell.swift
//  SuitsAppBeta
//
//  Created by Kuba on 11/08/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

protocol giveId: AnyObject  {
    func giveCell(row: Int, typeOfAlbum: String)
}

class AlbumTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var homeVC = HomeTableViewController()
    var arrayToShow = [Int]()
    var tvArray = [SeasonData]()
    var moviesArray = [MoviesData]()
    weak var delegate: giveId?
    let layout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "albumCollectionCell")
        collectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 300, height: 169)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryLabel.text == "Movies" {
            return moviesArray.count
        } else {
            return tvArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCollectionCell", for: indexPath) as! AlbumCollectionViewCell
        var row = String()
        if categoryLabel.text == "Movies" {
            row = moviesArray[indexPath.row].backdrop_path
        } else {
            row = tvArray[indexPath.row].backdrop_path
        }
        let url = URL(string: "https://image.tmdb.org/t/p/w300\(row)")
        if let data = try? Data(contentsOf: url!) {
            cell.pickImage.image = UIImage(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.giveCell(row: indexPath.row, typeOfAlbum: categoryLabel.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
