//
//  RSSParser.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 25.07.2023.
//

import Foundation

struct RSS_Post {
    var title: String!
    var mp3Link: String!
}

// MARK: - Delegate
protocol RSSParserDelegate: AnyObject {
    func didParse(result: [RSS_Post])
}

// MARK: - Class
final class RSSParser: NSObject {
    private var posts: [RSS_Post] = []
    private var parser: XMLParser!
    private var delegate: RSSParserDelegate?
    
    private var currentTitle = ""
    
    init(rssAsData data: Data, delegate: RSSParserDelegate?) {
        super.init()
        self.parser = XMLParser(data: data)
        self.delegate = delegate
        parser.delegate = self
        parser.parse()
    }
}

extension RSSParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error while parsing")
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == "title" {
            print(attributeDict)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}
