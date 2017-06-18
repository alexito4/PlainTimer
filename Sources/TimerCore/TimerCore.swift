
import Foundation

public protocol TimerStore {
    func ensureExistence() -> Bool
    
    func contents() -> String
    
    func lastEntry() -> String
    func replaceLastEntry(with text: String)
    func append(_ text: String)
}

extension TimerStore {
    func sessionIsOpen() -> Bool {
        print("Last entry")
        print(lastEntry())
        print("Starts with \(TimerLog.SESSION_TOKEN)?")
        print(lastEntry().starts(with: TimerLog.SESSION_TOKEN))
        return lastEntry().starts(with: TimerLog.SESSION_TOKEN)
    }
}

public protocol TimerClock {
    var currentDate: Date { get }
}

public final class TimerLog {
    
    let store: TimerStore
    let clock: TimerClock
    
    fileprivate static let SESSION_TOKEN = "--"
    
    public init(
        store: TimerStore,
        clock: TimerClock = TimerSystemClock()
    ) {
        self.store = store
        self.clock = clock
    }
    
    public func run(args: Array<String>) {
        let command = Command(arguments: Array(args))
        run(command)
    }
    
    public func run(_ command: Command) {
        guard store.ensureExistence() else {
            return
        }
        
        switch command {
        case let .log(time, description):
            runLog(time: time, note: description)
        case .start:
            runStart()
        case let .end(description):
            runEnd(note: description)
        case .show:
            runShow()
        case .help:
            runHelp()
        }
    }
    
    private func formatLog(date: Date, duration components: DateComponents, note: String) -> String {
        
        var dur = ""
        if let hours = components.hour, hours > 0 {
            dur += "\(hours)h"
        }
        if let mins = components.minute, mins > 0 {
            dur += "\(mins)m"
        }
        
        return formatLog(date: date, duration: dur, note: note)
    }
    
    private func formatLog(date: Date, duration: String, note: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: date)
        
        return "\(dateString) \(duration) \(note)\n"
    }
    
    private func runLog(time: String, note: String) {
        guard store.sessionIsOpen() == false else {
            return
        }
        
        let log = formatLog(
            date: clock.currentDate,
            duration: time,
            note: note
        )
        
        store.append(log)
        
        print("New log:")
        print(log)
    }
    
    private func runStart() {
        guard store.sessionIsOpen() == false else {
            return
        }
        
        let now = clock.currentDate
        
        let mark = "\(TimerLog.SESSION_TOKEN)\(Int(now.timeIntervalSince1970))"
        
        store.append(mark)
        
        print("Started session.")
    }
    
    private func runEnd(note: String) {
        let now = clock.currentDate
        
        guard store.sessionIsOpen() else {
            return
        }
        
        let lastEntry = store.lastEntry()
        
        let two = lastEntry.index(lastEntry.startIndex, offsetBy: 2)
        let startTimestampString = String(lastEntry.suffix(from: two))
        let startTimestamp = TimeInterval(startTimestampString)!
        let start = Date(timeIntervalSince1970: startTimestamp)
        let duration = Calendar.current.dateComponents([.hour, .minute], from: start, to: now)
        
        let log = formatLog(
            date: now,
            duration: duration,
            note: note
        )
        
        store.replaceLastEntry(with: log)
        
        print("Session finished:")
        print(log)
    }
    
    private func runShow() {
        let file = store.contents()
        print(file)
    }
    
    private func runHelp() {
        print("Usage:")
        Command.all.forEach({ print("   \($0.help)") })
    }
}

