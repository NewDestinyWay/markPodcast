//
//  AssetsManager.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 03.08.2023.
//

import UIKit

final class AssetsManager {
    enum Navigation: String {
        case navArrowLeft
        
        var icon: UIImage? {
            return UIImage(named: self.rawValue)?.resize(toSize: CGSize(width: 17, height: 22))
        }
    }
}
