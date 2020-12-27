//
//  File.swift
//  
//
//  Created by Eneko Alonso on 12/26/20.
//

import AppKit
import SwiftUI

struct SocialPreviewGenerator {
    static func main() throws {
        print("Generating Social Preview for issue #")

        let view = SocialPreview(
            title: "Testing Swift packages on Linux from the command line with Docker",
            tags: ["docker", "linux", "swift"]
        )
        let wrapper = NSHostingView(rootView: view)
        wrapper.frame = CGRect(x: 0, y: 0, width: 1280, height: 640)

        let png = rasterize(view: wrapper, format: .png)
        try png?.write(to: URL(fileURLWithPath: "test.png"))
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
