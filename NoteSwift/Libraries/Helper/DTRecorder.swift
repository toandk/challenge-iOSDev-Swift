//
//  DTRecorder.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import AVFoundation

class DTRecorder: NSObject {
    var audioRecorder: AVAudioRecorder? = nil
    
    init(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        
        let settings: [String: Any] = [AVFormatIDKey: Int(kAudioFormatLinearPCM),
                                       AVSampleRateKey: AppConstants.SAMPLE_RATE,
                                       AVNumberOfChannelsKey: 1,
                                       AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        }
        catch {
            print("error \(error)")
        }
        
        super.init()
        requestPermission()
        print("record: \(filePath)")
    }
    
    func requestPermission() {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission() { [weak self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    
                } else {
                    // Need to disable this function
                }
            }
        }
    }
    
    func startRecording() {
        stopRecording()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            print("error \(error)")
        }
        
        audioRecorder?.record()
    }
    
    func stopRecording() {
        if audioRecorder != nil && audioRecorder!.isRecording {
            audioRecorder?.stop()
        }
        
    }
}
