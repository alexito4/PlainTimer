//
//  LogTests.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import XCTest
import TimerCore

class LogTests: XCTestCase {
    
    var clock: DynamicTimerClock!
    var store: TimerFileStore!
    
    override func setUp() {
        super.setUp()
        
        clock = DynamicTimerClock()
        store = TimerFileStore.temp()
    }
    
    override func tearDown() {
        clock = nil
        try! FileManager.default.removeItem(atPath: store.filePath)
        store = nil
        
        super.tearDown()
    }
    
    func testLog() {
        let log = TimerLog(store: store, clock: clock)
        
        // Starts empty
        XCTAssertEqual(store.contents(), "")
        
        log.run(Command.log("1h", "test"))
        
        // Has 1 entry
        XCTAssertEqual(store.contents(), "2017/02/01 1h test\n")
        
        log.run(Command.log("2h", "more"))
        
        // Has 2 entries
        XCTAssertEqual(store.contents(), "2017/02/01 1h test\n2017/02/01 2h more\n")
    }
    
    func testLogStartEndInteraction() {
        let log = TimerLog(store: store, clock: clock)
        
        // Starts with 1 entry
        log.run(Command.log("1h", "first"))
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n")
        
        // Can't end a session when is not started
        log.run(Command.end("end"))
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n")
        
        // Starts a session
        log.run(Command.start)
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n--1485914522\n")
        
        // Can't log when a session is started
        log.run(Command.log("1h", "nope"))
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n--1485914522\n")
        
        // Can't start another session
        log.run(Command.start)
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n--1485914522\n")
        
        // 2h pass...
        clock.dateComponents.hour! += 2
        
        // End session adds new entry
        log.run(Command.end("end"))
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n2017/02/01 2h end\n")
        
        // Log adds new entry
        log.run(Command.log("1h", "third"))
        XCTAssertEqual(store.contents(), "2017/02/01 1h first\n2017/02/01 2h end\n2017/02/01 1h third\n")
    }

}
