//
//  String+.swift
//  App
//
//  Created by AnLuoRidge on 25/5/19.
//

import Foundation

extension String {
    func sha1Hash()->String {
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        inputPipe.fileHandleForWriting.write(self.data(using: .utf8)!)
        inputPipe.fileHandleForWriting.closeFile()
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: .utf8)!
        return hash.replacingOccurrences(of: "  -\n", with: "")
    }
}
