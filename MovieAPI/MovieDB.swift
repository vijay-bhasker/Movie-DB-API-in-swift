
//
//  MovieDB.Swift
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import Foundation

class MovieDB {
    static let scheme = "https"
    static let host = "api.themoviedb.org"
    static let apiKeyParam = "api_key"
    static var apiKey: String?
    
    // Movie paths
    static let nowPlayingPath = "/now_playing"
    static let topRatedPath = "/top_rated"
    
    // MARK: - Class Methods
    
    class func createUrl(_ path: String, queryParams: [URLQueryItem]?) -> URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = path
        urlComponent.queryItems = [apiKeyQueryParam()]
        
        if let queryParams = queryParams {
            urlComponent.queryItems?.append(contentsOf: queryParams)
        }
        return urlComponent.url
    }
    
    class func apiKeyQueryParam() -> URLQueryItem {
        return URLQueryItem(name: apiKeyParam, value: "a07e22bc18f5cb106bfe4cc1f83ad8ed")
    }
    
    class func logRequest(_ url: URL) {
        print("Making request to: \(url)")
    }
}
