//
//  NetworkHandler.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/14/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import Foundation
import Alamofire
//import FileKit

enum StatusCode: Int {
    
    case unknown                         = 0
    
    case ok                              = 200
    case created                         = 201
    case accepted                        = 202
    case nonAuthoritativeInformation     = 203
    case noContent                       = 204
    case resetContent                    = 205
    case partialContent                  = 206
    case multiStatus                     = 207
    case alreadyReported                 = 208
    case imUsed                          = 226
    
    //3×× Redirection
    case multipleChoices                 = 300
    case movedPermanently                = 301
    case found                           = 302
    case seeOther                        = 303
    case notModified                     = 304
    case useProxy                        = 305
    case unused                          = 306
    case temporaryRedirect               = 307
    case permanentRedirect               = 308
    
    //4×× Client Error 4xx
    case badRequest                      = 400
    case unauthorized                    = 401
    case paymentRequired                 = 402
    case forbidden                       = 403
    case notFound                        = 404
    case methodNotAllowed                = 405
    case notAcceptable                   = 406
    case proxyAuthenticationRequired     = 407
    case requestTimeout                  = 408
    case conflict                        = 409
    case gone                            = 410
    case lengthRequired                  = 411
    case preconditionFailed              = 412
    case requestEntityTooLarge           = 413
    case requestUriTooLong               = 414
    case unsupportedMediaType            = 415
    case requestedRangeNotSatisfiable    = 416
    case expectationFailed               = 417
    
    case imATeapot                       = 418
    case misdirectedRequest              = 421
    case unprocessableEntity             = 422
    case locked                          = 423
    case failedDependency                = 424
    case upgradeRequired                 = 426
    case preconditionRequired            = 428
    case tooManyRequests                 = 429
    case requestHeaderFieldsTooLarge     = 431
    case connectionClosedWithoutResponse = 444
    case unavailableForLegalReasons      = 451
    case clientClosedRequest             = 499
    
    //5×× Server Error 5xx
    case internalServerError             = 500
    case notImplemented                  = 501
    case badGateway                      = 502
    case serviceUnavailable              = 503
    case gatewayTimeout                  = 504
    case httpVersionNotSupported         = 505
    case variantAlsoNegotiates           = 506
    case insufficientStorage             = 507
    case loopDetected                    = 508
    case notExtended                     = 510
    case networkAuthenticationRequired   = 511
    case networkConnectTimeoutError      = 599
}

typealias CompleteHandler         = (_: StatusCode, _: [AnyHashable: Any]) -> Void?
typealias DownloadCompleteHandler = (_: StatusCode, _: URL) -> Void?
typealias ErrorHandler            = (_: Error) -> Void?
typealias ProgressHandler         = (_ percent: Float) -> Void?

class NetworkHandler {
    
    static var incompletedRequests: [String:Any] = [:]
    
    class func sendRequest(_ urlString: String, httpMethod: HTTPMethod, parameters: [String: Any], headers: [String: String]?, completionHandler complete: @escaping CompleteHandler, errorHandler failureHandler: @escaping ErrorHandler) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForRequest
        
