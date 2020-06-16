//
//  WebServices.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/14/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum WebError: Error {
    case badRequest //400,429
    case unauthorized //401
    case forbidden //403
    case notFound //404
    case methodNotAllowed//405
    case tooManyRequests //429
    case internalServerError //500,501,502,503,504
    case noInternetConnection
    case outputError
    case unknownError
    case malformedOutput
}

enum WebServiceError: Error {
    
    case noInternetConnection
    case malformedOutput
    case invalidInputs //badRequest
    case invalidRequest //invalid url or invalid method
    case requestTimeout
    case authenticationFailed
    case tooManyRequests
    case serverProblem
    case noResults
    case unknownError
    case forbiddenError
    case notFoundError
    case unauthorizedError
}

class WebServices {
    
    static let sharedInstance : WebServices = {
        let instance = WebServices()
        return instance
    }()
    
    // MARK: Aliases
    typealias StatusResult              = (_ status: Int ) -> Void
    typealias StatusMessageResult       = (_ status: Int, _ message: String ) -> Void
    
    typealias FailureResult             = (_ error: Error?) -> Void
    typealias SuccessfullResponseResult = (_: [AnyHashable: Any]? ) -> Void
    
       typealias NewsResult                     = (_ status: Int, _ appointments: [NewsModel], _ totalItems: Int ) -> Void
    
    
    // MARK: Transporter Company / Appointments
    
    class func getNews(query: String, page: Int, size: Int, sortby: String, order: String, result: @escaping NewsResult, onFailure: @escaping FailureResult ){
        
        let lang:String = UserDefaults.standard.object(forKey: kAppLanguage) as? String ?? kDefaultLang
        
        
        let urlString = "\(BackendRoute.newsAPI)"
        
        let headers:[String: String] = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language": lang,
            "cache-control": "no-cache",
        ]
        
        let parameters:[String: Any] = [:]
        
         
        NetworkHandler.sendRequest(urlString, httpMethod: .get, parameters: parameters, headers: headers, completionHandler: {(_ status:StatusCode, _ dictionary: [AnyHashable: Any]?) -> Void in
            
            defer {
            }
            
            do {
                
                if (200..<399).contains( status.rawValue ) {
                    
                    guard let output = dictionary as? [String:Any] else {
                        throw WebServiceError.malformedOutput
                    }

                    let totalItems       = output["totalElements"] as? Int ?? 0
                    let resultsArray = output["results"] as? [Any] ?? []
                    
                    let data = try JSONSerialization.data(withJSONObject: resultsArray, options: .prettyPrinted)
                   
                    let  news         = try JSONDecoder().decode([NewsModel].self, from: data)
                    result(1,  news , totalItems)
                    
                }else{
                    handleStatus(status: status, onFailure: onFailure)
                }
                
            } catch let e {
                print("Exception: \(e)")
                onFailure(WebServiceError.malformedOutput)
            }
            
        }, errorHandler: { error in
            
            
            handleError(error: error, onFailure: onFailure)
            
            return nil
            
        })
        
        return
    }
    
    
    // MARK: handle status
    private class func handleStatus(status: StatusCode, onFailure: FailureResult){
        
        switch( status ){
            
        case .badRequest:
            onFailure(WebServiceError.invalidInputs)
            
        case .unauthorized, .forbidden:
            onFailure(WebServiceError.authenticationFailed)
            
        case .notFound:
            onFailure(WebServiceError.noResults)
            
        case .methodNotAllowed:
            onFailure(WebServiceError.invalidRequest)
            
        case .requestTimeout:
            onFailure(WebServiceError.requestTimeout)
            
        case .internalServerError:
            onFailure(WebServiceError.serverProblem)
            
        default:
            onFailure(WebServiceError.unknownError)
            
        }
    }
    
    
    // MARK: handle errors
    private class func handleError(error: Error, onFailure: FailureResult){
        
        switch( error ){
            
        case WebError.noInternetConnection:
            onFailure(WebServiceError.noInternetConnection)
            
        case WebError.badRequest:
            onFailure(WebServiceError.invalidInputs)
            
        case WebError.unauthorized:
            onFailure(WebServiceError.authenticationFailed)
            
        case WebError.forbidden:
            onFailure(WebServiceError.authenticationFailed)
            
        case WebError.notFound:
            onFailure(WebServiceError.noResults)
            
        case WebError.tooManyRequests:
            onFailure(WebServiceError.tooManyRequests)
            
        case WebError.internalServerError:
            onFailure(WebServiceError.serverProblem)
            
        default:
            onFailure(WebServiceError.unknownError)
        }
    }
    
}

