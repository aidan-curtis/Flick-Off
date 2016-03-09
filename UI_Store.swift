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
   
    var descriptions = NSMutableArray(array: [
        "1000 Coins for $0.99",
        "10,000 Coins for $3.99",
        "25,000 coins for $10.99",
        "500 Gems for $0.99",
        "1,000 Gems for $3.99",
        "1,500 Gems for 10.99",
        "Beginning Blast for 50 Gems",
        "Bubble Shield for 500 Coins",
        "Red Ship for 100 Coins",
        "Blue Ship for 1000 Coins",
        "Orange Ship for 1000 Coins",
        "One Save for $0.99",
        "Three Saves for $1.99"]);
    
    var images = NSMutableArray(array: [
        "spinning_coin_gold_1",
        "spinning_coin_gold_1",
        "spinning_coin_gold_1",
        "Gem v95",
        "Gem v95",
        "Rocket for app v1",
        "bubble shield 13",
        "playerShip1_red",
        "playerShip1_blue",
        "playerShip1_orange",
        "heart",
        "heart"]);
    var sizes:[CGSize]=[
        CGSizeMake(40, 40),
        CGSizeMake(40, 40),
        CGSizeMake(40, 40),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100)
    ]
    
  
    
    @IBOutlet weak var Carousel: iCarousel!
    
    @IBOutlet weak var cost: UILabel!
    @IBAction func home(sender: AnyObject) {
      
      
            dispatch_async(dispatch_get_main_queue()) {
                
                print("wating");
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        
        
           
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
        
            var itemView: UIView
        
                
                itemView = UIView(frame:CGRect(x:0, y:0, width:200, height:200))
                itemView.contentMode = .ScaleAspectFit
            
    
        
        let imageView = UIImageView(frame: CGRectMake(100-(sizes[index].width/2), 100-(sizes[index].height/2), sizes[index].width, sizes[index].height))
        imageView.image = UIImage(named: "\(images.objectAtIndex(index))")
        itemView.addSubview(imageView);
            return itemView
        
        
    }
   
    
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        cost.text="\(descriptions[carousel.currentItemIndex])"
  
    }
    
 
    
}
