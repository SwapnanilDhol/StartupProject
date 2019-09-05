//
//  ChatViewController.swift
//  Startup Project
//
//  Created by Swapnanil Dhol on 9/5/19.
//  Copyright © 2019 Swapnanil Dhol. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AVKit
import ApiAI


class ChatViewController: JSQMessagesViewController {


    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOngoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    lazy var speechSynthesizer = AVSpeechSynthesizer()
    lazy var botImageView = UIImageView()
    
    
    var chatWindowStatus : ChatWindowState = .maximised
    var botImageTapGesture: UITapGestureRecognizer?
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        
        self.senderId = "some userId"
        self.senderDisplayName = "some userName"
        SpeechManager.shared.delegate = self

        self.addMicButton()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.populateWithWelcomeMessage()
        })
        

        
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func populateWithWelcomeMessage()
    {
        self.addMessage(withId: "BotId", name: "Bot", text: "Hi I am Victoria@FastLane")
        self.addMessage(withId: "BotId", name: "Bot", text: "I am here to help you about anything related to your claim")
        self.finishReceivingMessage()
    }

    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    func addMicButton()
    {
        let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        let micButton = UIButton(type: .custom)
        micButton.setImage(#imageLiteral(resourceName: "Tap2SpeakIcon"), for: .normal)
        micButton.frame = CGRect(x: 0, y: 0, width: 25, height: height)
        
        self.inputToolbar.contentView.leftBarButtonItemWidth = 25
        self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(micButton)
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOfMic(gesture:)))
        micButton.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPressOfMic(gesture:UILongPressGestureRecognizer)
    {
        if gesture.state == .began
        {
            
            SpeechManager.shared.startRecording()
        }
        else if gesture.state == .ended
        {
            SpeechManager.shared.stopRecording()
            if inputToolbar.contentView.textView.text == "Say something, I'm listening!"
            {
                inputToolbar.contentView.textView.text = ""
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    

    @objc func handleTap(gesture: UITapGestureRecognizer)
    {
        if chatWindowStatus == .minimised
        {
            botImageView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.frame = rect
                self.view.clipsToBounds = true
                self.view.layer.cornerRadius = 0
                self.chatWindowStatus = .maximised
                
            }, completion: { (completed) in
                
                self.inputToolbar.isUserInteractionEnabled = true
                self.view.removeGestureRecognizer(self.botImageTapGesture!)
            })
        }
    }
    
    func performQuery(senderId:String,name:String,text:String) {
        let request = ApiAI.shared().textRequest()
        if text != "" {
            request?.query = text
        }
        else {
            return
        }
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if response.result.action == "bot.quit" {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let quit = parameters["quit"]?.stringValue
                    {
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                            
                        })
                    }
                }
            }
            if let textResponse = response.result.fulfillment.speech
            {
                SpeechManager.shared.speak(text: textResponse)
                self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
                self.finishReceivingMessage()
            }
        }, failure: { (request, error) in
            print(error)
        })
        ApiAI.shared().enqueue(request)
    }
    



}

extension ChatViewController: SpeechManagerDelegate {
    
    func didStartedListening(status: Bool) {
        if status{
            self.inputToolbar.contentView.textView.text = "Say something, I'm listening"
        }
    }
    func didReceiveText(text: String) {
        self.inputToolbar.contentView.textView.text = text
        
        if text != "Say something, I'm listening"
        {
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
    
}

extension ChatViewController{
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    private func setupOngoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactor = JSQMessagesBubbleImageFactory()
        return bubbleImageFactor!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor(red:0.43, green:0.23, blue:0.76, alpha:1.0))
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        
        if message.senderId == senderId
        {
            cell.textView.textColor = UIColor.white
        }
        else {
            cell.textView.textColor = UIColor.white
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        addMessage(withId: senderId, name: senderDisplayName!, text: text!)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        performQuery(senderId: senderId, name: senderDisplayName, text: text!)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
       performQuery(senderId: senderId, name: senderDisplayName, text: "Multimedia")
        
    }
}


enum ChatWindowState
{
    case minimised
    case maximised
}


