//
//  AudioWaveView.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import UIKit

protocol AudioWaveViewDelegate {
    func audioWaveDidScroll(atPercent percent: Double)
}

final class AudioWaveView: UIView {
    private let waveHeight: CGFloat = 160
    private var audioDuration: Double = 0
    private var audioWaveWidthCons: NSLayoutConstraint?
    var delegate: AudioWaveViewDelegate?
    
    private let infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .labelsSecondary
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textAlignment = .center
        lbl.text = "Pinch two fingers outward to zoom in or out."
        return lbl
    }()
    
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func config(forAudioByUrl url: URL, audioDuration: Double, completion: @escaping ()->Void) {
        WaveGenerator().generateWaveImage(audioUrl: url,
                                          waveHeight: waveHeight,
                                          audioDuration: audioDuration,
                                          zoomLevel: .sec1) { waveImage in
            self.audioDuration = audioDuration
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let waveImage = waveImage
                else { fatalError("cant grab self || waveImage in AudioWaveView") }
                
                let iv = UIImageView(image: waveImage)
                iv.attachTo(view: self.scrollView, toSides: [.all4Sides, .centerY])
                
                self.scrollView.showsVerticalScrollIndicator = false
                self.scrollView.showsHorizontalScrollIndicator = true
                self.scrollView.contentSize = waveImage.size
                self.scrollView.showsHorizontalScrollIndicator = false
                let halfWidth = self.bounds.width / 2
                self.scrollView.contentInset = UIEdgeInsets(
                    top: 0, left: halfWidth, bottom: 0, right: halfWidth)
                print(halfWidth)
                self.scrollView.contentOffset = CGPoint(x: -halfWidth,
                                                        y: self.scrollView.contentOffset.y)
                
                UIView.animate(withDuration: 0.5) {
                    self.audioWaveWidthCons?.isActive = false
                    self.audioWaveWidthCons = iv.widthAnchor.constraint(equalToConstant: waveImage.size.width)
                    self.audioWaveWidthCons?.isActive = true
                    print("Img: ", waveImage.size.width)
                    completion()
                }
                
                print("good job")
            }
        }
    }
}

// MARK: - Private
private extension AudioWaveView {
    func commonInit() {
        infoLbl.attachTo(view: self, toSides: [.left, .right, .top])
        scrollView.attachTo(view: self, toSides: [.left, .right, .bottom])
        scrollView.delegate = self
        
        let scrollMidView = UIView()
        scrollMidView.attachTo(view: self, toSides: [.centerX])
        scrollMidView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: infoLbl.bottomAnchor, constant: 16),
            scrollView.heightAnchor.constraint(equalToConstant: waveHeight),
            scrollMidView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollMidView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollMidView.widthAnchor.constraint(equalToConstant: 3)
        ])
    }
}

extension AudioWaveView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width1Percent = (scrollView.contentSize.width + scrollView.contentInset.left) / 100
        let currentPercent = (scrollView.contentOffset.x + scrollView.contentInset.left) / width1Percent
        delegate?.audioWaveDidScroll(atPercent: currentPercent)
    }
}
