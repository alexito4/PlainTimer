//
//  TimerCoreTests.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import XCTest
import TimerCore

class TimerCoreTests: XCTestCase {
    
    var clock: DynamicTimerClock!
    var store: TimerFileStore!
    let manager = FileManager.default
    
    override func setUp() {
        super.setUp()
        
        clock = DynamicTimerClock()
        store = TimerFileStore.temp()
    }
    
    override func tearDown() {
        clock = nil
        try? FileManager.default.removeItem(atPath: store.filePath)
        store = nil
        
        super.tearDown()
    }
    
    func testFileCreation() {
        let path = store.filePath
        
        XCTAssertFalse(manager.fileExists(atPath: path))
        
        let log = TimerLog(store: store, clock: clock)
        
        XCTAssertFalse(manager.fileExists(atPath: path))
        
        let command = Command.log("1h", "test")
        log.run(command)
        
        XCTAssertTrue(manager.fileExists(atPath: path))
    }
    
    func testTrimFile() {        
        let text = """

        2017/02/26 1h Started the project
        2017/02/26 30m Log and Show
        2017/06/17 30m Refactor into Command type


        """
        
        try! text.write(toFile: store.filePath, atomically: true, encoding: .utf32)
        
        let corrected = """
        2017/02/26 1h Started the project
        2017/02/26 30m Log and Show
        2017/06/17 30m Refactor into Command type

        """
        
        XCTAssertEqual(corrected, store.contents())
    }
    
}
