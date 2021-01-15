//
//  PostRendererTests.swift
//
//
//  Created by Eneko Alonso on 1/14/21.
//

import XCTest
@testable import Blog

final class PostRendererTest: XCTestCase {

    func testPermalink() {
        let title = "Dealing with 'camelCase', snake_case, PascalCase, kebab-case and other custom JSON property names in Swift"
        let expectation = "dealing-with-camelcase-snake-case-pascalcase-kebab-case-and-other-custom-json-property-names-in-swift"
        XCTAssertEqual(PostRenderer.permalink(from: title), expectation)
    }
}
