//
//  Command.swift
//  TimerCore
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import Foundation

public enum Command: Equatable {
    case log(String, String)
    case start
    case end(String)
    case show
    case help
    
    var word: String {
        switch self {
        case .log:
            return "log"
        case .start:
            return "start"
        case .end:
            return "end"
        case .show:
            return "show"
        case .help:
            return "help"
        }
    }
    
    var help: String {
        switch self {
        case .log:
            return "log 1h \"Description of the task.\""
        case .start:
            return "start"
        case .end:
            return "end \"Description of the task.\""
        case .show:
            return "show"
        case .help:
            return "help"
        }
    }
    
    static var all: Array<Command> {
        return [
            .log("", ""),
            .start,
            .end(""),
            .show,
            .help
        ]
    }
    
    init(){
        self = .help
    }
    
    init(rawValue: String, params: Array<String>) {
        switch rawValue {
        case Command.log("", "").word:
            
            guard params.count == 2 else {
                self = .help
                return
            }
            
            self = .log(params[0], params[1])
        case Command.start.word:
            self = .start
        case Command.end("").word:
            guard params.count == 1 else {
                self = .help
                return
            }
            
            self = .end(params[0])
        case Command.show.word:
            self = .show
        default:
            self = .help
        }
    }
    
    public init(arguments: Array<String>) {
        guard let first = arguments.first else {
            self.init()
            return
        }
        
        self.init(rawValue: first, params: Array(arguments.dropFirst()))
    }
    
    public static func ==(lhs: Command, rhs: Command) -> Bool {
        switch (lhs, rhs) {
        case let (.log(time, note), .log(oTime, oNote)):
            return time == oTime && note == oNote
        case (.show, .show), (.help, .help), (.start, .start), (.end, .end):
            return true
        default:
            return false
        }
    }
}
