//
//  ScreenshotManager.swift
//  KloudFileMacOSNX
//
//  Created by Frederick Lahde on 19/10/2016.
//  Copyright © 2016 Kloudfile. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire


class ScreenshotManager  {
    
    func takeScreenshot() {
        

        let filename = "/.screen.png"
        let url = NSURL.fileURL(withPath: NSHomeDirectory() + filename)
        let task : Process = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", url.path]
        
        let pipe : Pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        
        Swift.print("finished task")
        
        uploadFile(path: url.path, key: getKey())
        
    }
    
    func getKey() -> String {
        let path = "/.key.json"
        let url = NSURL.fileURL(withPath: NSHomeDirectory() + path)
        
        print(url.path)
        do {
            if let jsonData = NSData(contentsOfFile: url.path)
            {
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let key = jsonResult.value(forKey: "key") as! String? {
                    return key;
                }
                
                return ""
                
            }
            
        } catch {
            print("error")
             return ""
        }
        return ""
    }
    
    func uploadFile(path: String, key: String) {
        var parameters = [String: String]()
        parameters["key"] = key

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(NSURL.fileURL(withPath: path), withName: "file")
        }, to: "https://kloudfile.io/api/post",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
  
                    
                    upload.responseJSON { response in
                        if response.response!.statusCode != 200 {
                            return
                        }
                        
                        Swift.print("Image uploaded")
                        let JSON = response.result.value as! NSDictionary
                        let URL = "https://kloudfile.io" + (JSON.value(forKey: "fileViewUrl") as! String)
                        let pasteboard = NSPasteboard.general()
                        pasteboard.clearContents()
                        pasteboard.setString(URL, forType: NSPasteboardTypeString)
  
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}
