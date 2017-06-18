
import Foundation
import TimerCore

let args = Array(CommandLine.arguments.dropFirst())

let store = TimerFileStore(path: "./time.txt")
let timer = TimerLog(store: store)
timer.run(args: args)


