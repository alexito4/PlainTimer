
import Foundation

let path = "./time.txt"
func checkFile() -> Bool {
    
    guard FileManager.default.fileExists(atPath: path) == false else {
        return true
    }
    
    print("time.txt not found in \(FileManager.default.currentDirectoryPath)")
    print("Creating time.txt...")
    
    guard FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) else {
        print("Some error happened while creating the file.")
        return false
    }
    
    print("time.txt created!")
    
    return true
}

func runHelp() {
    print("Usage:")
    print(" log 1h \"Description of the task.\"")
}

func runLog(arguments: [String]) {
    guard arguments.count == 2 else {
        runHelp()
        exit(EXIT_FAILURE)
    }
    
    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let date = formatter.string(from: now)
    
    let time = arguments[0]
    let note = arguments[1]
    
    let log = "\(date) \(time) \(note)\n"
    
    guard let file = FileHandle(forWritingAtPath: path) else {
        print("FILE NOT FOUND")
        exit(EXIT_FAILURE)
    }
    file.seekToEndOfFile()
    
    guard let data = log.data(using: .utf32) else {
        print("CAN'T CONVERT STRING TO DATA")
        exit(EXIT_FAILURE)
    }
    file.write(data)
    
    print("New log:")
    print(log)
}

func runShow() {
    let file = try! String(contentsOfFile: path)
    print(file)
}

guard checkFile() else {
    exit(EXIT_FAILURE)
}

let args = CommandLine.arguments.dropFirst()

guard let command = args.first else {
    runHelp()
    exit(EXIT_FAILURE)
}

switch command {
case "log":
    let logArgs = Array(args.dropFirst())
    runLog(arguments: logArgs)
case "show":
    runShow()
default:
    runHelp()
}
