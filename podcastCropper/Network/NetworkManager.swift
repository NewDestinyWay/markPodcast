//
//  NetworkManager.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 23.07.2023.
//

import Foundation

struct PodcastJSONInfo: Decodable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Decodable {
    let wrapperType, kind: String?
    let collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionViewURL, feedUrl, trackViewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let collectionHDPrice: Int?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: String?
    let trackCount, trackTimeMillis: Int?
    let country, currency, primaryGenreName, contentAdvisoryRating: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
}

// MARK: - Network Manager
final class NetworkManager {
    static let shared = NetworkManager()
    
    func loadPodcast(byPodcastLink link: String,
                      completion: @escaping (_ rssFeed: String?)->Void) {
        
        let linksBuilder = LinksBuilder(link: link)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL(string: linksBuilder.iTunesLink)!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                completion(nil)
                return
            }

            do {
                let res = try JSONDecoder().decode(PodcastJSONInfo.self, from: data)
                let rssUrl = res.results.first?.feedUrl?.toUrl()
                self.loadRSSFeed(url: rssUrl) { res in
                    print("rese")
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}

// MARK: - Private
private extension NetworkManager {
    func loadRSSFeed(url: URL?,
                     completion: @escaping (_ res: String?)->Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        print(url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let parser = RSSParser(rssAsData: data, delegate: nil)
            print(data)
        }
        task.resume()
    }
}
