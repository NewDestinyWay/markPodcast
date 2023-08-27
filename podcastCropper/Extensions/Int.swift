//
//  Int.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import Foundation

extension Int {
    func seconds() -> Int {
        return self % 60
    }
    
    func minutes() -> Int {
        return self / 60
    }
    
    func hours() -> Int {
        return self / 3600
    }
}
