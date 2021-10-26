//
//  APIs.swift
//M-commerce 
//
//  Created by macbook pro on 19/06/18.
//  Copyright © 2018 Omni-Bridge. All rights reserved.
//

import Foundation
import UIKit
class APIs : NSObject{
    // Host APi Url
    //    static let HOST_API = "\(UserDefaults.standard.value(forKey: "StartURLFromServer") ?? "")/api/User"
    //    for external
    static let HOST_API = "\(UserDefaults.standard.value(forKey: "StartURLFromServer") ?? "")/"
    //    for internal
    //    static let HOST_API = "http://172.16.1.8:9001/"
    
    /// Used to perform HTTP POST method
    ///
    /// - Parameters:
    ///   - requestStr: request string
    ///   - jsonData: json data
    ///   - completion: call back block
    static func performPost(requestStr: String, jsonData:Any!, completion: @escaping (_ data: Any?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlStr = "\(self.HOST_API)\(requestStr)"
            let targetURL = URL.init(string: urlStr)
            let request = NSMutableURLRequest(url: targetURL! as URL)
            //            let image = UIImage()
            request.httpMethod = "POST"
            //            if requestStr == "/UpdateProfile" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = self.convertJsonObjectToData(jsonData)
            request.httpBody = data
            //            }else{
            //                //                let chosenImage = (jsonData as! NSDictionary).value(forKey: "pickedImage")
            //                let boundary = "Boundary-\(UUID().uuidString)"
            //                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //                let params = ["userId" : "1"]
            //                request.httpBody = createBody(parameters: params,
            //                                              boundary: boundary,
            //                                              data: image.jpegData(compressionQuality: 0.1)!,
            //                                              mimeType: "image/jpg",
            //                                              filename: "profile.jpg")
            //            }
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if (data != nil) {
                        let json = self.convertDataToJsonObject(data!)
                        completion(json)
                    } else {
                        print(error ?? "error")
                        completion(error)
                    }
                })
                return()
            }
            task.resume()
        }
    }
    
    /// Used to create multipart HTML body
    ///
    /// - Parameters:
    ///   - parameters: json value
    ///   - boundary: boundary
    ///   - data: image data
    ///   - mimeType: mimeType
    ///   - filename: filename
    /// - Returns: NSdata
    static func createBody(parameters: [String: String],
                           boundary: String,
                           data: Data,
                           mimeType: String,
                           filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }
    
    /// Used tp perform HTTP GET Method
    ///
    /// - Parameters:
    ///   - requestStr: Request string
    ///   - query: Query string
    ///   - completion: callback block
    static func performGet(requestStr: String, query:String, completion: @escaping (_ data: Any?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlStr = "\(self.HOST_API)\(requestStr)\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let targetURL = URL.init(string: urlStr!)
            let request = NSMutableURLRequest(url: targetURL! as URL)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //            session interval timeout
            //            let configuration = URLSessionConfiguration.default
            //            configuration.timeoutIntervalForRequest = TimeInterval(15)
            //            configuration.timeoutIntervalForResource = TimeInterval(15)
            //            let session = URLSession(configuration: configuration)
            request.timeoutInterval = 15
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, error) -> Void in
                //print(resp!)
                DispatchQueue.main.async(execute: { () -> Void in
                    if (data != nil) {
                        let json = self.convertDataToJsonObject(data!)
                        completion(json)
                    } else {
                        print(error ?? "error")
                        completion(error)
                    }
                })
                return()
            }
            task.resume()
        }
    }
    
    /// Used tp perform HTTP GET Method
    ///
    /// - Parameters:
    ///   - requestStr: Request string
    ///   - query: Query string
    ///   - completion: callback block
    class func callServerUrl() {
        DispatchQueue.main.sync {
            let urlStr = "https://www.plug-able.com/PlugsApiConfig.json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let targetURL = URL.init(string: urlStr!)
            let request = NSMutableURLRequest(url: targetURL! as URL)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if (data != nil) {
                        if let json = self.convertDataToJsonObject(data!) as? NSDictionary{
                            print(json)
                        }
                        
                    } else {
                        print(error ?? "error")
                    }
                })
                return()
            }
            task.resume()
        }
    }
    
    /// Used to convert json to data
    ///
    /// - Parameter data: json object
    /// - Returns: data
    static func     convertJsonObjectToData(_ jsonObj:Any) -> Data! {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObj, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data
        } catch let error {
            print(error)
            return nil
        }
    }
    
    /// Used to convert data to json
    ///
    /// - Parameter data: data
    /// - Returns: json object
    static func convertDataToJsonObject(_ data:Data) -> Any! {
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return data
        } catch let error {
            print(error)
            return nil
        }
    }
}

// MARK: - NSMutableData append string extension
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
/// To get configuration url from server
struct GetApiConfig {
    static let URL_INDEX = 0
    static let URL_IDENTIFIER = "devBaseUrl"
    static func execute() -> Bool {
        let urlStr = "https://www.plug-able.com/PlugsApiConfig.json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let targetURL = URL.init(string: urlStr!)
        let request = NSMutableURLRequest(url: targetURL! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var success = false
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, error) -> Void in
            if (data != nil) {
                if let json = APIs.convertDataToJsonObject(data!) as? NSDictionary{
                    if let apiConfigArr = json.value(forKey: "apiConfig") as? NSArray{
                        if let url = (apiConfigArr[self.URL_INDEX] as? NSDictionary)?.value(forKey: self.URL_IDENTIFIER) as? String{
                            print(url)
                            UserDefaults.standard.set(url, forKey: "StartURLFromServer")
                            success = true
                        }
                    }
                }
            } else {
                print(error ?? "error")
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return success
    }
}
