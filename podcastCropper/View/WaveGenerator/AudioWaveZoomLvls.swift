//
//  AudioWaveZoomLvls.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 22.08.2023.
//

import Foundation

enum AudioWaveZoomLvls: Double {
    case sec1 = 1
    case sec5 = 5
    case sec15 = 15
    case sec30 = 30
    case min1 = 60
    case min5 = 300
    case min15 = 900
    
    static func getLvlBy(zoomVal zoom: Float) -> AudioWaveZoomLvls {
        return .sec1
    }
}
