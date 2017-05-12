//
//  MovieDetailViewController.swift
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//


import UIKit
import AFNetworking
import OMAKOView

//Second DetailView Controller - OnClick of Table View Cell
class MovieDetailViewController: UIViewController, UIScrollViewDelegate
{

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var snowView: SnowView!

    @IBOutlet weak var movieSpecsParentView: OMAKOPartiallyVisibleSwipeableView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedMovie = movie
        {
            if let posterUrl = loadedMovie.posterUrl("original")
            {
                posterImageView.setImageWith(posterUrl)
            }
            //add the snow effect layer
            snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
            let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: -200))
            snowClipView.clipsToBounds = true
            snowClipView.addSubview(snowView)
            view.addSubview(snowClipView)
            
            movieDescriptionLabel.text = loadedMovie.overview
            
            releaseDateLabel.text = loadedMovie.formattedReleaseDate()
            releaseDateLabel.font = UIFont.boldSystemFont(ofSize: releaseDateLabel.font.pointSize)
            
            scoreLabel.text = loadedMovie.formattedScore()
            scoreLabel.font = UIFont.boldSystemFont(ofSize: scoreLabel.font.pointSize)
            
            movieTitleLabel.text = loadedMovie.title
            movieTitleLabel.font = UIFont.boldSystemFont(ofSize: movieTitleLabel.font.pointSize)
            
            movieSpecsParentView.setupView(bottomLayoutGuide: bottomLayoutGuide)
            
            if let title = loadedMovie.title {
                self.title = title
            }
        }
        edgesForExtendedLayout = UIRectEdge()
        
     
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        movieSpecsParentView.onRotate()
    }
}
