//
//  Helper.swift
//  Adaptivelayout
//
//  Created by innertainment on 2021/06/18.
//

import UIKit



var dimension: Dimension {
    UIDevice.current.orientation.isPortrait ? .width : .height
}


//Input, design CGFloat
//Output, new CGFloat adpated to BaseScreenSize Ratio
func adapted(dimensionSize: CGFloat, to dimension: Dimension) -> CGFloat {
    
    //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var resultDiemsnionSize: CGFloat = 0.0
    switch dimension {
    case .width:
        //To adapt CGFloat in base dimension (design dimension) passed to the function, first we need to calculate the ratio of base dimension size to base screen size.
        ratio = dimensionSize / Device.baseScreenSize.rawValue.width
        // Then we have to multiply the current width or height by the ratio to get the adapted CGFloat for the current screen size:
        resultDiemsnionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.height
        resultDiemsnionSize = screenHeight * ratio
    }
    return resultDiemsnionSize
}

//The main purpose of the resized function is to resize passed CGSize preserveing the initial apsect ratio.
//We can choose which dimensino will be taken into account when rezing the base CGSize: Width or Height
func resized(size: CGSize, basedOn dimension: Dimension) -> CGSize {
    //In order to get the current device screen dimensions, we have to call UIScreen.main.bounds.size
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio = size.height / size.width
        width = screenWidth * (size.width / Device.baseScreenSize.rawValue.width)
        height = width * ratio
    case .height:
        ratio = size.width / size.height
        height = screenHeight * (size.height / Device.baseScreenSize.rawValue.height)
        width = height * ratio
    }
    
    return CGSize(width: width, height: height)
}

