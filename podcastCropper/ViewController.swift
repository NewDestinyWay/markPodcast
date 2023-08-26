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
    private var currentPodcast: Podcast!
    private var playbackUpdater: CADisplayLink!
    private let model = ViewControllerModel()
    
    // MARK: - UI
    private var navView: NavView!
    private let lblPodcastName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    private let lblPodcastAuthor: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let waveView = AudioWaveView()
    
    // MARK: - CROP UI
    enum CropUITags: Int {
        case tfCropFrom = 0
        case pickerCropFrom = 1
        
        case tfCropTo = 2
        case pickerCropTo = 3
    }
    
    private let tfCropFrom = UITextField()
    private let pickerCropFrom = UIPickerView()
    private let tfCropTo = UITextField()
    private let pickerCropTo = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")!
        
        setupUI()
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            waveView.config(forAudioByUrl: url,
                            audioDuration: Double(audioPlayer.duration)) {
                
            }
        } catch let error {
            print(error)
        }
        
        /*
        setupUI()
        print("START!!!")
        model.fetchPodcastInfo(byStringUrl: Links.podcast1.rawValue) { [weak self] podcast in
            guard let self = self else { return }
            self.currentPodcast = podcast
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.playPodcast(fileURL: podcast.audioFileLoc)
                print("END!!!")
            }
        }
         */
    }
}

// MARK: - Private
private extension ViewController {
    func setupUI() {
        navView = NavViewBuilder.createSnippet.navView(delegate: self)
        navView.attachTo(view: self.view, toSides: [.left, .right, .top])
        
        let sPodcastInfo = UIStackView(arrangedSubviews: [
            lblPodcastName, lblPodcastAuthor])
        sPodcastInfo.axis = .vertical
        sPodcastInfo.spacing = 8
        sPodcastInfo.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        sPodcastInfo.distribution = .fillEqually
        sPodcastInfo.attachTo(view: self.view, toSides: [.left, .right])

        waveView.attachTo(view: self.view, toSides: [.left, .right])
        waveView.delegate = self
        NSLayoutConstraint.activate([
            sPodcastInfo.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: 24),
            waveView.topAnchor.constraint(equalTo: sPodcastInfo.bottomAnchor, constant: 24)
        ])
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
            
//            podcastNameLbl.text = currentPodcast.title
            playbackUpdater = CADisplayLink(target: self, selector: #selector(playbackProgressDidChange))
            playbackUpdater.preferredFramesPerSecond = 1
            playbackUpdater.add(to: .current, forMode: .common)
            setupCropSection()
        } catch {
            print(error)
        }
    }
    
    func setupCropSection() {
        tfCropFrom.inputView = pickerCropFrom
        pickerCropFrom.delegate = self
        pickerCropFrom.dataSource = self
        addPickerDoneBtn(toTextField: tfCropFrom)
        
        tfCropTo.inputView = pickerCropTo
        pickerCropTo.delegate = self
        pickerCropTo.dataSource = self
        addPickerDoneBtn(toTextField: tfCropTo)

        let lbl = UILabel()
        lbl.text = "Crop Audio"
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let fromLbl = UILabel()
        fromLbl.text = "From"
        fromLbl.attachTo(view: v, toSides: [.left, .top, .bottom])
        tfCropFrom.attachTo(view: v, toSides: [.top, .bottom])
        NSLayoutConstraint.activate([
            tfCropFrom.leftAnchor.constraint(equalTo: fromLbl.rightAnchor, constant: 10)
        ])
        
        let toLbl = UILabel()
        toLbl.text = "To"
        toLbl.attachTo(view: v, toSides: [.top, .bottom])
        tfCropTo.attachTo(view: v, toSides: [.top, .bottom, .right])
        NSLayoutConstraint.activate([
            toLbl.rightAnchor.constraint(equalTo: tfCropTo.leftAnchor, constant: 10)
        ])
        
        pickerCropFrom.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pickerCropTo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        v.attachTo(view: self.view, toSides: [.left, .right, .bottom])
    }
    
    func addPickerDoneBtn(toTextField tf: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.sizeToFit()
        toolBar.tintColor = .black
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneBtnTapped))
        toolBar.setItems([doneBtn], animated: false)
        tf.inputAccessoryView = toolBar
    }
    
    func cropAudio(from startTime: Double, to endTime: Double, completion: @escaping (_ outUrl: URL)->Void) {
        PodcastAudioWorker.shared.cropAudio(from: 0, to: 0) { outUrl in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { fatalError("cant grab self in crop audio func") }
                do {
                    try self.audioPlayer = AVAudioPlayer(contentsOf: outUrl)
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                    
                    self.setupCropSection()
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Actions
private extension ViewController {
    @objc func playBtnTapped() {
        if audioPlayer.isPlaying {
//            playBtn.image = AssetsManager.Icons.play.toIcon()
            audioPlayer.pause()
        } else {
//            playBtn.image = AssetsManager.Icons.pause.toIcon()
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
//        progressBar.setProgress(normalizedTime, animated: true)
    }
    
    @objc func pickerDoneBtnTapped() {
        let formatter = DateFormatter()
        self.view.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let duration = audioPlayer.duration
        if duration >= 3600 { return 3 }
        else if duration > 60 { return 2 }
        else { return 1 }
        
//        if pickerView.tag == CropUITags.pickerCropFrom.rawValue {
//
//        } else if pickerView.tag == CropUITags.pickerCropTo.rawValue {
//
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let duration = audioPlayer.duration
        switch component {
        case 0: // hours
            return Int(duration) / 3600
        case 1: // minutes
            return 59
        case 2: // seconds
            return 59
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = (row + 1).description
        label.textAlignment = .center
        return label
    }
}

// MARK: - AVAudioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate {
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        currentTextFieldTag = textField.tag
    }
}

// MARK: - NavViewDelegate
extension ViewController: NavViewDelegate {
    func leftBtnTapped() {
        
    }
    
    func rightBtnTapped() {
        
    }
}

// MARK: - AudioWaveViewDelegate
extension ViewController: AudioWaveViewDelegate {
    func audioWaveDidScroll(atPercent percent: Double) {
        let duration = Double(audioPlayer.duration)
        let time1Percent = duration / 100.0
        var curTime = percent * time1Percent
        
        // timelineView.scrollAt(percent: percent)
        // TODO: - секунды в часы, минуты
        // lblCurrentTime.text = String(format: "%.2f", curTime)
    }
}
