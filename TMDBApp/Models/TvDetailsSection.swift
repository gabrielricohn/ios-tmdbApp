//
//  TvDetailsSection.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 7/2/21.
//

import Foundation
import UIKit

class TvDetailsSection {
    var title: String = ""
    var cellHeight: CGFloat = 0.0
    var cellWidth: CGFloat = 0.0
    var interitemSpacing: CGFloat = 0.0
    var lineSpacing: CGFloat = 0.0
    var style: ShowDetails = .Summary
    
    init(title: String, cellHeight: CGFloat, cellWidth: CGFloat,lineSpacing: CGFloat,interitemSpacing: CGFloat, style: ShowDetails = .Summary) {
        self.title = title
        self.cellHeight = cellHeight
        self.cellWidth = cellWidth
        self.style = style
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
    }
}
