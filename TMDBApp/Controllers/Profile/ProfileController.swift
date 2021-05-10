//
//  ProfileController.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 8/2/21.
//

import Foundation
import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var profileDataItems = [Profile]()
    var favoriteDataItems = [FavoriteShows]()
    
    var profilePresenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.separatorStyle = .none
        
        profileTableView.backgroundColor = UIColor(named: "tmdbMain")
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(ProfileInfoCell.self, forCellReuseIdentifier: "ProfileInfoCell")
        profileTableView.register(FavoriteShowsCell.self, forCellReuseIdentifier: "FavoriteShowsCell")
        
        profilePresenter = ProfilePresenter(tmdbService: TmdbService())
        profilePresenter.attachView(view: self)
        
        retrieveProfileInfo()
    }
}

extension ProfileController: ProfileView {
    
    func retrieveProfileInfo() {
        profilePresenter.fetchProfileInfo(category: .Profile)
        profilePresenter.getFavoriteShowListFromApi()
    }
    
    func loadProfileDataFromApi(profile: [Profile]) {
        profileDataItems = profile
        
        Utility.setDefaultValue(profileDataItems[0].profileId, forKey: UserDefaultValues.PersonalInfo.profileId)
        
        profileTableView.reloadData()
    }
    
    func loadFavoriteShowsDataFromApi(favoriteShows: [FavoriteShows]) {
        favoriteDataItems = favoriteShows
        
        profileTableView.reloadData()
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProfileInfoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "tmdbMain")
            for profile in profileDataItems {
                cell.configProfileDetails(profile: profile)
            }
            return cell
        } else {
            let cell: FavoriteShowsCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteShowsCell", for: indexPath) as! FavoriteShowsCell
            cell.selectionStyle = .none
            cell.favoriteShowsList = favoriteDataItems
            cell.backgroundColor = UIColor(named: "tmdbMain")
            for fav in favoriteDataItems {
                cell.configFavoriteShows(favShows: fav)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 175
        } else {
            return 375
        }
    }
}

class ProfileInfoCell: UITableViewCell {
    
    var profileTitle: UILabel = UILabel()
    var profileImage: AsyncImage = AsyncImage()
    var nameLabel: UILabel = UILabel()
    var userNameLabel: UILabel = UILabel()
    
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
        
        removeAutoConstraintsFromView(vs: [profileTitle, profileImage, nameLabel, userNameLabel])
        
        contentView.addSubview(profileTitle)
        profileTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        profileTitle.numberOfLines = 0
        profileTitle.textColor = UIColor.systemGreen
        profileTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        profileTitle.text = "Profile"
        
        contentView.addSubview(profileImage)
        profileImage.image = #imageLiteral(resourceName: "profileImage")
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        profileImage.topAnchor.constraint(equalTo: profileTitle.bottomAnchor, constant: 25).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: profileTitle.leadingAnchor, constant: 15).isActive = true
//        profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -20).isActive = true
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "Full name"
        
        contentView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        userNameLabel.textColor = UIColor.systemGreen
        userNameLabel.text = "username"
        
    }
    
    func configProfileDetails(profile: Profile) {
        
        if !profile.avatar.avatar.avatarUrl.isEmpty {
            let tmdbUrl = "http://image.tmdb.org/t/p/w500\(profile.avatar.avatar.avatarUrl)"
            
            profileImage.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "profileImage"), onCompletion: { success in }, onError: { })
        }
        
        if !profile.name.isEmpty {
            nameLabel.text = profile.name
        }
        
        userNameLabel.text = profile.username
        
    }
    
}

class FavoriteShowsCell: UITableViewCell {
    
    var summaryTitle: UILabel = UILabel()
    var castCollectionView: UICollectionView!
    
    var favoriteShowsList = [FavoriteShows]()
    
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
        summaryTitle.text = "Favorite Shows"
        
        contentView.addSubview(castCollectionView)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.backgroundColor = UIColor(named: "tmdbMain")
        castCollectionView.topAnchor.constraint(equalTo: summaryTitle.bottomAnchor).isActive = true
        castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        castCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        castCollectionView.register(DisplayFavoriteShowsCell.self, forCellWithReuseIdentifier: "DisplayFavoriteShowsCell")
    }
    
    func configFavoriteShows(favShows: FavoriteShows) {
        castCollectionView.reloadData()
    }
}

extension FavoriteShowsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteShowsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DisplayFavoriteShowsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayFavoriteShowsCell", for: indexPath) as! DisplayFavoriteShowsCell
        
        cell.backgroundColor = UIColor(named: "tmdbCells")
        
        cell.config(tvShow: favoriteShowsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 175, height: collectionView.bounds.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    
}

class DisplayFavoriteShowsCell: UICollectionViewCell {
    
    var posterView: AsyncImage = AsyncImage()
    var gradientView: UIView = UIView()
    var showTitle: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    var ratingImage: UIImageView = UIImageView()
    var ratingLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        removeAutoConstraintsFromView(vs: [posterView, showTitle, dateLabel, ratingImage, ratingLabel, descriptionLabel, gradientView])
        
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 15
        
        contentView.addSubview(posterView)
        posterView.image = #imageLiteral(resourceName: "tmdb_logo")
        posterView.clipsToBounds = true
        posterView.layer.cornerRadius = 15
        posterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        posterView.contentMode = .scaleAspectFill
        posterView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        posterView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        posterView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        posterView.heightAnchor.constraint(equalToConstant: contentView.bounds.height/1.5).isActive = true
        
//        posterView.addBlackGradientLayerInForeground(frame: self.bounds, colors: [.clear,.black])
        
        
        contentView.addSubview(showTitle)
        showTitle.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 10).isActive = true
        showTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        showTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        showTitle.numberOfLines = 1
        showTitle.adjustsFontSizeToFitWidth = true
        showTitle.textColor = UIColor.green
        showTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        showTitle.text = "Probando el title"
        
        contentView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: showTitle.bottomAnchor, constant: 5).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textColor = UIColor.green
        dateLabel.font = dateLabel.font.withSize(14)
        dateLabel.text = "Aug 24, 2020"
        
        contentView.addSubview(ratingLabel)
        ratingLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        ratingLabel.textColor = UIColor.green
        ratingLabel.font = ratingLabel.font.withSize(14)
        ratingLabel.text = "9.3"
        
        contentView.addSubview(ratingImage)
        ratingImage.image = UIImage(systemName: "star.fill")
        ratingImage.contentMode = .scaleAspectFit
        ratingImage.tintColor = UIColor.green
        ratingImage.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor).isActive = true
        ratingImage.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -5).isActive = true
        ratingImage.widthAnchor.constraint(equalToConstant: 12).isActive = true
        ratingImage.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = descriptionLabel.font.withSize(10)
        descriptionLabel.text = "A bullied teenager turns to beauty pageants as a way to exact her revenge, with the help of a disgraced coach who "
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func config(tvShow: FavoriteShows) {
        
        let tmdbUrl = "http://image.tmdb.org/t/p/w500\(tvShow.poster)"
        
        posterView.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "moviePoster"), onCompletion: { success in }, onError: {})
        showTitle.text = tvShow.originalName
        dateLabel.text = Utility.getFormattedDate(strDate: tvShow.showDate, currentFomat: "YYYY-MM-DD", expectedFromat: "MMM DD, YYYY")
        ratingLabel.text = String(tvShow.rating)
        descriptionLabel.text = tvShow.overview
    }
    
}
