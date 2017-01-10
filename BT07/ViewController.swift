//
//  ViewController.swift
//  BT07
//
//  Created by Unima-TD-04 on 12/1/16.
//  Copyright © 2016 Unima-TD-04. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingView: NMRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()


        self.ratingView.emptyImage = UIImage(named: "emptyStar")
        self.ratingView.fullImage = UIImage(named: "filledStar")
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 3

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
