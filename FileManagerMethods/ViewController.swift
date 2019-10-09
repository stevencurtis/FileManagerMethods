//
//  ViewController.swift
//  FileManagerMethods
//
//  Created by Steven Curtis on 08/10/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func removeDirectory (withDirectoryName originName:String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        let path = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = path.first?.appendingPathComponent(originName) {
            do {
                try fileManager.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
    func createDirectory(withFolderName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: directory, in: .userDomainMask)
        if let applicationSupportURL = urls.last {
            do{
                var newURL = applicationSupportURL
                newURL = newURL.appendingPathComponent(dest, isDirectory: true)
                try fileManager.createDirectory(at: newURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print("error \(error)")
            }
        }
    }
    
    func createFile(withData data: Data?, withName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        if let destPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first {
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/")
            if let newFile = fullDestPath.appendingPathComponent(name)?.path {
            if(!fileManager.fileExists(atPath:newFile)){
                fileManager.createFile(atPath: newFile, contents: data, attributes: nil)
            }else{
                print("File is already created, or other error")
            }
            }
        }
    }
    
    func createFileToURL(withData data: Data?, withName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory)  {
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        if let fullDestPath = destPath?.appendingPathComponent(name), let data = data {
            do{
                try data.write(to: fullDestPath, options: .atomic)
            } catch let error {
                print ("error \(error)")
            }
        }
    }
    
    
    func createFileToURL(withData data: Data?, withName name: String, withSubDirectory subdir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory)  {
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        createDirectory(withFolderName: subdir, toDirectory: directory)
        if let fullDestPath = destPath?.appendingPathComponent(subdir + "/" + name), let data = data {
            do{
                try data.write(to: fullDestPath, options: .atomic)
            } catch let error {
                print ("error \(error)")
            }
        }
    }
    
    func removeItem(withItemName originName:String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManger = FileManager.default
        let urls = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = urls.first?.appendingPathComponent(originName) {
            do {
                try fileManger.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
    func removeItem(withItemName originName:String, withSubDirectory dir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManger = FileManager.default
        let urls = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = urls.first?.appendingPathComponent(dir + "/" + originName) {
            do {
                try fileManger.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
    func writeStringToDirectory(string: String, withDestinationFileName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory, withSubDirectory: String = "") {
        if let destPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first {
            createDirectory(withFolderName: withSubDirectory, toDirectory: directory)
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/" + withSubDirectory + "/" + dest)
            do {
                
                try string.write(to: fullDestPath as URL, atomically: true, encoding: .utf8)
            } catch let error {
                print ("error\(error)")
            }
        }
    }
    
    func copyDirect(withOriginName originName:String, withDestinationName destinationName: String) {
        let fileManager = FileManager.default
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let originURL = path.first?.appendingPathComponent(originName) {
            if let destinationURL = path.first?.appendingPathComponent(destinationName) {
                do {
                    try fileManager.copyItem(at: originURL, to: destinationURL)
                }
                catch let error {
                    print ("\(error) error")
                }
            }
        }
    }
    
    func createDataTempFile(withData data: Data?, withFileName name: String) -> URL? {
        if let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileManager = FileManager.default
            var itemReplacementDirectoryURL: URL?
            do {
                try itemReplacementDirectoryURL = fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: destinationURL, create: true)
            } catch let error {
                print ("error \(error)")
            }
            guard let destURL = itemReplacementDirectoryURL else {return nil}
            guard let data = data else {return nil}
            let tempFileURL = destURL.appendingPathComponent(name)
            do {
                try data.write(to: tempFileURL, options: .atomic)
                return tempFileURL
            } catch let error {
                print ("error \(error)")
                return nil
            }
        }
        return nil
    }
    
    func replaceExistingFile(withTempFile fileURL: URL?, existingFileName: String, withSubDirectory: String) {
        guard let fileURL = fileURL else {return}
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        if let fullDestPath = destPath?.appendingPathComponent(withSubDirectory + "/" + existingFileName) {
            
                do {
                    let dta = try Data(contentsOf: fileURL)
                    createDirectory(withFolderName: "\(withSubDirectory)", toDirectory: .applicationSupportDirectory)
                    try dta.write(to: fullDestPath, options: .atomic)
                }
                catch let error {
                    print ("\(error)")
                }
        }
    }
    
    func urlOfFileInDirectory(withFileName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) -> URL? {
        if let destPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first {
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/" + name)
            return fullDestPath as URL
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDirectory(withFolderName: "TestFolder", toDirectory: .applicationSupportDirectory)
        // removeDirectory(withDirectoryName: "TestFolder", toDirectory: .applicationSupportDirectory)

        let dataToWrite = "My Interesting Data".data(using: .utf8)
        // createFile(withData: dataToWrite, withName: "MyFile.txt")
        
        createFileToURL(withData: dataToWrite, withName: "MyFile.txt")
        
        createFileToURL(withData: dataToWrite, withName: "MyFile.txt", withSubDirectory: "test")
        
        removeItem(withItemName: "MyFile.txt")
        
        // removeItem(withItemName: "MyFile.txt", withSubDirectory: "test")
        
        
        let newDataToWrite = "My Boring Data".data(using: .utf8)

        
        let tempFile = createDataTempFile(withData: newDataToWrite, withFileName: "Temp.txt")
        
        
        replaceExistingFile(withTempFile: tempFile, existingFileName: "MyFile.txt", withSubDirectory: "test")
    }


    

}

