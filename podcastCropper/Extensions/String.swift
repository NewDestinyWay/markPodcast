//
//  String.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 23.07.2023.
//

import Foundation

extension String {
    func toUrl() -> URL? {
        return URL(string: self)
    }
    
    func getUrlID() -> String {
        let pattern = "id[0-9]+"
        if let match = self.range(of: pattern, options: .regularExpression) {
            return self[match].filter("0123456789.".contains)
        }
        return ""
    }
    
    
}
