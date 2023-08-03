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
    // MARK: - Vars
    private var audioPlayer: AVAudioPlayer!
    private var currentPodcast: RSS_Post!
    private var playbackUpdater: CADisplayLink!
    
    // MARK: - UI
    private let podcastNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let progressBar: UIProgressView = {
        let v = UIProgressView(progressViewStyle: .bar)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 16).isActive = true
        v.layer.cornerRadius = 8
        v.backgroundColor = .black
        v.progressTintColor = .red
        v.layer.masksToBounds = true
        return v
    }()
    private let playBtn: StyledButton = {
        let btn = StyledButton()
        btn.widthAnchor.constraint(equalToConstant: 48).isActive = true
        btn.image = AssetsManager.Icons.pause.toIcon()
        return btn
    }()
    private let rewindBtn: StyledButton = {
        let btn = StyledButton()
        btn.widthAnchor.constraint(equalToConstant: 48).isActive = true
        btn.title = "-15"
        btn.titleColor = .black
        return btn
    }()
    private let forwardBtn: StyledButton = {
        let btn = StyledButton()
        btn.widthAnchor.constraint(equalToConstant: 48).isActive = true
        btn.title = "+15"
        btn.titleColor = .black
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        let link = Links.podcast1.rawValue.replaceASCIIWithCirillic()
        NetworkManager.shared.loadPodcasts(byPodcastLink: link) { [weak self] posts in
            guard let self = self else { fatalError("cant grab self") }
            
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

// MARK: - Private
private extension ViewController {
    func setupUI() {
        podcastNameLbl.attachTo(view: self.view, toSides: [.centerY], constant: 16)
        progressBar.attachTo(view: self.view, toSides: [.left], constant: 16)
        
        let v = UIView()
        rewindBtn.attachTo(view: v, toSides: [.left, .bottom, .top])
        playBtn.attachTo(view: v, toSides: [.centerX, .top, .bottom])
        forwardBtn.attachTo(view: v, toSides: [.right, .top, .bottom])
        v.attachTo(view: self.view, toSides: [.left], constant: 16)
        
        NSLayoutConstraint.activate([
            podcastNameLbl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            podcastNameLbl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            progressBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: podcastNameLbl.bottomAnchor, constant: 20),
            
            v.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60)
        ])
        
        playBtn.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        rewindBtn.addTarget(self, action: #selector(rewindBtnTapped), for: .touchUpInside)
        forwardBtn.addTarget(self, action: #selector(forwardBtnTapped), for: .touchUpInside)
    }
    
    func playPodcast(fileURL: URL?) {
        guard let fileURL = fileURL else {
            self.showAlert(title: "Error", message: "We can't find downloaded podcast")
            return
        }
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.delegate = self
            
            podcastNameLbl.text = currentPodcast.title
            playbackUpdater = CADisplayLink(target: self, selector: #selector(playbackProgressDidChange))
            playbackUpdater.preferredFramesPerSecond = 1
            playbackUpdater.add(to: .current, forMode: .common)
        } catch {
            print(error)
        }
    }
}

// MARK: - Actions
private extension ViewController {
    @objc func playBtnTapped() {
        if audioPlayer.isPlaying {
            playBtn.image = AssetsManager.Icons.play.toIcon()
            audioPlayer.pause()
        } else {
            playBtn.image = AssetsManager.Icons.pause.toIcon()
            audioPlayer.play()
        }
    }
    
    @objc func rewindBtnTapped() {
        // надо делать currentTime
        let newTime = audioPlayer.currentTime - 15 > 0 ? audioPlayer.currentTime - 15 : 0
        audioPlayer.currentTime = newTime
        
        playbackProgressDidChange()
    }
    
    @objc func forwardBtnTapped() {
        let newTime = audioPlayer.currentTime + 15
        audioPlayer.currentTime = newTime < audioPlayer.duration ? newTime : 0
        
        playbackProgressDidChange()
    }
    
    @objc func playbackProgressDidChange() {
        let normalizedTime = Float(audioPlayer.currentTime / audioPlayer.duration)
        progressBar.setProgress(normalizedTime, animated: true)
    }
}

// MARK: - AVAudioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate {
}
