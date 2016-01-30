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


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Movies
    
    var movies : [NSDictionary]?
    
    var filteredData: [NSDictionary] = []
    
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
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
            
        )
                
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            //Load Data
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
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        //Change NSURL >> NSURLRequest
        let imageUrl = NSURL(string: baseUrl + posterPath)
        let placeHolder = "http://i.imgur.com/3BZctvK.png"
        let uimage = UIImage(named: placeHolder)
//        let placeView = UIImageView(image: uimage!)
        let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
//        cell.self.posterView.setImageWithURL(imageUrl!)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        let cellTitle = cell.titleLabel
       
        
        //Fade
        cell.self.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: uimage,
            success: { (imageRequest,imageResponse, image) -> Void in
                cell.self.posterView.alpha = 0.0
                cell.self.posterView.image = image
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                        cell.self.posterView.alpha = 1.0
                    })
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                
            })
            
                
                
        
                
        
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

    //Update Search as type
/*    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        print("hello")
        if searchText.isEmpty {
            filteredData = movies!
        } else {
            filteredData = movies!.filter({(movie: NSDictionary) -> Bool in
                if title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
*/
    //Refresh
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        self.tableView.reloadData()
        print("HELLO")
        refreshControl.endRefreshing()
    }
    //Fade in
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
