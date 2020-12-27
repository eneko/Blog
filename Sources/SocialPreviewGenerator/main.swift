//
//  File.swift
//  
//
//  Created by Eneko Alonso on 12/26/20.
//

#if canImport(SwiftUI)

import AppKit
import SwiftUI

struct SocialPreviewGenerator {
    static func main() throws {
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.count == 3 else {
            print("Missing arguments.")
            return
        }
        let title = arguments[1]
        let tags = ["docker", "linux", "swift"]
        let date = Date()
        let issueNumber = Int(arguments[2]) ?? 0

        print("Generating Social Preview for issue #")

        let view = SocialPreview(title: title, tags: tags, date: date, issueNumber: issueNumber)
        let wrapper = NSHostingView(rootView: view)
        wrapper.frame = CGRect(x: 0, y: 0, width: 1280, height: 640)

        let png = rasterize(view: wrapper, format: .png)
        try png?.write(to: URL(fileURLWithPath: "issue-\(issueNumber).png"))
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
