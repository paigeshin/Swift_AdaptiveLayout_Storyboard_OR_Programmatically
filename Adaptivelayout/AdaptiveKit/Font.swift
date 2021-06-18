//
//  Font.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit

//MARK: - Font

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}

enum HelveticaNeue {
    static func regular(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue", size: size.adaptedFontSize)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        UIFont(name: "HelveticaNeue-Bold", size: size.adaptedFontSize)!
    }
    /*
     Usage: titleLabel.font = HelveticaNeue.bold(size: 20)
     */
}
