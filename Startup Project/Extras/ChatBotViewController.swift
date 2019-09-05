//
//  ChatBotViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/4/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import ApiAI
import AVKit
import Speech

class ChatBotViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
     var userDictCopy : [Int] = []
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var recognitionTask: SFSpeechRecognitionTask?
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var fromAlert = false
    
    var messages : [String] = []
    var sender : [String] = []
    var voiceBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setupSpeech()
        
        navigationController?.navigationBar.topItem?.title = "Chat Bot"
        navigationController?.isNavigationBarHidden = false 
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
    }
    
    @IBAction func btnStartSpeechToText(_ sender: UIButton) {
        
        if speechSynthesizer.isSpeaking {
            
            speechSynthesizer.stopSpeaking(at: .immediate)
            audioEngine.stop()
            self.recognitionRequest?.endAudio()
        }
        else {
     

        if audioEngine.isRunning {
            fromAlert = false
            audioEngine.stop()
            speechSynthesizer.stopSpeaking(at: .immediate)
            sendMessage(alertText: "")
            self.recognitionRequest?.endAudio()
            self.btnStart.isEnabled = false
            
        } else {
            self.btnStart.backgroundColor = .clear
            
            speechSynthesizer.stopSpeaking(at: .immediate)
            self.startRecording()
            
        }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func setupSpeech() {
        
        self.btnStart.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                break
            }
            
            OperationQueue.main.addOperation() {
                self.btnStart.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
    
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
       
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
 
                
                
                isFinal = (result?.isFinal)!
                
            }
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.audioEngine.inputNode.removeTap(onBus: 0)
                
                self.messages.append(result?.bestTranscription.formattedString ?? "")
                self.sender.append("You")
                self.sendMessage(alertText: result?.bestTranscription.formattedString ?? "")
                self.tableView.reloadData()
                self.tableViewScrollToBottom(animated: false)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.btnStart.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        self.audioEngine.inputNode.removeTap(onBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
       // self.userTextLabel.text = "Say something, I'm listening!"
    }
    
    
    @IBAction func typeToSpeechButton(_ sender: Any) {
        self.speechSynthesizer.stopSpeaking(at: .word)
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            if answer.text != ""{
            self.fromAlert = true
             
            self.sendMessage(alertText: answer.text ?? "")
                self.messages.append(answer.text!)
                self.sender.append("You")
                 self.tableView.reloadData()
               self.tableViewScrollToBottom(animated: false)
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    
    
    func sendMessage(alertText: String)
    {
        
        
        self.audioEngine.stop()
        
        let request = ApiAI.shared().textRequest()
        
        if fromAlert{
            request?.query = alertText
        }
            
        else {
       
            request?.query = alertText
       
        }
    
    
       
        
       //Returns the text from the service
        
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.messages.append(textResponse)
                self.sender.append("ChatBot")
                 self.tableView.reloadData()
               self.tableViewScrollToBottom(animated: false)
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        
    }
    

    
    func speechAndText(text: String) {
        
        
        self.audioEngine.stop()
        
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            self.speechSynthesizer.speak(speechUtterance)
       // self.outputLabel.text = text
    }
}


extension ChatBotViewController {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnStart.isEnabled = true
        } else {
            self.btnStart.isEnabled = false
        }
    }
}

extension ChatBotViewController : UITableViewDelegate, UITableViewDataSource

{
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.masksToBounds =  true
        cell.layer.cornerRadius = 8
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
 
        cell.separatorInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.detailTextLabel?.text = sender[indexPath.row]
        cell.textLabel?.text = self.messages[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    
    private func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableView.automaticDimension
    }
    
    
    
}
