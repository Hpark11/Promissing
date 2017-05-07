//
//  RecordPromiseViewController.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 5..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView
import Speech

class RecordPromiseViewController: UIViewController, SFSpeechRecognizerDelegate {

    var timer: Timer?
    var change: CGFloat = 0.01
    var audioPlayer: AVAudioPlayer!
    
    let speechRecognizer = SFSpeechRecognizer()!
    let audioEngine = AVAudioEngine()
    
    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask = SFSpeechRecognitionTask()
    var promise: Promise?
    
    //let alertController = UIAlertController(title: "저장", message: <#T##String?#>, preferredStyle: <#T##UIAlertControllerStyle#>)
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var waveView: SwiftSiriWaveformView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(refreshWaveView), userInfo: nil, repeats: true)
        
        setSpeechRecognition()
    }
    
    func setSpeechRecognition() {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                self.recordButton.isEnabled = true
            case .denied:
                self.recordButton.isEnabled = false
                self.statusLabel.text = "사용자가 음성인식 사용을 허가하지 않았습니다"
            case .restricted:
                self.recordButton.isEnabled = false
                self.statusLabel.text = "음성인식 사용이 제한되었습니다"
            case .notDetermined:
                self.recordButton.isEnabled = false
                self.statusLabel.text = "음성인식 사용이 아직 허가되지 않았습니다"
            }
        }
    }
    
    func savePromise() {
        if promise == nil {
            promise = Promise(context: managedObjectContext)
        }
        
        promise?.content = contentTextView.text
        promise?.promisedAt = Date() as NSDate
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func refreshWaveView() {
        if self.waveView.amplitude <= self.waveView.idleAmplitude || self.waveView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        self.waveView.amplitude += self.change
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordButtonTouchDown(_ sender: Any) {

    }

    @IBAction func recordButtonTouchUpInside(_ sender: Any) {
        
        if audioEngine.isRunning {
            audioEngine.inputNode?.removeTap(onBus: 0)
            audioEngine.stop()
            recognitionRequest.endAudio()
            recognitionTask.cancel()

            statusLabel.text = "녹음 시작"
            savePromise()
        } else {
            statusLabel.text = "녹음 중지"
            
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSessionCategoryRecord)
                try audioSession.setMode(AVAudioSessionModeMeasurement)
                try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
 
                if let inputNode = audioEngine.inputNode {
                    recognitionRequest.shouldReportPartialResults = true
                    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                        if let result = result {
                            self.contentTextView.text = result.bestTranscription.formattedString
                            if result.isFinal {
                                self.audioEngine.stop()
                                inputNode.removeTap(onBus: 0)
                                
                                self.statusLabel.text = "녹음 시작"
                            }
                        }
                    })
                    
                    let recordingFormat = inputNode.outputFormat(forBus: 0)
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when) in
                        self.recognitionRequest.append(buffer)
                    })
                    audioEngine.prepare()
                    try audioEngine.start()
                }
            } catch {
                print("::: [hPark] Errors in Speech Recognition : \(error)")
            }
        }
    }
    
    @IBAction func recordButtonTouchUpOutside(_ sender: Any) {
    }
}
