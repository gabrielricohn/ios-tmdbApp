//
//  TvShowDetailsController.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import UIKit

class TvShowDetailsController: UIViewController {
    @IBOutlet weak var backgroundImageView: AsyncImage!
    @IBOutlet weak var tvShowDetailsTableView: UITableView!
    
    var tvShowDetailsPresenter: TvShowDetailsPresenter!
    
    var tvDetailsItems = [TvShowDetails]()
    var tvCastItems = [TvCastAndCrew]()
    
    var tvDetailsSectionList = [TvDetailsSection]()
    
    var showId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.contentMode = .scaleAspectFill
        
        tvShowDetailsPresenter = TvShowDetailsPresenter(tmdbService: TmdbService())
        tvShowDetailsPresenter.attachView(view: self)
        
        tvShowDetailsTableView.backgroundColor = UIColor(named: "tmdbMain")
        tvShowDetailsTableView.separatorStyle = .none
        tvShowDetailsTableView.delegate = self
        tvShowDetailsTableView.dataSource = self
        tvShowDetailsTableView.register(TvShowDetailsCell.self, forCellReuseIdentifier: "cell")
        tvShowDetailsTableView.register(TvSeasonsCell.self, forCellReuseIdentifier: "cellDI")
        tvShowDetailsTableView.register(TvCastCell.self, forCellReuseIdentifier: "cellID")
         
        let summarySection = TvDetailsSection(title: "Summary", cellHeight: 10, cellWidth: 10, lineSpacing: 10, interitemSpacing: 10, style: .Summary)
        let seasonsSection = TvDetailsSection(title: "Seasons", cellHeight: 10, cellWidth: 10, lineSpacing: 10, interitemSpacing: 10, style: .Seasons)
        let castSection = TvDetailsSection(title: "Cast", cellHeight: 10, cellWidth: 10, lineSpacing: 10, interitemSpacing: 10, style: .Cast)
        tvDetailsSectionList = [summarySection, seasonsSection, castSection]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tvShowDetailsPresenter.getTvShowDetails(category: .ShowDetails, showId: String(showId))
        tvShowDetailsPresenter.getTvCast(category: .CastAndCrew, showId: String(showId))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor(named: "tmdbCells")
        
    }
}

extension TvShowDetailsController: TvShowDetailsView {
    
    func loadDescriptionInfoFromServer(tvDetails: [TvShowDetails]) {
        tvDetailsItems = tvDetails
        
        let tmdbUrl = "http://image.tmdb.org/t/p/w500\(tvDetails[0].bgImage)"
        
        backgroundImageView.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "moviePoster"), onCompletion: {image in
            
            print("se completo")
            
        }, onError: {})
        
        print(tvDetailsItems)
        
        tvShowDetailsTableView.reloadData()
    }
    
    func loadCastInfoFromServer(tvCast: [TvCastAndCrew]) {
        tvCastItems = tvCast
        
        print(tvCastItems)
        
        tvShowDetailsTableView.reloadData()
    }
    
}

extension TvShowDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvDetailsSectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: TvShowDetailsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TvShowDetailsCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "tmdbMain")
            cell.tvFavoritesDelegate = self
            cell.showId = showId
            for details in tvDetailsItems {
                cell.configShowDetails(showDetails: details)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell: TvSeasonsCell = tableView.dequeueReusableCell(withIdentifier: "cellDI", for: indexPath) as! TvSeasonsCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "tmdbMain")
            for details in tvDetailsItems {
                cell.configShowDetails(showDetails: details)
            }
            return cell
        } else {
            let cell: TvCastCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TvCastCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "tmdbMain")
            cell.castList = tvCastItems
            print(tvCastItems)
            
            for cast in tvCastItems {
                cell.configCastDetails(castDetails: cast)
            }
//            if !tvCastItems.isEmpty {
//                cell.configCastDetails(castDetails: tvCastItems[indexPath.row])
//            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 225
        } else if indexPath.row == 1 {
            return 250
        } else {
            return 200
        }
    }
    
}

extension TvShowDetailsController : TvFavoriteDelegate {
    func didFavoriteShow(message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
    }
}

class TvShowDetailsCell: UITableViewCell {
    
