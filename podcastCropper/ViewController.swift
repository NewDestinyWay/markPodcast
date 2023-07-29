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

    var player: AVAudioPlayer!
    private var audioPlayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "music.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            //create your audioPlayer in your parent class as a property
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
            
            //Grab the controller
        } catch {
            print("couldn't load the file")
        }
        
        /*
        NetworkManager.shared.loadPodcast(byPodcastLink: Links.podcast1.rawValue) { rssFeed in
            print("rss feed is: \(rssFeed)")
        }
        */
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            let sysMP :MPMusicPlayerController & MPSystemMusicPlayerController = MPMusicPlayerController.systemMusicPlayer

            //Grab current playing
            let currItem : MPMediaItem? = sysMP.nowPlayingItem

            //Grab currItem's artwork
            
            // Create a new alert
            var dialogMessage = UIAlertController(title: "Title is", message: currItem?.title, preferredStyle: .alert)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

}

