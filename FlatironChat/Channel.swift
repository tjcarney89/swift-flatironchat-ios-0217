//
//  Channel.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation

struct Channel {
    var name: String
    var lastMsg: String?
    var numberOfParticipants: Int
    
    init(name: String, parameters: Any) {
        self.name = name
    
        if let safeParameters = parameters as? [String: Any]  {
            self.lastMsg = safeParameters["lastMessage"] as? String ?? ""
            
            let participants = safeParameters["participants"] as? [String: Any] ?? [:]
            
            
            self.numberOfParticipants = participants.keys.count
        } else {
            self.numberOfParticipants = 0
            self.lastMsg = "No Message"
        }
        
        
     }
}

extension Channel: CustomStringConvertible {
    var description: String {
        return "Name is \(self.name), last message is \(self.lastMsg)"
    }
}