    var tvDetailsPresenter: TvShowDetailsPresenter!
    var tvFavoritesDelegate: TvFavoriteDelegate!
    
    var showId: Int = 0
    
    var summaryTitle: UILabel = UILabel()
    var showTitle: UILabel = UILabel()
    var favoriteButton: UIButton = UIButton()
    var summary: UILabel = UILabel()
    var authorsLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func setup() {
        
        tvDetailsPresenter = TvShowDetailsPresenter(tmdbService: TmdbService())
        
        removeAutoConstraintsFromView(vs: [summaryTitle, showTitle, favoriteButton, summary, authorsLabel])
        
        contentView.addSubview(summaryTitle)
        summaryTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        summaryTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        summaryTitle.numberOfLines = 0
        summaryTitle.textColor = UIColor.systemGreen
        summaryTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        summaryTitle.text = "Summary"
        
        contentView.addSubview(showTitle)
        showTitle.topAnchor.constraint(equalTo: summaryTitle.bottomAnchor,constant: 5).isActive = true
        showTitle.leadingAnchor.constraint(equalTo: summaryTitle.leadingAnchor).isActive = true
        showTitle.numberOfLines = 0
        showTitle.textColor = UIColor.white
        showTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        showTitle.text = "Titulo"
        
        contentView.addSubview(favoriteButton)
        favoriteButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: showTitle.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(didFavoriteMovie), for: .touchUpInside)
        
        contentView.addSubview(summary)
        summary.topAnchor.constraint(equalTo: showTitle.bottomAnchor, constant: 10).isActive = true
        summary.leadingAnchor.constraint(equalTo: showTitle.leadingAnchor).isActive = true
        summary.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        summary.numberOfLines = 0
        summary.textColor = UIColor.white
        summary.font = summary.font.withSize(14)
        summary.text = "este es un resumen de la serie"
        
        contentView.addSubview(authorsLabel)
        authorsLabel.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 10).isActive = true
        authorsLabel.leadingAnchor.constraint(equalTo: summary.leadingAnchor).isActive = true
        authorsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        authorsLabel.numberOfLines = 0
        authorsLabel.font = authorsLabel.font.withSize(14)
        authorsLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        authorsLabel.textColor = UIColor.white
        authorsLabel.text = ""
        
    }
    
    func configShowDetails(showDetails: TvShowDetails) {
        print("Hello")
        showTitle.text = showDetails.showName
        summary.text = showDetails.summary
        if !showDetails.createdBy.isEmpty {
            authorsLabel.text = "Created by \(showDetails.createdBy[0].authorName)"
        }
    }
    
    @objc func didFavoriteMovie() {
        
        tvDetailsPresenter.setFavoriteShow(isFavorite: true, showId: showId, completion: { success, message in
            if success {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                self.tvFavoritesDelegate.didFavoriteShow(message: message)
            }
        })
        
    }
}


class TvSeasonsCell: UITableViewCell {
    
    var summaryTitle: UILabel = UILabel()
    var posterImageView: AsyncImage = AsyncImage()
    var seasonNumberLabel: UILabel = UILabel()
    var seasonDate: UILabel = UILabel()
    var allSeasonsButton: UIButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func setup() {
        
        removeAutoConstraintsFromView(vs: [summaryTitle, posterImageView, seasonNumberLabel, seasonDate, allSeasonsButton])
        
        contentView.addSubview(summaryTitle)
        summaryTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        summaryTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        summaryTitle.textColor = UIColor.systemGreen
        summaryTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        summaryTitle.text = "Probando"
        
        contentView.addSubview(posterImageView)
        posterImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        posterImageView.topAnchor.constraint(equalTo: summaryTitle.bottomAnchor, constant: 5).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: summaryTitle.leadingAnchor).isActive = true
        
