//
//  File.swift
//  
//
//  Created by Eneko Alonso on 1/3/21.
//

import SwiftUI

public struct ColorParser {

    public init() {}

    public func parse(color: String) -> Color {
        guard color.count == 6 else {
            fatalError("Expected 6 characters, got \(color.count)")
        }
        let red = Double(byte(from: color.dropLast(4))) / 255
        let green = Double(byte(from: color.dropFirst(2).dropLast(2))) / 255
        let blue = Double(byte(from: color.dropFirst(4))) / 255
        return Color(Color.RGBColorSpace.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }

    public func byte(from hex: Substring) -> UInt8 {
        return UInt8(hex, radix: 16) ?? 0
    }

}
