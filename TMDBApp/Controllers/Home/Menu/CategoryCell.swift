//
//  CategoryCell.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 16/2/21.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {
    var bgView: UIView = UIView()
    var categoryLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            bgView.backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.darkGray
        }
    }

    override var isSelected: Bool {
        didSet {
            bgView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.darkGray
        }
    }
    
    func removeAutoConstraintsFromView(vs: Array<UIView>){
        for v in vs{v.translatesAutoresizingMaskIntoConstraints=false}
    }
    
    func setup() {
        removeAutoConstraintsFromView(vs: [bgView, categoryLabel])
        
        contentView.addSubview(bgView)
        bgView.layer.cornerRadius = 5
        bgView.clipsToBounds = true
        bgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: contentView.bounds.height/2).isActive = true
        bgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bgView.backgroundColor = UIColor.darkGray
        
        
        bgView.addSubview(categoryLabel)
        categoryLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor, constant: 0).isActive = true
        categoryLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor, constant: 0).isActive = true
        categoryLabel.font = categoryLabel.font.withSize(12)
        categoryLabel.textColor = UIColor.white
        categoryLabel.numberOfLines = 0
        categoryLabel.text = "option"
        
    }
}
