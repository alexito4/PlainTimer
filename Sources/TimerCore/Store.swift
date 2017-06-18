//
//  Store.swift
//  TimerCoreTests
//
//  Created by Alejandro Martinez on 17/06/2017.
//

import Foundation

public class TimerFileStore: TimerStore {
    
    let manager: FileManager = FileManager.default
    
    public let filePath: String
    
    public init(path: String) {
        self.filePath = path
    }
    
    public func ensureExistence() -> Bool {
        
        guard manager.fileExists(atPath: filePath) == false else {
            return true
        }
        
        print("time.txt not found in \(manager.currentDirectoryPath)")
        print("Creating time.txt...")
        
        guard manager.createFile(atPath: filePath, contents: nil, attributes: nil) else {
            print("Some error happened while creating the file.")
            return false
        }
        
        print("time.txt created!")
        
        return true
    }
    
    public func contents() -> String {
        var content = (try? String(contentsOfFile: filePath, encoding: .utf32)) ?? ""
        
        content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if content.isEmpty == false {
            content.append("\n")
        }
        
        return content
    }
    
    private func lines() -> Array<String> {
        return contents().split(separator: "\n").map(String.init)
    }
    
    private func save(contents: String) {
        try! contents.write(toFile: filePath, atomically: true, encoding: .utf32)
    }
    
    public func lastEntry() -> String {
        return String(lines().last ?? "")
    }
    
    public func replaceLastEntry(with text: String) {
        var original = lines()
        original.removeLast()
        original.append(text)
        let modified = original.joined(separator: "\n")
        save(contents: modified)
    }
    
    public func append(_ text: String) {
        var c = contents()
        c.append(text)
        save(contents: c)
        
        // This messes around with encoding adding \u{FEFF} sometimes
//        guard let file = FileHandle(forWritingAtPath: filePath) else {
//            print("FILE NOT FOUND")
//            exit(EXIT_FAILURE)
//        }
//        file.seekToEndOfFile()
//
//        guard let data = text.data(using: .utf32) else {
//            print("CAN'T CONVERT STRING TO DATA")
//            exit(EXIT_FAILURE)
//        }
//        file.write(data)
    }
    
    
}
