//
//  Links.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 21.07.2023.
//

import Foundation

enum Links: String {
    case podcast1 = "https://podcasts.apple.com/ru/podcast/%D0%BF%D0%BE%D1%87%D0%B5%D0%BC%D1%83-%D0%BC%D1%8B-%D0%B5%D1%89%D0%B5-%D0%B6%D0%B8%D0%B2%D1%8B/id1568720773?i=1000620912526"
    case podcast1Wav = "https://podcasts.apple.com/ru/podcast/%D1%81%D0%B0%D0%BC%D0%BE%D0%B5-%D0%B2%D1%80%D0%B5%D0%BC%D1%8F-%D1%80%D0%B0%D0%B4%D0%B8%D0%BE-special/id1653380502?i=1000616225740&l=en-GB"
}

struct LinksBuilder {
    var link: String
    
    var iTunesLink: String {
        "https://itunes.apple.com/lookup?id=\(link.getUrlID())&entity=podcast"
    }
}
