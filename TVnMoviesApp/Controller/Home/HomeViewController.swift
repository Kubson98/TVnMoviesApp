//
//  HomeViewController.swift
//  TVnMoviesApp
//
//  Created by Kuba on 14/09/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var pickSegmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    var manager = Manager()
    let disposeBag = DisposeBag()
    let resultsArray = Variable<[ResultOfSearch]>([])
    let layout = UICollectionViewFlowLayout()
    let seasonVC = SeasonViewController()
    let time: RxTimeInterval = DispatchTimeInterval.milliseconds(500)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegateSearch = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 404, height: 509)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCell")
        activityLoading.hidesWhenStopped = true
        searchTextField.rx.text.orEmpty.asObservable()
            .debounce(DispatchTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .subscribe {
                self.resultsArray.value.removeAll()
                self.collectionView.reloadData()
                self.activityLoading.startAnimating()
                    if var result = $0.element {
                        result = String(result.map {
                            $0 == " " ? "/" : $0
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                            self!.activityLoading.stopAnimating()
                            switch self?.pickSegmentControl.selectedSegmentIndex {
                            case 0:
                                self?.manager.performRequestMovieSeries(idOfMovieOrTV: result, typeToWatch: "movie")
                            case 1:
                                self?.manager.performRequestMovieSeries(idOfMovieOrTV: result, typeToWatch: "tv")
                            default:
                                print(Error.self)
                            }
                            repeat {
                                self?.collectionView.reloadData()
                            } while self?.resultsArray.value.count == 0
                        }
                    }
                self.searchTextField.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        let row = resultsArray.value[indexPath.row]
        cell.isUserInteractionEnabled = true
        seasonVC.configureCard(view: cell)
        if row.poster_path == nil {
            cell.imageResult.image = UIImage(named: "noImage")
        } else {
            let url = URL(string: "https://image.tmdb.org/t/p/w300\(row.poster_path!)")!
            if let data = try? Data(contentsOf: url) {
                cell.imageResult.image = UIImage(data: data)
            }
        }
        if row.original_title != nil {
            cell.titleResult.text = row.original_title!
        } else if row.original_name == nil {
            cell.isUserInteractionEnabled = false
            cell.titleResult.text = "no result"
        } else {
            cell.titleResult.text = row.original_name!
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcSeasons = storyboard?.instantiateViewController(withIdentifier: "seasonsVC") as? SeasonViewController
        let vcDetail = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? EpisodeDetailViewController
        
        var vc = UIViewController()
        if resultsArray.value[indexPath.row].original_title != nil  {
            vc = vcDetail!
            let rowMovies = resultsArray.value[indexPath.row]
            if rowMovies.backdrop_path == nil {
                vcDetail?.image = UIImage(named: "noImage2")
            } else {
                let url = URL(string: "https://image.tmdb.org/t/p/w400\(rowMovies.backdrop_path!)")!
                if let data = try? Data(contentsOf: url) {
                    vcDetail?.image = UIImage(data: data)
                }
            }
            let year = String((rowMovies.release_date)!.prefix(4))
            vcDetail?.overview = rowMovies.overview!
            vcDetail?.titleEp = rowMovies.original_title!
            vcDetail?.number = "(\(year))"
        } else {
            vc = vcSeasons!
            vcSeasons?.season = resultsArray.value[indexPath.row].id!
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: SearchDelegate {
    func didUpdateMovie(_ data: SearchData) {
        if data.results!.count != 0 {
            for i in 0...data.results!.count - 1 {
                resultsArray.value.append(data.results![i])
            }
        } else {
            resultsArray.value.append(ResultOfSearch(original_name: nil, original_title: nil, poster_path: nil, backdrop_path: nil, release_date: nil, overview: nil, id: nil))
        }
    }
}


