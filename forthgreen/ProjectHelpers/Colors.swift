//
//  Colors.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = colorFromHex(hex: "#FFFFFF") //1
var BlackColor : UIColor = UIColor(named: "charcoal")!//2
var LightGrayColor : UIColor = colorFromHex(hex: "#CCCCCC") //3
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "#C4C4C4") //4

var PaleGrayColor : UIColor = UIColor(named: "paleGrey")!
var GreenColor : UIColor = UIColor(named: "turquoiseGreen")!
var GrayColor : UIColor = UIColor(named: "coolGrey")!
var NavigationBorderColor : UIColor = UIColor(named: "NavigationBorder")!

var AppColor : UIColor = colorFromHex(hex: "#008037") //9

enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case Black = 2
    case LightGray = 3
    case ExtraLightGray = 4
    
    case App = 9
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
                case .Clear: //0
                    return ClearColor
                case .White: //1
                    return WhiteColor
                case .Black: //2
                    return BlackColor
                case .LightGray: //3
                    return LightGrayColor
                case .ExtraLightGray: //4
                    return ExtraLightGrayColor
                case .App: //9
                    return AppColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case Login = 1
}
