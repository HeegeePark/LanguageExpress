//
//  TTSManager.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/22/24.
//

import Foundation
import AVFoundation

class TTSManager {
    static let shared = TTSManager()
    private init() { }
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func play(_ string: String){
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .allowBluetooth)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
