//
//  UIColor.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import UIKit

extension UIColor {
    // MARK: - Colors
    static let labelsSecondary = UIColor(60, 60, 67, 0.6)
    static let labelsQuaternary = UIColor(60, 60, 67, 0.18)
    static let labelsTertiary = UIColor(60, 60, 67, 0.3)
    
    // MARK: - Init
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) {
        
        precondition(0...255 ~= red   &&
                     0...255 ~= green &&
                     0...255 ~= blue  &&
                     0...255 ~= 255,
                     "input range is out of range 0...255")
        
        self.init(red: CGFloat(red)/255.0,
                  green: CGFloat(green)/255.0,
                  blue: CGFloat(blue)/255.0,
                  alpha: alpha)
    }
}
