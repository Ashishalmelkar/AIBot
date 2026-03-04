//
//  converstionHistory.swift
//  Fluffbotics
//
//  Created by Equipp on 16/12/25.
//

import Foundation

enum Sender {
    case user
    case bot
}

struct Message {
    let text: String
    let sender: Sender
    var isExpanded: Bool = false
    
    var shouldShowMore: Bool {
        return text.count > 300
    }
}
