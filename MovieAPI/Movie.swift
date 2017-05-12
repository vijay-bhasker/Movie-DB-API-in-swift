//
//  Movie.Swift
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import Foundation

class Movie {
    static let nowPlayingPath = "/now_playing"
    
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var title: String?
    var voteAverage: Double?
    var releaseDate: Date?

    init(parsedJson: [String: AnyObject]) {
        if let overview = parsedJson["overview"] as? String {
            self.overview = overview
        }
        
        if let popularity = parsedJson["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let posterPath = parsedJson["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let title = parsedJson["title"] as? String {
            self.title = title
        }
        
        if let voteAverage = parsedJson["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        
        if let releaseDate = parsedJson["release_date"] as? String {
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = "yyyy-MM-dd"

            self.releaseDate = toDateFormatter.date(from: releaseDate)
        }
    }
    
    func formattedReleaseDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        var formattedString: String?
        
        if let releaseDate = self.releaseDate {
            formattedString = dateFormatter.string(from: releaseDate)
        }
        
        return formattedString
    }
    
    func formattedScore() -> String? {
        var formattedScore: String?
        
        if let score = voteAverage {
            formattedScore = String(format: "%.1f", score)
        }
        
        return formattedScore
    }
    
    func posterUrl(_ size: String = "w154") -> URL? {
        if let unwrappedPosterPath = posterPath {
            let url = "\(MovieConfig.secureBaseImageUrl!)\(size)\(unwrappedPosterPath)"
            
            if var urlComponent = URLComponents(string: url) {
                urlComponent.queryItems = [MovieDB.apiKeyQueryParam()]
                
                return urlComponent.url
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    // MARK: - Class Methods
    
    
}
