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
        _ imageSize: CGSize,
        _ strokeColor: UIColor,
        _ backgroundColor: UIColor
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        
        let drawingRect = CGRect(origin: .zero, size: imageSize)
        let middleY = imageSize.height / 2
        
        context.setFillColor(backgroundColor.cgColor)
        context.setAlpha(1.0)
        context.fill(drawingRect)
        
        let voiceBlockW: CGFloat = 20
        context.setLineWidth(voiceBlockW)
        
        let max: CGFloat = CGFloat(samples.max() ?? 0)
        let heightNormalizationFactor = imageSize.height / max / 2
        let widthNormalizationFactor = imageSize.width / CGFloat(samples.count)
        ///*
        let framesCount = 100
        let spaceBtwFrames = 8
        let lineW = 20
        let frameW = CGFloat(lineW) + CGFloat(spaceBtwFrames)
        let frameSize = 1000
        for frameNum in 0..<framesCount - 1 {
            var step = 0
            var frameAv: Float = 0
            while frameNum * frameSize + step < samples.count && step < frameSize {
                frameAv += samples[frameNum * frameSize + step] * Float(heightNormalizationFactor)
                step += 1
            }

            frameAv /= Float(step)
            print(frameAv, frameNum)
            frameAv *= Float(heightNormalizationFactor)

            let framePos = CGFloat(frameNum) * frameW
            context.move(to: CGPoint(x: framePos, y: middleY - CGFloat(frameAv)))
            context.addLine(to: CGPoint(x: framePos, y: middleY + CGFloat(frameAv)))
            context.setStrokeColor(strokeColor.cgColor)
            context.strokePath()
        }
        //*/
        
        /*
        for index in 0 ..< samples.count {
            let pixel = CGFloat(samples[index]) * heightNormalizationFactor
            
            let x = CGFloat(index) * widthNormalizationFactor
            
            context.move(to: CGPoint(x: x, y: middleY - pixel))
            context.addLine(to: CGPoint(x: x, y: middleY + pixel))
//            context.addRect(CGRect(x: x, y: middleY + pixel, width: 6, height: imageSize.height))
            context.setStrokeColor(strokeColor.cgColor)
            context.strokePath()
            print(x)
        }
        */
        guard let soundWaveImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        return soundWaveImage
    }
    
    func generateWaveImage(from audioUrl: URL, in imageSize: CGSize,completion:@escaping (_ waveformImage:UIImage?)->Void) {
        
        readBuffer(audioUrl, completion: { result in
            let img = self.generateWaveImage(result!, imageSize, UIColor.blue, UIColor.white)
            completion(img)
        })
    }
}

