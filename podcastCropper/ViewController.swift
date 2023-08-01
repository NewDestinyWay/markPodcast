//
//  ViewController.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 21.07.2023.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    private var player: AVAudioPlayer!
    private var audioPlayer: AVAudioPlayer!
    private var currentPodcast: RSS_Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let link = Links.podcast1.rawValue.replaceASCIIWithCirillic()
        NetworkManager.shared.loadPodcasts(byPodcastLink: link) { [weak self] posts in
            guard let podcastNameStartIndex = link.endIndex(of: "podcast/") else { return }
            guard let podcastNameEndIndex = link.index(of: "/id") else { return }
            let podcastNameFromLink = String(link[podcastNameStartIndex..<podcastNameEndIndex]).replacingOccurrences(of: "-", with: " ")

            guard let self = self else { return }
            posts.forEach({
                if podcastNameFromLink.lowercased() == $0.title.lowercased() {
                    self.currentPodcast = $0
                }
            })
            
            guard self.currentPodcast != nil else { return }
            NetworkManager.shared.downloadPodcastAudio(byLink: self.currentPodcast.mp3Link) { data in
                guard let data = data else {
                    print("ERROR")
                    return
                }
                print("success")
            }
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        DispatchQueue.main.async {
//            let sysMP :MPMusicPlayerController & MPSystemMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
//
//            //Grab current playing
//            let currItem : MPMediaItem? = sysMP.nowPlayingItem
//
//            //Grab currItem's artwork
//
//            // Create a new alert
//            var dialogMessage = UIAlertController(title: "Title is", message: currItem?.title, preferredStyle: .alert)
//            self.present(dialogMessage, animated: true, completion: nil)
//        }
//    }

}

