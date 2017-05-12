//
//  FBRequest.swift
//  Compa
//
//  Created by MacBook Pro on 5/11/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import FacebookCore

struct FBGetRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var rawResponse: Any?
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            print(rawResponse)
            self.rawResponse = rawResponse
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, birthday, picture"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
    
    init(_ path: String?, _ param: [String : Any]?) {
        if path != nil {
            self.graphPath = path!
        }
        if param != nil {
            self.parameters = param
        }
        
    }
}
