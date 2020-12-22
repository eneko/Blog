//
//  GitHubIssue.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation

public struct GitHubContext: Codable {
    public let eventName: String
    public let event: GitHubEvent
}

public struct GitHubEvent: Codable {
    public let action: String
    public let issue: GitHubIssue
}

public struct GitHubIssue: Codable {
    public let number: Int
    public let state: String
    public let body: String
    public let title: String
    public let labels: [GitHubLabel]
    public let createdAt: Date
    public let updatedAt: Date
}

public struct GitHubLabel: Codable {
    public let color: String
    public let name: String
}
