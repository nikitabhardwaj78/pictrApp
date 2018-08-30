//
//  ChatViewController.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 5/15/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController  {
    
    var chat: Chat!
    var messagesHandle: DatabaseHandle = 0
    var messagesRef: DatabaseReference?
    var messages = [Message]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        let color = UIColor.jsq_messageBubbleRed()
        //(displayP3Red: 237.0, green: 74.0, blue: 89.0, alpha: 1.0)
        return bubbleImageFactory.outgoingMessagesBubbleImage(with: color)
    }()
    
    var incomingBubbleImageView: JSQMessagesBubbleImage = {
        guard let bubbleImageFactory = JSQMessagesBubbleImageFactory() else {
            fatalError("Error creating bubble image factory.")
        }
        
        let color = UIColor.jsq_messageBubbleLightGray()
        return bubbleImageFactory.incomingMessagesBubbleImage(with: color)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupJSQMessagesViewController()
        tryObservingMessages()
        // Do any additional setup after loading the view.
    }
    deinit {
        messagesRef?.removeObserver(withHandle: messagesHandle)
    }
    func tryObservingMessages() {
        guard let chatKey = chat?.key else { return }
        
        messagesHandle = ChatService.observeMessages(forChatKey: chatKey, completion: { [weak self] (ref, message) in
            self?.messagesRef = ref
            
            if let message = message {
                self?.messages.append(message)
                self?.finishReceivingMessage()
            }
        })
    }
    func setupJSQMessagesViewController() {
        // 1. identify current user
        senderId = User.current.uid
        senderDisplayName = User.current.username
        title = chat.title
        
        // 2. remove attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        // 3. remove avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatViewController {
    // 1
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 2
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // 3
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item].jsqMessageValue
    }
    
    // 4
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let sender = message.sender
        
        if sender.uid == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    // 5
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = (message.sender.uid == senderId) ? .white : .black
        return cell
}
}
extension ChatViewController {
    func sendMessage(_ message: Message) {
        // 1
        if chat?.key == nil {
            // 2
            ChatService.create(from: message, with: chat, completion: { [weak self] chat in
                guard let chat = chat else { return }
                
                self?.chat = chat
                
                // 3
                self?.tryObservingMessages()
            })
        } else {
            // 4
            ChatService.sendMessage(message, for: chat)
        }
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
        let message = Message(content: text)
        // 2
        sendMessage(message)
        // 3
        finishSendingMessage()
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
    }
}
