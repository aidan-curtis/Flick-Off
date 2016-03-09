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
    var current_index = -1;
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
        "Bag-300px",
        "Bag-300px",
        "Bag-300px",
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
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
        CGSizeMake(100, 100),
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
    @IBOutlet weak var buy: UIButton!
    
    @IBAction func buy_object(sender: AnyObject) {
    }
    override func viewDidLoad() {
        home_button.hidden=false;
        buy.hidden=true;
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
        
        
        let borderView = UIImageView(frame: CGRectMake(0,0, 200, 200))
        if(current_index==index){
            borderView.image = UIImage(named: "GreenBorder")
        }
        else{
            borderView.image = UIImage(named: "BlueBorder")
        }
        itemView.addSubview(borderView);
        return itemView
        
        
    }
   
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        home_button.hidden=true;
        buy.hidden=false;
        
        current_index = index
        home_button.imageView!.image = UIImage(named: "buy_button");
        carousel.reloadData()
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        home_button.hidden=false;
        buy.hidden=true;
        current_index = -1;
        print(carousel.currentItemIndex);
        cost.text="\(descriptions[carousel.currentItemIndex])"
        carousel.reloadData()
  
    }
    
 
    
}
