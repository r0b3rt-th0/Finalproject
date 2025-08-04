//
//  DatabaseUser.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import Foundation

struct DatabaseUser: Codable {
    
    let userID: String?
    let username: String?
    let email: String?
    let dateCreated: Date
    
}

extension DateFormatter {
    static let userFriendlyDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}