        manager.request(urlString,
                        method: httpMethod,
                        parameters: parameters,
                        headers: headers)
            .validate(statusCode: 200..<599)
            //.validate(contentType: ["application/json"])
            //.validate()
            .responseJSON { response in
                
                /*if response.result == nil { //Check for response
                 
                 incompletedRequests = [:]
                 
                 incompletedRequests["url"]               = urlString
                 incompletedRequests["method"]            = httpMethod
                 incompletedRequests["parameters"]        = parameters
                 incompletedRequests["headers"]           = headers
                 incompletedRequests["completionHandler"] = complete
                 incompletedRequests["errorHandler"]      = failureHandler
                 incompletedRequests["type"]              = 2
                 }*/
               
                
                let statusCode = StatusCode(rawValue: response.response?.statusCode ?? 0) ?? .unknown
                
                switch response.result {
                    
                case .success(let value):
                    
                    incompletedRequests = [:]
                    
                    if let resultJson = value as? [AnyHashable: Any] {
                        complete(statusCode, resultJson)
                    }else if let resultJson = value as? [Any] {
                        let fixedOutput = [ "output" : resultJson ]
                        complete(statusCode, fixedOutput)
                    }else{
                        // ya zam ingele3 😠 ... 😂😂
                        failureHandler(WebError.outputError)
                    }
                    
                case .failure(let error):
                    if statusCode == .ok {
                        complete(statusCode, ["output":[:]])
                    }else {
                        handleError(error: error, errorHandler: failureHandler)
                        
                        incompletedRequests = [:]
                        
                        incompletedRequests["url"]               = urlString
                        incompletedRequests["method"]            = httpMethod
                        incompletedRequests["parameters"]        = parameters
                        incompletedRequests["headers"]           = headers
                        incompletedRequests["completionHandler"] = complete
                        incompletedRequests["errorHandler"]      = failureHandler
                        incompletedRequests["type"]              = 1
                    }
                    
                }
                
        }
    }
    
    class func sendRawDataRequest(_ urlString: String, httpMethod: HTTPMethod, parameters: [String: Any], headers: [String: String]?, completionHandler complete: @escaping CompleteHandler, errorHandler failureHandler: @escaping ErrorHandler) {
        
        //Alamofire.request(urlString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
        //, encoding: JSONEncoding(options: [])
        
        guard let url = URL(string: urlString) else {
            failureHandler(WebError.badRequest)
            return ()
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.timeoutInterval = 120
        
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        /*
         //This is more code just to assert conversion was true
         
         let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
         
         let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
         
         if let json = json {
         print(json)
         }
         
         request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
         */
        
        request.httpBody = data
        
        //Alamofire
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForRequest
        
        manager.request(request as! URLRequestConvertible)
            .validate(statusCode: 200..<599)
            //.validate(contentType: ["application/json"])
            //.validate()
            .responseJSON { response in
                
               
                
                var statusCode = StatusCode(rawValue: response.response?.statusCode ?? 0) ?? .unknown
                
                
                if response.result == nil { //Check for response
                    
                    failureHandler(WebError.outputError)
                    
                    incompletedRequests = [:]
                    
                    incompletedRequests["url"]               = urlString
                    incompletedRequests["method"]            = httpMethod
                    incompletedRequests["parameters"]        = parameters
                    incompletedRequests["headers"]           = headers
                    incompletedRequests["completionHandler"] = complete
                    incompletedRequests["errorHandler"]      = failureHandler
                    incompletedRequests["type"]              = 2
                }
                
                
                
                switch response.result {
                    
                case .success(let value):
                    
                    incompletedRequests = [:]
                    
                    if let resultJson = value as? [AnyHashable: Any] {
                        complete(statusCode, resultJson)
                    }else if let resultJson = value as? [Any] {
                        let fixedOutput = [ "output" : resultJson ]
                        complete(statusCode, fixedOutput)
                    }else{
                        // ya zam ingele3 😠 ... 😂😂
                        failureHandler(WebError.outputError)
                    }
                    
                    
                case .failure(let error):
                    
                    if (statusCode.rawValue == 200)
                    {
                        let fixedOutput = [ "output" : "Success" ]
                        complete(statusCode, fixedOutput)
                        return
                    }
                  
                    handleError(error: error, errorHandler: failureHandler)
                    
                    incompletedRequests = [:]
                    
                    incompletedRequests["url"]               = urlString
                    incompletedRequests["method"]            = httpMethod
                    incompletedRequests["parameters"]        = parameters
                    incompletedRequests["headers"]           = headers
                    incompletedRequests["completionHandler"] = complete
                    incompletedRequests["errorHandler"]      = failureHandler
                    incompletedRequests["type"]              = 2
                    
                }
                
        }
    }
    
    
  
}



private func handleError(error: Error, errorHandler: ErrorHandler){
    
    switch( error ) {
        
    case AFError.responseValidationFailed:
        //print(err.some.responseValidationFailed.reason.unacceptableStatusCode)
        //failureHandler(WebServicesError.serverProblem)
        
        let e = error as? AFError
        //print( "error = ", e?.responseCode as! Int )
        
        let responseCode = e?.responseCode ?? 0
        
        switch responseCode {
            
        case 400:
            errorHandler(WebError.badRequest)
            
        case 401:
            errorHandler(WebError.unauthorized)
            
        case 403:
            errorHandler(WebError.forbidden)
            
        case 404:
            errorHandler(WebError.notFound)
            
        case 429:
            errorHandler(WebError.tooManyRequests)
            
        case 500,501,502,503,504:
            errorHandler(WebError.internalServerError)
            
        case 405:
            errorHandler(WebError.methodNotAllowed)
            
        default:
            errorHandler(WebError.unknownError)
            
        }
        
    default:
        
        let error = error as NSError
        
        switch error.code {
            
        case -1022:
            //HINT: Check: App Transport Security Settings: Allow Arbitrary Loads set to true
            errorHandler(WebError.noInternetConnection)
            
        case -1009:
            errorHandler(WebError.noInternetConnection)
            
        default:
            errorHandler(WebError.unknownError)
        }
        
        //errorHandler(WebError.noInternetConnection)
    }
}

func simulateSendingRequest(_ jsonFileName: String, completionHandler complete: @escaping CompleteHandler, errorHandler failureHandler: @escaping ErrorHandler) {
    
    do {
        
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            
            let jsonData        = try Data(contentsOf: url)
            let dictionary      = try JSONSerialization.jsonObject(with: jsonData) as? [String : Any]
            
            let output          = dictionary?["success"] as? [String:Any] ?? [:]
            
            complete(.ok, output)
            
        }else{
            
            failureHandler(WebServiceError.unknownError)
            
        }
        
        
    } catch {
        print(error)
    }
    
}
