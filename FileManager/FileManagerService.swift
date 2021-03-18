//
//  FileManagerService.swift
//  FileManager
//
//  Created by Alexey Golovin on 17.03.2021.
//

import UIKit

enum File {
    case folder
    case file
}

final class FileManagerService {
    func listFiles(in directory: String) -> [(String, File)] {
        var files = [(String, File)]()
        var isDir : ObjCBool = false
        guard let urlPath = getURL(for: directory),
              let directory = try? FileManager.default.contentsOfDirectory(atPath: urlPath.path) else {
                return []
        }
            
        print("\n----------------------------")
        print("LISTING: \(urlPath.path)")
        print("")
        for file in directory {
            if FileManager.default.fileExists(atPath: "\(urlPath.path)/\(file)", isDirectory: &isDir) {
                if isDir.boolValue {
                    files.append((file, .folder))
                } else {
                    files.append((file, .file))
                }
            }
            print("File: \(file.debugDescription)")
        }
        print(files)
        print("")
        print("----------------------------\n")
        return files
    }
    
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func createFile(containing: String, to path: String, withName name: String) {
        let filePath = (getURL(for: path)?.path)! + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }
    
    func createDirectory(to path: String, withName name: String) {
        let filePath = (getURL(for: path)?.path)! + "/" + name
        let _ = try? FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
    }
    
    private func getURL(for directory: String) -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return dir
            
    }
}
