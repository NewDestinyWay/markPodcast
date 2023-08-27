//
//  AudioWaveZoomLvls.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 22.08.2023.
//

import Foundation

enum AudioWaveZoomLvls {
    case sec1
    case sec5
    case sec15
    case sec30
    case min1
    case min5
    case min15
    
    var seconds: Double {
        switch self {
        case .sec1: return 1
        case .sec5: return 5
        case .sec15: return 15
        case .sec30: return 30
            
        case .min1: return 60
        case .min5: return 300
        case .min15: return 900
        }
    }
    
    static func getLvlBy(zoomVal zoom: Float) -> AudioWaveZoomLvls {
        return .sec1
    }
}
