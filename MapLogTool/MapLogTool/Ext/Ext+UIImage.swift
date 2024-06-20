//
//  Ext+UIImage.swift
//  MapLogTool
//
//  Created by D02020015 on 2021/6/1.
//

import Foundation
import UIKit

extension UIImage {
    // UIImage Resize
    func imageResize(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image
    }
}
