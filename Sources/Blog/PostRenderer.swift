//
//  PostRenderer.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation

public struct PostRenderer {

    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()

    public init() {}

    public func render(issue: GitHubIssue) -> String {
        let labels = issue.labels.map { $0.name.replacingOccurrences(of: " ", with: "-") }
        let tags = labels.joined(separator: " ")
        let keywords = labels.joined(separator: ", ")
        let post = """
                  ---
                  layout: post
                  title: \(issue.title)
                  permalink: /articles/:title
                  date: \(Self.formatter.string(from: issue.createdAt))
                  keywords: \(keywords)
                  tags: \(tags)
                  ---

                  <span class="issue-number"><b>Issue <a target="_blank" href="https://github.com/eneko/Blog/issues/\(issue.number)">#\(issue.number)</a></b></span>

                  \(issue.body)

                  ---

                  <i><small>This article was written as an issue on my Blog repository on GitHub (see <a target="_blank" href="https://github.com/eneko/Blog/issues/\(issue.number)">Issue #\(issue.number)</a>)</small></i>
                  """
        return post
    }
}
