//
//  ColorParserTests.swift
//  
//
//  Created by Eneko Alonso on 1/3/21.
//

import XCTest
import IssueParser

final class ColorParserTests: XCTestCase {

    func testByte() {
        let parser = ColorParser()
        XCTAssertEqual(parser.byte(from: "00"), 0)
        XCTAssertEqual(parser.byte(from: "0F"), 15)
        XCTAssertEqual(parser.byte(from: "7F"), 127)
        XCTAssertEqual(parser.byte(from: "FF"), 255)
    }

    func testColor() {
        let parser = ColorParser()

//        XCTAssertEqual(NSColor(parser.parse(color: "000000")).cgColor, NSColor(.black).cgColor)
//        XCTAssertEqual(parser.parse(color: "FF0000"), .red)
//        print(Color.black.description)
//        print(parser.parse(color: "000000").description)
    }

}
