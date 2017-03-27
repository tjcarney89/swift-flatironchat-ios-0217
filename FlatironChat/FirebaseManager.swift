//
//  FirebaseManager.swift
//  FlatironChat
//
//  Created by Benjamin Bernstein on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import JSQMessagesViewController

final class FireBaseManager {
    
    static let user = UserDefaults.standard.string(forKey: "screenName")
    
    class func addUser(name: String) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            FIRDatabase.database().reference().child("users").child(name).child("channels").setValue(false)
        })
    }
    
    class func fetchChannels(completion: @escaping ([Channel]) -> Void ) {
        var channels = [Channel]()
        FIRDatabase.database().reference().child("channels").observe(.value, with: { (snapshot) in
            let channelDictionary = snapshot.value as? [String: Any] ?? [ : ]
            channels.removeAll()
                for singleDict in channelDictionary {
                    let name = singleDict.key
                    let parameters = singleDict.value
                    let newChannel = Channel(name: singleDict.key, parameters: parameters)
                    channels.append(newChannel)
                }
                completion(channels)
        })
    }
    
    class func createChannel(name: String) {
        FIRDatabase.database().reference().child("channels").child(name).setValue(true)
    }
    
    class func addMessage(content: String, sender: String, channel: String, date: String, completion: () -> () ) {
        FIRDatabase.database().reference().child("messages").child(channel).childByAutoId().setValue(["content": content, "from": sender, "date": date])
        FIRDatabase.database().reference().child("channels").child(channel).child("lastMessage").setValue(content)

        completion()
        
    }
    
    class func addParticipant(name: String, channel: String) {
        FIRDatabase.database().reference().child("channels").child(channel).child("participants").child(name).setValue(true)
        FIRDatabase.database().reference().child("users").child(name).child("channels").child(channel).setValue(true)
    }
    
    class func loadMessages(channel: String, completion: @escaping ([JSQMessage]) -> Void ) {
        
        FIRDatabase.database().reference().child("messages").child(channel).observe(.value, with: { (snapshot) in
            let channelDictionary = snapshot.value as? [String: Any] ?? [ : ]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'@'hh:mm:ss"
            var messages = [JSQMessage]()
            for singleDict in channelDictionary {
                let senderID = singleDict.key
                let values = singleDict.value as? [String : Any] ?? [:]
                let displayName = values["from"] as? String ?? ""
                let text = values["content"] as? String ?? ""
                let date = values["date"] as? String ?? ""
                let newDate = dateFormatter.date(from: date)
                let message = JSQMessage(senderId: senderID, senderDisplayName: displayName, date: newDate, text: text)
                //let message = JSQMessage(senderId: senderID, displayName: displayName, text: text)
                print(message)
                print(message?.date)
                if let newMessage = message {
                    messages.append(newMessage)
                }
                
            }

            completion(messages)

        })
        
    }
    
    
    
    class func observeMessages(channel: String, completion: @escaping ([String: Any]) -> ()) {
       
        FIRDatabase.database().reference().child("messages").child(channel).observe(.childAdded, with: { (snapshot) in
            let messageDict = snapshot.value as? [String:Any] ?? [:]
            completion(messageDict)
        })
        
    }
    
    
}
