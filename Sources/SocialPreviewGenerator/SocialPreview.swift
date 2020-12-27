//
//  SocialPreview.swift
//  
//
//  Created by Eneko Alonso on 12/26/20.
//

import SwiftUI
import DateTemplates

struct SocialPreview: View {
    let brandColor = Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1))
    let textColor = Color.white
    let dateTemplate = DateTemplate().month(.full).day().year()

    let title: String
    let tags: [String]
    let date: Date
    let issueNumber: Int

    var body: some View {
        ZStack{
            VStack {
                HStack() {
                    Spacer(minLength: 0)
                    Text(binary(title: title))
                        .font(.custom("Monaco", size: 16))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 200)
                }
                Spacer(minLength: 0)
            }
            .padding()
            .opacity(0.1)

            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                VStack(alignment: .leading) {
                    Text("enekoalonso.com")
                        .font(.custom("SF Pro Display", size: 24))
                    Text(title)
                        .font(.custom("SF Pro Display", size: 64))
                        .fontWeight(.bold)
                }
                HStack {
                    ForEach(0..<tags.count) { index in
                        let tag = tags[index]
                        Text(tag)
                            .font(.custom("SF Pro Display", size: 24))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(textColor, lineWidth: 2)
                            )
                    }
                }
                Spacer(minLength: 0)
                HStack(alignment: .firstTextBaseline) {
                    Text("An Over-Engineered Blog")
                        .fontWeight(.semibold)
                    Text("—")
                    Text("Issue #\(issueNumber)")
                    Spacer()
                    Text(dateTemplate.localizedString(from: date))
                        .font(.system(size: 18))
                }
                .font(.custom("SF Pro Display", size: 24))
            }
            .padding(80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(textColor)
        .background(brandColor)
    }

    func binary(title: String) -> String {
        let trimmed = String(title.prefix(60))
        let binary = Data(trimmed.utf8).map { byte in
            String(String(String(byte, radix: 2).reversed()).padding(toLength: 8, withPad: "0", startingAt: 0).reversed())
        }
        return binary.joined(separator: " ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SocialPreview(title: "Testing Swift packages on Linux from the command line with Docker", tags: ["docker", "linux"], date: Date(), issueNumber: 10)
            .frame(width: 1280, height: 640)
    }
}
