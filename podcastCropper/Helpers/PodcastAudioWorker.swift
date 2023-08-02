//
//  PodcastAudioWorker.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 01.08.2023.
//

import Foundation
import AVFoundation

/// This class will help us with download and save audio by some link
final class PodcastAudioWorker {
    static let shared = PodcastAudioWorker()
    
    var player: AVAudioPlayer!
    
    func downloadAudio(byAudioUrl url: URL?, completion: @escaping (_ data: Data?)->Void) {
        guard let audioUrl = url else { return }
        
        // create document folder url
        guard let docDirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        // create destination file url
        // lastPathComponent - fileName
        let destUrl = docDirUrl.appendingPathComponent(audioUrl.lastPathComponent)
        print("destination url: \(destUrl)")
        
        // check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destUrl.path) {
            try! FileManager.default.removeItem(at: destUrl)
            print("File already exist")
        } else {
            URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                guard let loc = location, error == nil else {
                    print("Some error was occured")
                    return
                }
                print("downloading was finished")
                do {
                    try FileManager.default.moveItem(at: loc, to: destUrl)
                    print("FileManager moved document to folder")
                    try self.player = AVAudioPlayer(contentsOf: destUrl)
                    self.player.play()
                } catch {
                    print(error)
                }
            }.resume()
        }
        
    }
}
