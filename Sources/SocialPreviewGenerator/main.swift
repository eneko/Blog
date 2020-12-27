//
//  File.swift
//  
//
//  Created by Eneko Alonso on 12/26/20.
//

#if canImport(SwiftUI)

import AppKit
import SwiftUI
import IssueParser
import struct Logging.Logger

struct SocialPreviewGenerator {
    static func main() throws {
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.count == 2 else {
            fatalError("Missing JSON payload.")
        }
        guard let issue = try? decode(json: arguments[1]) else {
            fatalError("Invalid JSON payload.")
        }
//        if issue.labels.contains(where: { $0.name.lowercased() == "draft" }) {
//            print("Draft label found. Skipping media preview generation.")
//            return
//        }

        let title = issue.title
        let tags = issue.labels.map { $0.name }
        let date = issue.createdAt
        let number = issue.number

        print("Generating Social Preview for issue #\(number)")

        let view = SocialPreview(title: title, tags: tags, date: date, issueNumber: number)
        let wrapper = NSHostingView(rootView: view)
        wrapper.frame = CGRect(x: 0, y: 0, width: 1280, height: 640)

        let png = rasterize(view: wrapper, format: .png)
        try png?.write(to: URL(fileURLWithPath: "issue-\(number).png"))
    }

    static func decode(json: String) throws -> GitHubIssue {
        let parser = IssueParser(logger: Logger(label: "Social Media Preview"))
        return try parser.parseIssue(json: json)
    }

    static func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {
        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        bitmapRepresentation.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)
        return bitmapRepresentation.representation(using: format, properties: [:])
    }
}

try SocialPreviewGenerator.main()

#else
fatalError("SwiftUI not available")
#endif
