//
//  ViewControllerModel.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 21.08.2023.
//

import Foundation

final class ViewControllerModel {
    func fetchPodcastInfo(byStringUrl url: String?, completion: @escaping (_ podcast: Podcast)->Void) {
        guard let url = url?.toUrl() else { return }
        let group = DispatchGroup()
        
        var pTtl = ""
        group.enter()
        getPodcastTitle(url: url) { title in
            pTtl = title?.removeAllNonAlphaNumericChars() ?? ""
            group.leave()
        }
        
        var rssPosts: [RSS_Post] = []
        group.enter()
        NetworkManager.shared.loadPodcasts(byPodcastLink: url.description) { posts in
            rssPosts = posts
            print("posts all")
            group.leave()
            /*
            guard let nameStartIndex = link.endIndex(of: "podcast/") else { return }
            guard let nameEndIndex = link.index(of: "/id") else { return }
            let podcastNameFromLink = String(link[nameStartIndex..<nameEndIndex]).replacingOccurrences(of: "-", with: " ")
            posts.forEach({
                if podcastNameFromLink.lowercased() == $0.title.lowercased() {
                    self.currentPodcast = $0
                }
            })
            
            guard self.currentPodcast != nil else {
                self.showAlertInMainThread(message: "We cant find your podcast from downloaded")
                return
            }
            PodcastAudioWorker.shared.downloadAudio(byAudioUrl: self.currentPodcast.mp3Link.toUrl()) { audioFileLoc in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        fatalError("cant grab self")
                    }
                    self.playPodcast(fileURL: audioFileLoc)
                }
            }
             */
        }
        
        group.notify(queue: .main) {
            var curPost: RSS_Post!
            rssPosts.forEach({
                if pTtl.lowercased() == $0.title.lowercased() {
                    curPost = $0
                }
            })
            guard curPost != nil else { fatalError("post not found") }
            PodcastAudioWorker.shared.downloadAudio(byAudioUrl: curPost.mp3Link.toUrl()) { audioFileLoc in
                guard let loc = audioFileLoc else { fatalError("here") }
                completion(Podcast(title: pTtl, audioFileLoc: loc))
            }
        }
    }
}

// MARK: - Private
private extension ViewControllerModel {
    func getPodcastTitle(url: URL, completion: @escaping(_ title: String?)->Void) {
        NetworkManager.shared.get(byUrl: url) { netManCompl in
            guard let data = netManCompl.data,
                  let s = String(data: data, encoding: .utf8)
            else { return }
            
            var offset = 0
            guard let ttlSIndex = s.range(of: "<title>"),
                  let ttlEIndex = s.range(of: "</title>") else {
                fatalError("Cant find title range")
            }
            
            var curIndex = s.index(after: ttlSIndex.upperBound)
            while(s[curIndex] != Character("\"") && s[curIndex] != Character("«")) {
                offset += 1
                curIndex = s.index(ttlSIndex.upperBound, offsetBy: offset)
            }
            while(s[curIndex] != Character("\"") && s[curIndex] != Character("»")) {
                offset += 1
                curIndex = s.index(ttlSIndex.upperBound, offsetBy: offset)
            }
            while(s[curIndex] != Character(":")) {
                offset += 1
                curIndex = s.index(ttlSIndex.upperBound, offsetBy: offset)
            }
            offset += 3
            curIndex = s.index(ttlSIndex.upperBound, offsetBy: offset)
            // теперь мы на начале тайтла
            var podcastTitle = ""
            while(s[curIndex] != Character("\"") && s[curIndex] != Character("»")) {
                podcastTitle += String(s[curIndex])
                offset += 1
                curIndex = s.index(ttlSIndex.upperBound, offsetBy: offset)
            }
            completion(podcastTitle)
        }
    }
}
