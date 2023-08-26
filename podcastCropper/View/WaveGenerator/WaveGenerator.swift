//
//  WaveGenerator.swift
//  MusicWaveDemo
//
//
//  Created by Bhavnish on 06/09/2022.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation

import AVFoundation
import CoreGraphics
import Foundation
import UIKit

class WaveGenerator {
    private func readBuffer(_ audioUrl: URL,completion:@escaping (_ wave:UnsafeBufferPointer<Float>?)->Void)  {
        let file = try! AVAudioFile(forReading: audioUrl)
        
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        else { return completion(UnsafeBufferPointer<Float>(_empty: ()))  }
        do {
            try file.read(into: buffer)
        } catch {
            print(error)
        }
        
        //        let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength)))
        let floatArray = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
        
        completion(floatArray)
    }
    
    private func generateWaveImage(
        _ samples: UnsafeBufferPointer<Float>,
        _ imageHeight: CGFloat,
        _ strokeColor: UIColor,
        _ duration: Double,
        _ zoomTimeInterval: AudioWaveZoomLvls,
        _ backgroundColor: UIColor
    ) -> UIImage? {
        
        let audioLineW: CGFloat = 4
        let spaceBtwAudioLines: CGFloat = 2
        let frameW = audioLineW + spaceBtwAudioLines
        let framesInTimeSection = 25
        
        let framesCount = Int(duration / zoomTimeInterval.rawValue * Double(framesInTimeSection))
        var imgTotalWidth = CGFloat(framesCount) * audioLineW
        imgTotalWidth += CGFloat(framesCount) * spaceBtwAudioLines
        let imageSize = CGSize(width: imgTotalWidth, height: imageHeight)
        // а дальше рисуем
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        
        let drawingRect = CGRect(origin: .zero, size: imageSize)
        let middleY = imageSize.height / 2
        
        context.setFillColor(backgroundColor.cgColor)
        context.setAlpha(1.0)
        context.fill(drawingRect)
        context.setLineWidth(audioLineW)
        
        let max: CGFloat = CGFloat(samples.max() ?? 0)

        let samplesInFrame = samples.count / framesCount
        for frameNum in 0..<framesCount - 1 {
            var step = 0
            var frameAv: Float = 0
            while frameNum * samplesInFrame + step < samples.count && step < samplesInFrame {
                frameAv += samples[frameNum * samplesInFrame + step] * Float(imageSize.height / max / 2)
                step += 1
            }

            frameAv /= Float(step)
            frameAv *= Float(imageSize.height / max / 2)

            let framePos = CGFloat(frameNum) * frameW
            context.move(to: CGPoint(x: framePos, y: middleY - CGFloat(frameAv)))
            context.addLine(to: CGPoint(x: framePos, y: middleY + CGFloat(frameAv)))
            context.setStrokeColor(strokeColor.cgColor)
            context.strokePath()
//            print(framePos, frameNum)
        }
        
        guard let soundWaveImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        return soundWaveImage
    }
    
    func generateWaveImage(audioUrl url: URL,
                           waveHeight h: CGFloat,
                           audioDuration duration: Double,
                           zoomLevel: AudioWaveZoomLvls,
                           completion: @escaping (_ waveImage: UIImage?)->Void) {
        readBuffer(url) { wave in
            guard let res = wave else { fatalError("Cant decode audio" ) }
            let img = self.generateWaveImage(res, h, .black, duration, zoomLevel, .white)
            completion(img)
        }
    }
}

