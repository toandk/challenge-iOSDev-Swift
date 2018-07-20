//
//  DTPlayer.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import AVFoundation

class DTPlayer : NSObject, AVAudioPlayerDelegate {
    static let sharedPlayer = DTPlayer()
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    
    func play(filePath: String) {
        stopPlaying()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            let url = URL(fileURLWithPath: filePath)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1
            isPlaying = true
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch {
            
        }
    }
    
    func stopPlaying() {
        if audioPlayer != nil && audioPlayer!.isPlaying {
            audioPlayer?.stop()
        }
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