        contentView.addSubview(seasonNumberLabel)
        seasonNumberLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        seasonNumberLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor, constant: -40).isActive = true
        seasonNumberLabel.textColor = UIColor.white
        seasonNumberLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        seasonNumberLabel.text = "Numero de temporada"
        
        contentView.addSubview(seasonDate)
        seasonDate.leadingAnchor.constraint(equalTo: seasonNumberLabel.leadingAnchor).isActive = true
        seasonDate.topAnchor.constraint(equalTo: seasonNumberLabel.bottomAnchor, constant: 5).isActive = true
        seasonDate.textColor = UIColor.systemGreen
        seasonDate.font = seasonDate.font.withSize(14)
        seasonDate.text = "2021"
        
        contentView.addSubview(allSeasonsButton)
        allSeasonsButton.leadingAnchor.constraint(equalTo: seasonNumberLabel.leadingAnchor).isActive = true
        allSeasonsButton.topAnchor.constraint(equalTo: seasonDate.bottomAnchor, constant: 10).isActive = true
        allSeasonsButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        allSeasonsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        allSeasonsButton.layer.cornerRadius = 5
        allSeasonsButton.setTitle("View all seasons", for: .normal)
        allSeasonsButton.titleLabel?.numberOfLines = 0
        allSeasonsButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        allSeasonsButton.backgroundColor = UIColor.systemGreen
        allSeasonsButton.tintColor = UIColor.white
        allSeasonsButton.addTarget(self, action: #selector(viewAllSeasons), for: UIControl.Event.touchUpInside)
        
    }
    
    func configShowDetails(showDetails: TvShowDetails) {
        let tmdbUrl = "http://image.tmdb.org/t/p/w500\(showDetails.seasons[0].poster)"
        
        posterImageView.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "moviePoster"), onCompletion: { image in
            
            print("se completo")
            
        }, onError: {})
        
        summaryTitle.text = "Last season"
        seasonNumberLabel.text = showDetails.seasons[0].season
        seasonDate.text = Utility.getFormattedDate(strDate: showDetails.seasons[0].airDate, currentFomat: "YYYY-MM-DD", expectedFromat: "MMM DD, YYYY")
    }
    
    @objc func viewAllSeasons() {
        print("probando temporadas")
    }
}

class TvCastCell: UITableViewCell {
    
    var summaryTitle: UILabel = UILabel()
    var castCollectionView: UICollectionView!
    
    var castList = [TvCastAndCrew]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        castCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        removeAutoConstraintsFromView(vs: [summaryTitle, castCollectionView])
        
        contentView.addSubview(summaryTitle)
        summaryTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        summaryTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        summaryTitle.textColor = UIColor.systemGreen
        summaryTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        summaryTitle.text = "Cast"
        
        contentView.addSubview(castCollectionView)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.backgroundColor = UIColor(named: "tmdbMain")
        castCollectionView.topAnchor.constraint(equalTo: summaryTitle.bottomAnchor).isActive = true
        castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        castCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        castCollectionView.register(CastCell.self, forCellWithReuseIdentifier: "castCell")
    }
    
    func configCastDetails(castDetails: TvCastAndCrew) {
        castCollectionView.reloadData()
    }
}

extension TvCastCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCell
        
        cell.config(cast: castList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 150, height: collectionView.bounds.height)
    }
    
}

class CastCell: UICollectionViewCell {
    
    var castImage: AsyncImage = AsyncImage()
    var castName: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        removeAutoConstraintsFromView(vs: [castImage, castName])
        
        contentView.addSubview(castImage)
        castImage.image = #imageLiteral(resourceName: "profileImage")
        castImage.contentMode = .scaleAspectFill
        castImage.layer.cornerRadius = 50
        castImage.clipsToBounds = true
        castImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        castImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        castImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        castImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        contentView.addSubview(castName)
        castName.topAnchor.constraint(equalTo: castImage.bottomAnchor, constant: 15).isActive = true
        castName.centerXAnchor.constraint(equalTo: castImage.centerXAnchor).isActive = true
        castName.numberOfLines = 0
        castName.textColor = UIColor.white
        castName.font = UIFont.boldSystemFont(ofSize: 12.0)
        castName.text = "Probando el title"
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func config(cast: TvCastAndCrew) {
        
        let tmdbUrl = "http://image.tmdb.org/t/p/w500\(cast.profilePicture)"
        
        castImage.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "profileImage"), onCompletion: { success in }, onError: {})
        
        castName.text = cast.name
    }
    
}
