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
    
    func replaceASCIIWithCirillic() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    func removeAllNonAlphaNumericChars() -> String {
//        let pattern = "[^A-Za-z0-9]+"
//        return self.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
        let rA = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: " ")
        var r = ""
        rA.forEach({
            r += $0.description
        })

        return r.replacingOccurrences(of: "  ", with: " ")
    }
    
    // MARK: - Index
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
