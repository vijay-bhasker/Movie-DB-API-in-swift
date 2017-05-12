
//  MoveConfig.swift
//  
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import Foundation

class MovieConfig {
    static let configPath = "/3/configuration"
    
    static var secureBaseImageUrl: String?
    static var posterSizes: [String]?
    
    // MARK: - Class Methods
    class func loadConfig(_ performAsync: Bool = true, onComplete: @escaping () -> Void) {
        var isComplete = false
        let url = MovieDB.createUrl(configPath, queryParams: nil)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url!), completionHandler: {
            (data, response, responseError) in
            if let rawData = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawData, options: []) as! [String: Any]
                    
                    if let rawImageConfig = jsonResponse["images"] as? [String: Any] {
                        loadImageConfig(rawImageConfig as [String : AnyObject])
                    }
                    onComplete()
                }
                catch let error as NSError {
                    // Handle JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
            else {
                // No data present
            }
            isComplete = true
        }) 
        task.resume()
        
        if(!performAsync) {
            while(!isComplete){}
        }
    }
    
    class func loadImageConfig(_ rawConfig: [String: AnyObject]) {
        secureBaseImageUrl = rawConfig["secure_base_url"] as? String
        posterSizes = rawConfig["poster_sizes"] as? [String]
        
        if let posterSizesUnwrapped = posterSizes {
            print("Poster sizes: \(posterSizesUnwrapped)")
        }
    }
}
