//
//  AssetsManager.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 03.08.2023.
//

import UIKit

final class AssetsManager {
    enum Icons: String {
        case play
        case pause
        
        func toIcon(withSize size: CGSize = CGSize(width: 16, height: 16),
                    color: UIColor = .black) -> UIImage? {
            return UIImage(named: self.rawValue)?.resize(toSize: size).withTintColor(color)
        }
    }
}
