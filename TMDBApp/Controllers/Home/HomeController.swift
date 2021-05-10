//
//  HomeController.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 6/2/21.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var tvShowsCollectionView: UICollectionView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var optionsBar: UIView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var homePresenter: HomePresenter!
    var tvShowItems = [TvShows]()
    
    let menuCategories = ["Popular", "Top Rated", "On Tv", "Airing Today"]
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "tmdbCells")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        homePresenter = HomePresenter(tmdbService: TmdbService())
        homePresenter.attachView(view: self)
        
        categoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
        
        retrieveTvShows(categorySelected: .Popular)
        
    }
    
    func setupUI() {
        menuButton.setImage(UIImage(named: "menu_icon"), for: .normal)
        menuButton.tintColor = UIColor.white
        menuButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        tvShowsCollectionView.delegate = self
        tvShowsCollectionView.dataSource = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        tvShowsCollectionView.register(TvShowsCell.self, forCellWithReuseIdentifier: "CellId")
        
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        tvShowsCollectionView.backgroundColor = UIColor(named: "tmdbMain")
        categoryCollectionView.backgroundColor = UIColor(named: "tmdbMain")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        tvShowsCollectionView.setCollectionViewLayout(layout, animated: true)
        
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryLayout.minimumLineSpacing = 0
        categoryLayout.minimumInteritemSpacing = 11
        categoryCollectionView.setCollectionViewLayout(categoryLayout, animated: true)
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        showOptionsMenu()
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == tvShowsCollectionView {
            
            return tvShowItems.count
            
        } else {
            
            return menuCategories.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tvShowsCollectionView {
            
            let cell: TvShowsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! TvShowsCell
            
            cell.backgroundColor = UIColor(named: "tmdbCells")
            
            cell.config(tvShow: tvShowItems[indexPath.row])
            
            return cell
            
        } else {
            
            let cell: CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.categoryLabel.text = menuCategories[indexPath.item]
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == tvShowsCollectionView {
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "TvShowDetailsController") as! TvShowDetailsController
            vc.showId = tvShowItems[indexPath.row].id
            self.navigationController?.pushViewController(vc,animated: true)
            
        } else {
            
            var categorySelected: TvCategory?
            
            switch indexPath.row {
            case 0:
                categorySelected = .Popular
            case 1:
                categorySelected = .TopRated
            case 2:
                categorySelected = .OnTv
            case 3:
                categorySelected = .AiringToday
            default:
                break
            }
            
            retrieveTvShows(categorySelected: categorySelected!)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tvShowsCollectionView {
            
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            
            return CGSize(width:widthPerItem, height:350)
            
        } else {
            
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 4 - lay.minimumInteritemSpacing
            
            return CGSize(width:widthPerItem, height:collectionView.frame.height)
            
        }
    }
    
}

extension HomeController: HomeView {
    
    func retrieveTvShows(categorySelected: TvCategory) {
        homePresenter.fetchTvShows(category: categorySelected)
    }
    
    func loadInfoFromServer(shows: [TvShows]) {
        tvShowItems = shows
        
        tvShowsCollectionView.reloadData()
    }
    
    func showOptionsMenu() {
        let alert = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View profile", style: .default , handler:{ (UIAlertAction) in
            print("User click Approve button")
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive , handler:{ (UIAlertAction) in
            print("User click Delete button")
            Session.expired()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension HomeController {
    func handleDeepLink(_ deepLink: DeepLink) {
        switch deepLink {
        case .Popular:
            selectedIndexPath = IndexPath(item: 0, section: 0)
            retrieveTvShows(categorySelected: .Popular)
        case .TopRated:
            retrieveTvShows(categorySelected: .TopRated)
            selectedIndexPath = IndexPath(item: 1, section: 0)
        case .OnAir:
            selectedIndexPath = IndexPath(item: 2, section: 0)
            retrieveTvShows(categorySelected: .AiringToday)
            
        }
        
        categoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }
}
