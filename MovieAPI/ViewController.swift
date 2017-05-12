//
//  ViewController.swift
//  MovieAPI
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit
import MBProgressHUD
import QuartzCore


//Animation Direction
enum AnimationDirection: Int {
    case positive = 1
    case negative = -1
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var movieTitleSearchBar = UISearchBar()
    var refreshControl = UIRefreshControl()
    
    let movieDetailSegueId = "movieCellSelected"
    var moviePath: String?
    
    var allMovies = [Movie]()
    var movies = [Movie]()
    var page: Int?
    var totalPages: Int?
    var lastFetched = 0
    var haveAllMoviesBeenFetched = false
    var isFetchingMovies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchMovies()
    }
    
    // MARK: - View Configuration
    
    func setupView() {
        setupSearchBar()
        setupTableView()
        
        if let navigationController = self.navigationController {
            if let topItem = navigationController.navigationBar.topItem {
                topItem.titleView = movieTitleSearchBar
            }
        }
        
        edgesForExtendedLayout = UIRectEdge()
    }
    
    func setupTableView() {
        // Refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.allowsSelection = true
        moviesTableView.separatorColor = UIColor.clear
    }
    
    func setupSearchBar() {
        movieTitleSearchBar.placeholder = "Search movies"
        movieTitleSearchBar.delegate = self
    }
    
    
    
    // MARK: - Fetching Movies
    
    func refreshMovies() {
        allMovies = [Movie]()
        
        resetPageState()
        fetchMovies()
    }
    
    func resetPageState() {
        page = nil
        totalPages = nil
        lastFetched = 0
        haveAllMoviesBeenFetched = false
    }
    
    // Cannot be private since it needs to be exposed to Obj-C for the
    // UIRefreshControl.addTarget(_:action:forControlEvents:) method
    func fetchMovies() {
        if haveAllMoviesBeenFetched || isFetchingMovies {
            return
        }
        
       MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if let page = page {
            if let totalPages = totalPages {
                if page < totalPages {
                    self.page = page + 1
                }
                else {
                    haveAllMoviesBeenFetched = true
                }
            }
        }
        
        isFetchingMovies = true
        
        fetchMoviesFromServices()

    }
    
     func fetchMoviesFromServices() {
        isFetchingMovies = false
        
        
        //AAPI key is created from https://www.themoviedb.org/settings/api
        
        let apiKey = (Constants.Application_API_Key)
        let url = URL(string: "\(Constants.Application_Movie_URL)\(apiKey)")!
        //Timed-out interval
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        //Maitaining Session
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //Hit the webservice using URLSessionDataTask
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let jsonReszonse = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
                    
                    self.page = jsonReszonse["page"] as? Int
                    self.totalPages = jsonReszonse["total_pages"] as? Int
                    
                    if let moviesJson = jsonReszonse["results"] as? [[String: AnyObject]] {
                        for movieJson in moviesJson {
                            self.allMovies.append(Movie(parsedJson: movieJson))
                        }
                        self.movies = self.allMovies
                        self.lastFetched = self.allMovies.count - 1
                        
                        DispatchQueue.main.async {
                           
                            self.refreshControl.endRefreshing()
                            self.moviesTableView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                    else {
                        // Handle casting error
                    }
                    
                }
            }
        }
        task.resume()
        
        // Print out response information
        
        
    }
    
    // MARK: - Search Bar Delegate functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.characters.count > 0) {
            movies = allMovies.filter() {
                (movie: Movie) -> Bool in
                
                if let title = movie.title {
                    do {
                        let regex = try NSRegularExpression(pattern: "\(searchText)", options: NSRegularExpression.Options.caseInsensitive)
                        
                        return regex.numberOfMatches(in: title, options: [], range: NSMakeRange(0, title.characters.count)) > 0
                    }
                    catch {
                        // If there's a regex error, return the entire array
                        return true
                    }
                }
                else {
                    return false
                }
            }
        }
        else {
            movies = allMovies
        }
        moviesTableView.reloadData()
    }
    
    // Called when search bar obtains focus.  I.e., user taps on the search bar to enter text.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        // Removes focus from the search bar
        searchBar.endEditing(true)
        
        movies = allMovies
        moviesTableView.reloadData()
    }
    
    // MARK: - TableView Delegate and DataSource Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: MovieCellView.cellIdentifier) as! MovieCellView
        
        let movie = movies[indexPath.row]
        
        
        let direction: AnimationDirection = .positive
        
    
    
        cell.descriptionLabel.text = movie.overview
        cell.titleLabel.text = movie.title
        
       // cell.titleLabel.textColor = UIColor.
        
        cubeTransition(label: cell.titleLabel, text: movie.title!,
                       direction: direction)
        
        
        
        
        if let posterUrl = movie.posterUrl() {
            let data = try? Data(contentsOf: posterUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.thumbnailImage.image = UIImage(data: data!)
            //cell.thumbnailImage.image = UIImage()
        }
        
        if(indexPath.row >= lastFetched && !haveAllMoviesBeenFetched){
            fetchMovies()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row when coming back to this controller in a navigation controller context
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == movieDetailSegueId {
            
                if let movieDetailViewController = segue.destination as? MovieDetailViewController {
                    if let indexPath = moviesTableView.indexPathForSelectedRow {
                        movieDetailViewController.movie = movies[indexPath.row]
                    }
                }
            
            
        }
    }


    // MARK: - Label Animation Functions
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection)
    {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        
        let auxLabelOffset = CGFloat(direction.rawValue) *
            label.frame.size.height/2.0
        
        auxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: auxLabelOffset))
        
        label.superview!.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            auxLabel.transform = CGAffineTransform.identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
        }, completion: {_ in
            label.text = auxLabel.text
            label.transform = CGAffineTransform.identity
            
            auxLabel.removeFromSuperview()
        })
        
    }

}

