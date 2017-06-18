//
//  TimerFileStoreTests.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import XCTest
@testable import TimerCore

class TimerFileStoreTests: XCTestCase {
    
    let manager = FileManager.default
    var store: TimerFileStore!
    var path: String!
    
    override func setUp() {
        super.setUp()
        
        store = TimerFileStore.temp()
        path = store.filePath
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(atPath: store.filePath)
        store = nil
        path = nil
        
        super.tearDown()
    }

    func testEnsureExistence() {
        XCTAssertFalse(manager.fileExists(atPath: path))
        
        XCTAssertTrue(store.ensureExistence())
        
        XCTAssertTrue(manager.fileExists(atPath: path))
        
        XCTAssertTrue(store.ensureExistence())
    }
    
    func testContents() {
        let text = """
        2017/02/26 1h Started the project
        2017/02/26 30m Log and Show
        2017/06/17 30m Refactor into Command type

        """
        
        try! text.write(toFile: path, atomically: true, encoding: .utf32)
        
        XCTAssertEqual(text, store.contents())
    }
    
    func testLastEntry() {
        let text = """
        2017/02/26 1h Started the project
        2017/02/26 30m Log and Show
        2017/06/17 30m Refactor into Command type

        """
        
        try! text.write(toFile: path, atomically: true, encoding: .utf32)
        
        XCTAssertEqual("2017/06/17 30m Refactor into Command type", store.lastEntry())
    }
    
    func testReplaceLastEntry() {
        let text = """
        2017/02/26 1h Started the project
        2017/02/26 30m Log and Show
        2017/06/17 30m Refactor into Command type

        """
        
        try! text.write(toFile: path, atomically: true, encoding: .utf32)
        
        store.replaceLastEntry(with: "replaced")
        
        XCTAssertEqual("replaced", store.lastEntry())
    }

}
