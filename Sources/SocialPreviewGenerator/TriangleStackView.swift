//
//  TriangleStackView.swift
//  
//
//  Created by Eneko Alonso on 1/4/21.
//

#if canImport(SwiftUI)

import SwiftUI

struct TriangleStack: View {
    let text: String
    let styles = Triangle.Style.allCases
    var body: some View {
        ZStack {
            ForEach(0..<text.count) { index in
                triangle(for: index)
            }
        }
//        .drawingGroup()
    }

    func triangle(for index: Int) -> some View {
        let character = Array(text)[index]
        let ascii = Int(character.asciiValue ?? 0)
        let style = styles[ascii % styles.count]
        let p1 = CGFloat((1 + index) * ascii % 99) / 99
        let p2 = CGFloat((1 + index) * ascii % 31) / 31
        let p3 = CGFloat((1 + index) * ascii % 13) / 13
//        print(character, ascii, style, p1, p2, p3)
        return Triangle(style: style, p1: p1, p2: p2, p3: p3)
            .opacity(0.5 / Double(text.count))
    }
}

struct TriangleStack_Previews: PreviewProvider {
    static var previews: some View {
        TriangleStack(text: "Hello, World!")
            .background(Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1)))
            .foregroundColor(.white)
            .frame(width: 1280, height: 640)
    }
}

#endif
