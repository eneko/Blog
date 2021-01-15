//
//  PostRenderer.swift
//  
//
//  Created by Eneko Alonso on 12/22/20.
//

import Foundation
import IssueParser

public struct PostRenderer {

    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles") // for region us-west-2
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    let issue: GitHubIssue

    public init(issue: GitHubIssue) {
        self.issue = issue
    }

    public var filename: String {
        let date = Self.formatter.string(from: issue.createdAt)
        return "_posts/\(date)-issue-\(issue.number).md"
    }

    public func render() -> String {
        let labels = issue.labels.map { $0.name }
        let tags = labels.joined(separator: ", ")
        let body = issue.body.replacingOccurrences(of: "\r\n", with: "\n")
        let permalink = Self.permalink(from: issue.title)

        let post = """
            ---
            layout: post
            title: \(issue.title)
            permalink: /articles/\(permalink)
            image: https://eneko-blog-media.s3-us-west-2.amazonaws.com/social-preview/issue-\(issue.number).png
            date: \(Self.formatter.string(from: issue.closedAt ?? issue.createdAt))
            keywords: \(tags)
            tags: [\(tags)]
            issue: \(issue.number)
            redirect_from:
              - /articles/issue-\(issue.number)
            ---

            \(body)

            ---

            <div class="post-closure">
                <p>This article was written as an issue on my Blog repository on GitHub (see <a target="_blank" href="https://github.com/eneko/Blog/issues/\(issue.number)">Issue #\(issue.number)</a>)</p>
                <p>First draft: \(Self.formatter.string(from: issue.createdAt))</p>
                <p>Published on: \(Self.formatter.string(from: issue.closedAt ?? issue.createdAt))</p>
                <p>Last update: \(Self.formatter.string(from: issue.updatedAt))</p>
            </div>
            """
        return post
    }

    static func permalink(from title: String) -> String {
        let alphanumerics = CharacterSet.alphanumerics
        var last = ""
        return title.unicodeScalars.map { scalar in
            if alphanumerics.contains(scalar) {
                last = String(scalar).lowercased()
            } else if last == "-" {
                return "" // prevent consecutive dashes
            } else {
                last = "-"
            }
            return last
        }.joined()
    }
}
