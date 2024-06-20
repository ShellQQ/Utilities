//
//  Ext+UIColor.swift
//  MapLogTool
//
//  Created by D02020015 on 2021/6/11.
//

import Foundation
import UIKit

extension UIColor {
    func randomColor() -> UIColor{
        let red = CGFloat(Int.random(in: 0...255)) / 255
        let green = CGFloat(Int.random(in: 0...255)) / 255
        let blue = CGFloat(Int.random(in: 0...255)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
