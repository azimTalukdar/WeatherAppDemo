//
//  APIManager.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class HttpClientApi: NSObject {
    var request : URLRequest?
    
    var session : URLSession?
    
    static func instance() ->  HttpClientApi{
        
        return HttpClientApi()
    }
    
    func makeAPICallPOST(strAPI: String,params: Dictionary<String, String>!, method: HttpMethod,isHUD:Bool, success:@escaping (Data ) -> Void, failure: @escaping ( Any )-> Void) {
        OperationQueue.main.addOperation ({
            if isHUD{
//                AppDelegate.appDelegateInstance().showHud(nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
        })
        let Url = NSURL(string:strAPI)! as URL
        let request = NSMutableURLRequest(url:Url as URL);
        let strParameters = NSMutableString()
        if let params = params{
            for (keys, obj) in params{
                strParameters.append("&\(keys)=\(obj)")
            }
        }
        let data = strParameters.data(using: String.Encoding.utf8.rawValue)
        request.httpBody = data
        request.httpMethod = method.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            success(data)
            OperationQueue.main.addOperation ({
                if isHUD{
//                    AppDelegate.appDelegateInstance().closeHud()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            })
        }
        task.resume()
    }
    
    
    
}
