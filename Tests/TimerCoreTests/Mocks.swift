//
//  Mocks.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import Foundation
import TimerCore

extension TimerFileStore {
    
    static func temp() -> TimerFileStore {
        let path = URL(string: NSTemporaryDirectory())!.appendingPathComponent("temp_time\(Date().timeIntervalSince1970).txt").absoluteString
        print("Test file: \(path)")
        let store = TimerFileStore(path: path)
        return store
    }
    
}

class FixTimerClock: TimerClock {
    
    let currentDate: Date
    
    init(date: Date) {
        self.currentDate = date
    }
    
}

final class DynamicTimerClock: TimerClock {
    
    var dateComponents = DateComponents(year: 2017, month: 2, day: 1, hour: 2, minute: 2, second: 2)
    
    var currentDate: Date {
        return Calendar.current.date(from: self.dateComponents)!
    }
    
}
