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
            fatalError("Missing JSON payload filename.")
        }
        let json = try String(contentsOfFile: arguments[1])
        let issue = try decode(json: json)
        if issue.labels.contains(where: { $0.name.lowercased() == "draft" }) {
            fatalError("Draft label found. Skipping media preview generation.")
        }

        let title = issue.title
        let tags = issue.labels.map { $0.name }
        let date = issue.createdAt
        let number = issue.number

        print("Generating Social Preview for issue #\(number)")

        let (background, foreground) = colors(from: issue)
        let view = SocialPreview(
            backgroundColor: background,
            foregroundColor: foreground,
            title: title,
            tags: tags,
            date: date,
            issueNumber: number
        )
        let wrapper = NSHostingView(rootView: view)
        wrapper.frame = CGRect(x: 0, y: 0, width: 1280, height: 640)

        let png = rasterize(view: wrapper, format: .png)
        try png?.write(to: URL(fileURLWithPath: "issue-\(number).png"))
    }

    static func decode(json: String) throws -> GitHubIssue {
        let parser = IssueParser(logger: Logger(label: "Social Media Preview"))
        return try parser.parseIssue(json: json)
    }

    /// Select colors for social media preview based on labels. Labels are prioritized as ordered below (from less common to more common).
    static func colors(from issue: GitHubIssue) -> (background: Color, foreground: Color) {
        let customLabels = [
            "Challenge",
            "Command Line",
            "SwiftUI",
            "AWS",
            "Linux",
            "GitHub Actions",
            "Tips",
            "Xcode",
            "Swift"
        ]
        for name in customLabels {
            if let label = issue.labels.first(where: { $0.name == name }) {
                return (background: ColorParser().parse(color: label.color), foreground: .white)
            }
        }
        return (background: Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1)), foreground: .white)
    }

    static func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {
//        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
//        NSGraphicsContext.current?.imageInterpolation = .high
        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
//        bitmapRepresentation.colorSpace = NSColorSpace.deviceRGB
        bitmapRepresentation.size = view.bounds.size
//        bitmapRepresentation.scale
        dump(bitmapRepresentation)
        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)
        dump(bitmapRepresentation)
        return bitmapRepresentation.representation(using: format, properties: [:])
    }
}

try SocialPreviewGenerator.main()

#else
fatalError("SwiftUI not available")
#endif
