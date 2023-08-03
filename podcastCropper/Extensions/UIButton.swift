//
//  UIButton.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 03.08.2023.
//

import UIKit

extension UIButton.Configuration {
    mutating func setFont(width: Int, weight: Int, isOblique: Bool = false) {
        self.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer {
                incoming in
                // Create a mutable reference to the "incoming"
                var outgoing = incoming
//                outgoing.font = FontMaker.getFont(fontSize: width, fontWeight: weight)
                outgoing.font = UIFont.systemFont(ofSize: CGFloat(width))
                return outgoing
            }
    }
    
    mutating func set(font: UIFont?) {
        self.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer {
                incoming in
                // Create a mutable reference to the "incoming"
                var outgoing = incoming
                outgoing.font = font
                return outgoing
            }
    }
}

