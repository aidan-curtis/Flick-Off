//
//  UI_Store.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/6/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import UIKit



class UI_Store: UIViewController, iCarouselDataSource, iCarouselDelegate{
   
    var images = NSMutableArray(array: ["a30000.png","a10000.png", "a40000.png","b10000.png", "b30000.png", "b40000.png"]);
    
  
    
    @IBOutlet weak var Carousel: iCarousel!
    
    @IBOutlet weak var cost: UILabel!
    @IBAction func home(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var home_button: UIButton!
    override func viewDidLoad() {
        
        Carousel.dataSource=self;
        Carousel.delegate=self;
        Carousel.type = iCarouselType.CoverFlow;
        Carousel.bounces=false;
        home_button.titleLabel!.font = UIFont(name: "04b_19", size: 30)
        
        cost.font = UIFont(name: "04b_19", size: 20)
        cost.text = images.objectAtIndex(0) as! String
        //background_node.position=CGPointMake(self.size.width/2, (self.size.width*6/2));
    
        var background_image: UIImageView = UIImageView();
        print("bounds width: \(self.view.bounds.size.width)")
        background_image.frame=CGRectMake(0, -self.view.bounds.size.width*2+(self.view.bounds.size.height),self.view.bounds.size.width,self.view.bounds.size.width*6);
        background_image.image=UIImage(named: "Background7_4k")
        self.view.addSubview(background_image);
    
    }
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        
        return images.count
    }

    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        print("looking for images")
        
            var itemView: UIImageView
            if (view == nil)
            {
                itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
                itemView.contentMode = .ScaleAspectFit
            }
            else
            {
                itemView = view as! UIImageView;
            }
            itemView.image = UIImage(named: "\(images.objectAtIndex(index))")
            return itemView
        
        
    }
   
    
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        cost.text="\(images[carousel.currentItemIndex])"
  
    }
    
 
    
}
