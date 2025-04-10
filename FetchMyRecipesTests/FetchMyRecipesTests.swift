//
//  FetchMyRecipesTests.swift
//  FetchMyRecipesTests
//
//  Created by Melissa Webster on 4/4/25.
//

import XCTest
@testable import FetchMyRecipes

final class FetchMyRecipesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecipeDecodingFromMockJSON() throws {
        let mockJSON = """
        {
            "recipes": [
                {
                    "cuisine": "Thai",
                    "name": "Pad Thai",
                    "photo_url_large": "https://example.com/padthai.jpg",
                    "photo_url_small": "https://example.com/padthai_small.jpg",
                    "uuid": "EAAF48DC-A3F6-4D97-92ED-B878B32EB508",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com/example"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoded = try JSONDecoder().decode(RecipesResponse.self, from: mockJSON)
        
        guard let recipes = decoded.recipes else {
            XCTFail("Expected recipes array, but got nil.")
            return
        }
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes[0].name, "Pad Thai")
        XCTAssertEqual(recipes[0].cuisine, "Thai")
    }
    
    func testDecodingFailsWithMailformedJSON() {
        let malformedJSON = """
            {
                "recipes": [
                    {
                        "cuisine": "Thai",
                        "name": 123,
                        "photo_url_large": "https://example.com/padthai.jpg",
                        "photo_url_small": "https://example.com/padthai_small.jpg",
                        "uuid": "EAAF48DC-A3F6-4D97-92ED-B878B32EB508",
                        "source_url": "https://example.com",
                        "youtube_url": "https://youtube.com/example"
                    }
                ]
            }
            """.data(using: .utf8)!
        
        XCTAssertThrowsError(
            try JSONDecoder().decode(RecipesResponse.self, from: malformedJSON), "Decoding should fail when name is not String"
        )
    }
    
    func testDecodingEmptyRecipesJSON() throws {
        let emptyJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(RecipesResponse.self, from: emptyJSON)

        XCTAssertNotNil(decoded.recipes, "Recipes array should not be nil")
        XCTAssertEqual(decoded.recipes?.count, 0, "Recipes array should be empty")
    }
    
    func testDecodingYieldsNilWhenRecipesKeyIsMissing() throws {
        let missingKeyJSON = """
        {
            "status": "ok"
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(RecipesResponse.self, from: missingKeyJSON)
        XCTAssertNil(decoded.recipes, "Expected recipes to be nil when key is missing")
    }
    
    func makeTestImage() -> UIImage {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func testMemoryCacheStoresAndRetrievesImage() {
        let testImage = makeTestImage()
        let key = "memory-test-key"
        
        ImageCacheManager.shared.cacheImage(image: testImage, for: key)
        
        let expectation = XCTestExpectation(description: "Load from memory cache")
        
        ImageCacheManager.shared.getCachedImage(for: key) { result in
            XCTAssertNotNil(result, "Image should be returned from memory cache")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testDiskCacheStoresAndRetrievesImage() {
        let testImage = makeTestImage()
        let key = "disk-test-key"
        
        ImageCacheManager.shared.cacheImage(image: testImage, for: key)
        
        let memoryCache = Mirror(reflecting: ImageCacheManager.shared).children
            .first(where: { $0.label == "memoryCache" })?.value as? NSCache<NSString, UIImage>
        memoryCache?.removeAllObjects()
        
        let expectation = XCTestExpectation(description: "Load from disk cache")
        
        ImageCacheManager.shared.getCachedImage(for: key) { result in
            XCTAssertNotNil(result, "Image should be loaded from disk cache")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6.0) //extended timeout because want the fun animation to show longer
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
