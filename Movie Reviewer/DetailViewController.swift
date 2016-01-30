//
//  DetailViewController.swift
//  Movie Reviewer
//
//  Created by Arnold Ballesteros on 1/30/16.
//  Copyright © 2016 Arnold Ballesteros. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Scroll
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        
        //Title
        let title = movie["title"] as? String
        titleLabel.text = title
        print(movie)
        
        //Overview
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
            //OverView Size
        overviewLabel.sizeToFit()
        
        //Poster Image
        let placeHolder = "http://i.imgur.com/3BZctvK.png"
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"

        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let uimage = UIImage(named: placeHolder)
            //        let placeView = UIImageView(image: uimage!)
            let imageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            
            
            //Fade, added posterImageView instead of posterView from MoviesViewController, took out cells
            self.posterImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: uimage,
                success: { (imageRequest,imageResponse, image) -> Void in
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    UIView.animateWithDuration(1.5, animations: { () -> Void in
                       self.posterImageView.alpha = 1.0
                    })
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    
            })
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
