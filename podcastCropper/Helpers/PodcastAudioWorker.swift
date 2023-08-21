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
    
    func cropAudio(from startTime: Double, to endTime: Double, completion: @escaping (_ outUrl: URL)->Void) {
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")
        let startTime = CMTime(seconds: startTime, preferredTimescale: 60000)
        let duration = CMTime(seconds: endTime, preferredTimescale: 60000)
        let audioAsset = AVAsset(url: url!)
        let composition = AVMutableComposition()
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio,
                                                                preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        
        let sourceAudioTrack = audioAsset.tracks(withMediaType: AVMediaType.audio).first!
        do {
             try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration), of: sourceAudioTrack, at: .zero)
             
        } catch {
             print(error.localizedDescription)
             return
        }
        let outUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("result.m4a")
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            completion(outUrl)
            return
        }
        exporter.outputURL = outUrl
        exporter.outputFileType = AVFileType.m4a
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously {
            completion(outUrl)
        }
    }
}
