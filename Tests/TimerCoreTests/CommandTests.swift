//
//  CommandTests.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import XCTest
import TimerCore

class CommandTests: XCTestCase {
    
    func testCommandInits() {
        var command: Command
        
        command = Command(arguments: ["nothing"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["help"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["show"])
        XCTAssert(command == .show)
        
        command = Command(arguments: ["log"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["log", "1h"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["log", "1h", "some note"])
        XCTAssert(command == .log("1h", "some note"))
        
        command = Command(arguments: ["log", "1h", "some note", "bu"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["start"])
        XCTAssert(command == .start)
        
        command = Command(arguments: ["end"])
        XCTAssert(command == .help)
        
        command = Command(arguments: ["end", "some note"])
        XCTAssert(command == .end("some note"))
        
        command = Command(arguments: ["end", "some note", "nope"])
        XCTAssert(command == .help)
    }
    
}
