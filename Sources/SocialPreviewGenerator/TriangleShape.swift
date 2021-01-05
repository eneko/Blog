//
//  TriangleShape.swift
//  
//
//  Created by Eneko Alonso on 1/4/21.
//

#if canImport(SwiftUI)

import SwiftUI

/// A Triangle shape, inside a given rect
///
///                  A
///     ┌─────────────────────────┐
///     │                         │
///     │                         │
///    D│                         │B
///     │                         │
///     │                         │
///     └─────────────────────────┘
///                  C
///
struct Triangle: Shape {
    /// Determines which edges of the rectangle the triangle will snap to.
    enum Style: CaseIterable {
        case abc
        case abd
        case acd
        case bcd
    }

    var style: Style
    var p1: CGFloat
    var p2: CGFloat
    var p3: CGFloat

    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height

        let v1, v2, v3: CGPoint
        switch style {
        case .abc:
            v1 = CGPoint(x: p1 * width, y: 0)
            v2 = CGPoint(x: width, y: p2 * height)
            v3 = CGPoint(x: width - p3 * width, y: height)
        case .abd:
            v1 = CGPoint(x: p1 * width, y: 0)
            v2 = CGPoint(x: width, y: p2 * height)
            v3 = CGPoint(x: 0, y: height - p3 * height)
        case .acd:
            v1 = CGPoint(x: p1 * width, y: 0)
            v2 = CGPoint(x: width - p2 * width, y: height)
            v3 = CGPoint(x: 0, y: height - p3 * height)
        case .bcd:
            v1 = CGPoint(x: width, y: p1 * height)
            v2 = CGPoint(x: width - p2 * width, y: height)
            v3 = CGPoint(x: 0, y: height - p3 * height)
        }

        var path = Path()
        path.move(to: v1)
        path.addLine(to: v2)
        path.addLine(to: v3)
        path.closeSubpath()
        return path
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle(style: .abc, p1: 0.5, p2: 0.5, p3: 0.5)
            .opacity(0.1)
            .background(Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1)))
            .foregroundColor(.white)
            .frame(width: 1280, height: 640)

        Triangle(style: .bcd, p1: 0.1, p2: 0.1, p3: 0.1)
            .opacity(0.1)
            .background(Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1)))
            .foregroundColor(.white)
            .frame(width: 1280, height: 640)
    }
}

#endif
