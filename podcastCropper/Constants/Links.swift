//
//  Links.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 21.07.2023.
//

import Foundation

enum Links: String {
    case podcast1 = "https://podcasts.apple.com/ru/podcast/%D1%8F%D0%B4-%D0%BC%D0%B5%D1%81%D1%8F%D1%86%D0%B0-%D0%BA%D0%B0%D0%BA-%D0%B8%D0%B7%D0%BE%D0%B1%D1%80%D0%B5%D0%BB%D0%B8-%D1%85%D0%B8%D0%BC%D0%B8%D0%BE%D1%82%D0%B5%D1%80%D0%B0%D0%BF%D0%B8%D1%8E/id1568720773?i=1000522679525"
}

struct LinksBuilder {
    var link: String
    
    var iTunesLink: String {
        "https://itunes.apple.com/lookup?id=\(link.getUrlID())&entity=podcast"
    }
}
