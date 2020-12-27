//
//  SocialPreview.swift
//  
//
//  Created by Eneko Alonso on 12/26/20.
//

import SwiftUI
//import Stripes

struct SocialPreview: View {
    let brandColor = Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1))
    let textColor = Color.white
    let title: String
    let tags: [String]
    var body: some View {
        ZStack{
//            Stripes(config: StripesConfig(
//                background: brandColor.opacity(1),
//                foreground: Color.white.opacity(0.1),
//                degrees: Double(title.hash % 360),
//                barWidth: 20, barSpacing: 20
//            ))
//            .padding(-80)

            VStack(alignment: .leading, spacing: 30) {
                Spacer()
                VStack(alignment: .leading) {
                    Text("enekoalonso.com")
                        .font(.custom("SF Pro Display", size: 24))
                    Text(title)
                        .font(.custom("SF Pro Display", size: 48))
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
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    Text("Eneko Alonso")
                        .fontWeight(.semibold)
                    Text("—")
                    Text("An Over-Engineered Blog")
                    Spacer()
                    Text("Dec 26 2020")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SocialPreview(title: "Testing Swift packages on Linux from the command line with Docker", tags: ["docker", "linux"])
            .frame(width: 1280, height: 640)
    }
}
