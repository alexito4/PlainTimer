
import Foundation

enum Command {
    case log(String, String)
    case show
    case help
    
    var word: String {
        switch self {
        case .log:
            return "log"
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
        case .show:
            return "show"
        case .help:
            return "help"
        }
    }
    
    static var all: Array<Command> {
        return [
            .log("", ""),
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
            
        case Command.show.word:
            self = .show
        default:
            self = .help
        }
    }
    
    init(arguments: Array<String>) {
        guard let first = arguments.first else {
            self.init()
            return
        }
        
        self.init(rawValue: first, params: Array(arguments.dropFirst()))
    }
    
    func run() {
        switch self {
        case let .log(time, description):
            runLog(time: time, note: description)
        case .show:
            runShow()
        case .help:
            runHelp()
        }
    }
    
    private func runLog(time: String, note: String) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: now)
        
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
    
    private func runShow() {
        let file = try! String(contentsOfFile: path)
        print(file)
    }
    
    private func runHelp() {
        print("Usage:")
        Command.all.forEach({ print("   \($0.help)") })
    }
}

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

guard checkFile() else {
    exit(EXIT_FAILURE)
}

let args = CommandLine.arguments.dropFirst()


let command = Command(arguments: Array(args))
command.run()

