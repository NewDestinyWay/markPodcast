//
//  PodcastAudioWorker.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 01.08.2023.
//

import Foundation

/// This class will help us with download and save audio by some link
final class PodcastAudioWorker {
    static let shared = PodcastAudioWorker()
    
    func downloadAudio(byAudioUrl url: URL?, completion: @escaping (_ audioFileLoc: URL?)->Void) {
        guard let audioUrl = url else { return }
        
        // create document folder url
        guard let docDirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        // create destination file url
        // lastPathComponent - fileName
        let destUrl = docDirUrl.appendingPathComponent(audioUrl.lastPathComponent)
        print("destination url: \(destUrl)")
        
        // check if file exist. If true then we remove old file
        if FileManager.default.fileExists(atPath: destUrl.path) {
            try! FileManager.default.removeItem(at: destUrl)
        }
        // Download and try to save new audio file
        URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
            guard let loc = location, error == nil else {
                completion(nil)
                return
            }
            do {
                try FileManager.default.moveItem(at: loc, to: destUrl)
                print("FileManager moved document to folder")
                completion(destUrl)
            } catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}
