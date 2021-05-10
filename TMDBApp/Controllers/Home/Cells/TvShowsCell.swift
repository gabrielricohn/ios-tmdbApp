//
//  TvShowsCell.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 16/2/21.
//

import Foundation
import UIKit

class TvShowsCell: UICollectionViewCell {
    
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
        posterView.image = #imageLiteral(resourceName: "moviePoster")
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
    
    func config(tvShow: TvShows) {
        
        let tmdbUrl = "http://image.tmdb.org/t/p/w500\(tvShow.poster)"
        
        posterView.loadAsyncFrom(url: tmdbUrl, placeholder: #imageLiteral(resourceName: "moviePoster"), onCompletion: {success in}, onError: {})

        showTitle.text = tvShow.originalName
        dateLabel.text = Utility.getFormattedDate(strDate: tvShow.showDate, currentFomat: "YYYY-MM-DD", expectedFromat: "MMM DD, YYYY")
        ratingLabel.text = String(tvShow.rating)
        descriptionLabel.text = tvShow.overview
    }
    
}
