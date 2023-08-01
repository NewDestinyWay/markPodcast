//
//  RSSParser.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 25.07.2023.
//

import Foundation

// MARK: - XML_Tags
enum XML_Tags: String {
    case item = "item"
    case title = "title"
    case mp3Link = "enclosure"
}

// MARK: - RSS_Post
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
    private(set) var posts: [RSS_Post] = []
    private var parser: XMLParser!
    private var delegate: RSSParserDelegate?
    
    private var currentTitle = ""
    private var currentItem = ""
    private var isShouldSaveTitle: Bool = false
    
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
        currentItem = elementName
        if elementName == XML_Tags.title.rawValue { isShouldSaveTitle = true }
        if elementName == XML_Tags.mp3Link.rawValue {
            posts.append(RSS_Post(title: currentTitle.removeAllNonAlphaNumericChars(),
                                  mp3Link: attributeDict["url"]))
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == XML_Tags.title.rawValue { isShouldSaveTitle = false }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentItem == XML_Tags.title.rawValue && isShouldSaveTitle {
            currentTitle = string
        }
    }
}
