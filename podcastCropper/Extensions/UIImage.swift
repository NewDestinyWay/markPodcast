//
//  UIImage.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 03.08.2023.
//

import UIKit

extension UIImage {
    /// This method will create a new image with passed size
    /// - Parameter size: the size of a new image
    /// - Returns: new image with [arg] size
    func resize(toSize size: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

