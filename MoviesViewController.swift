//
//  MoviesViewController.swift
//  Movie Reviewer
//
//  Created by Arnold Ballesteros on 1/25/16.
//  Copyright © 2016 Arnold Ballesteros. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {

    @IBOutlet var onTap: UITapGestureRecognizer!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Movies
    
    var movies : [NSDictionary]?
    
    var filteredData: [NSDictionary] = []
    
    var endpoint: String!
    
    var selectedBackgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        
        
        //Refresh
       
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Network Request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
            
        )
        //Loading Data UI
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            //End Loading Data UI
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                         
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.filteredData = responseDictionary["results"] as! [NSDictionary]
                           
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return filteredData.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredData[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
                cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        // Poster Image
        let cellTitle = cell.titleLabel
        let placeHolder = "http://i.imgur.com/3BZctvK.png"
        let baseUrl = "http://image.tmdb.org/t/p/"
        let lowres = "w45"
        let highres = "original"
        let smallImage = UIImage(named: ("http://image.tmdb.orb/t/p/w45"))
        let largeImage = UIImage(named: ("http://image.tmdb.org/t/p/original"))
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let uimage = UIImage(named: placeHolder)
            
       
            let largeImageRequest = NSURLRequest(URL: NSURL(string: baseUrl + highres + posterPath)!)
            let smallImageRequest = NSURLRequest(URL: NSURL(string: baseUrl + lowres + posterPath)!)
        
        //Fade
        cell.self.posterView.image = smallImage
        cell.self.posterView.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest,smallImageResponse, smallImage) -> Void in
                cell.self.posterView.alpha = 0.0
                //Low Res Image loaded before High Res
                cell.self.posterView.image = smallImage;

                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    cell.self.posterView.alpha = 1.0
                    
                    }, completion: { (success) -> Void in
                       cell.self.posterView.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                            cell.self.posterView.image = largeImage;
                    },

                    failure:  { (request, response, error) -> Void in

                        
                    })
                        
                })
            },
                failure: { (request, response, error) -> Void in
        })}
        
        //Change selected tab color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0/255.0, green:122/255.0, blue:255/255.0, alpha:0.8)
        cell.selectedBackgroundView = backgroundView

        print("row \(indexPath.row)")
        return cell
    }
    
    //searchBar
   func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    filteredData = searchText.isEmpty ? movies! : movies!.filter ({ (movie: NSDictionary) -> Bool in
        let title = movie["title"] as! String
        return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
    })
    print("Hello")
    tableView.reloadData()
    
    
    }


    //Refresh
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        self.tableView.reloadData()
        print("HELLO")
        refreshControl.endRefreshing()
    }
    
    //On Tap, end take keyboard out
    func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = movies![indexPath!.row]
   
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        
        print("Prepare for segue called!")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


}