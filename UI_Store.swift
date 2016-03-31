//
//  UI_Store.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/6/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import UIKit
import StoreKit


class UI_Store: UIViewController, iCarouselDataSource, iCarouselDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    var current_index = -1;
    var buying_index = -1;
    var descriptions = NSMutableArray(array: [
        "10,000 Coins for $0.99",
        "50,000 Coins for $2.99",
        "100,000 Coins for $4.99",
        "100 Gems for $0.99",
        "500 Gems for $2.99",
        "1,000 Gems for $4.99",
        "Beginning Blast for 50 Gems",
        "Bubble Shield for 500 Coins",
        "Red Ship for 100 Coins",
        "Blue Ship for 1000 Coins",
        "Orange Ship for 1000 Coins",
        "One Save for $0.99",
        "Three Saves for $1.99"]);
    
    var current_ProductID:String = ""
    
    var images = NSMutableArray(array: [
        "Bag-300px",
        "schatzkiste-300px",
        "coin chest",
        "gem_bag_0",
        "gem_bag_1",
        "gem_bag_2",
        "rocket_image",
        "bubble shield 13",
        "playerShip1_red",
        "playerShip1_blue",
        "playerShip1_orange",
        "heart",
        "Three Hearts"]);
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
        CGSizeMake(100, 100),
        CGSizeMake(125, 100)
    ]
    
  
    @IBAction func use(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(images[current_index] as! String, forKey: "ship");
    }
    
    @IBOutlet weak var use_object: UIButton!
    @IBOutlet weak var Carousel: iCarousel!
    
    @IBOutlet weak var purple_gem: UILabel!

    @IBOutlet weak var shield_bank: UILabel!
    @IBOutlet weak var bank: UILabel!
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
        let coins = NSUserDefaults.standardUserDefaults().integerForKey("coins");
        let gems = NSUserDefaults.standardUserDefaults().integerForKey("gems");
        buying_index = current_index;
        if((current_index>=0 && current_index<=5) || current_index==11 || current_index==12){
            
            print("buying object...\(descriptions[current_index])");
            if(SKPaymentQueue.canMakePayments()){
                if(current_index+1==11){
                    current_ProductID="7"
                }
                else if(current_index+1==12){
                    current_ProductID="8"
                }
                else{
                    current_ProductID="\(current_index+1)"
                }
                let productID:NSSet = NSSet(object: current_ProductID)
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start();
                print("Fething Products");
            }else{
                print("can not make purchases");
            }
        }else if(current_index==6){
            if(gems>=50){
                NSUserDefaults.standardUserDefaults().setInteger(gems-50, forKey: "gems")
                let number_of_temp_blast = NSUserDefaults.standardUserDefaults().integerForKey("blast")
                NSUserDefaults.standardUserDefaults().setInteger(number_of_temp_blast+1, forKey: "blast")
                print("bought blast");
            }
            
        }else if(current_index==7){
            if(coins>=500){
                NSUserDefaults.standardUserDefaults().setInteger(coins-500, forKey: "coins")
                let number_of_temp_shields = NSUserDefaults.standardUserDefaults().integerForKey("shield")
                NSUserDefaults.standardUserDefaults().setInteger(number_of_temp_shields+1, forKey: "shield")
                print("bought shield");
            }
            
        }else if(current_index==8){
            if(coins>=10000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-10000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_red", forKey: "ship")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "playerShip1_red")
                use_object.hidden=false;
                home_button.hidden=true;
                buy.hidden=true;
            }
        }else if(current_index==9){
            if(coins>=10000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-10000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_blue", forKey: "ship")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "playerShip1_blue")
                use_object.hidden=false;
                home_button.hidden=true;
                buy.hidden=true;
            }
        }
        else if(current_index==10){
            if(coins>=10000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-10000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_orange", forKey: "ship")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "playerShip1_orange")
                use_object.hidden=false;
                home_button.hidden=true;
                buy.hidden=true;
            }
        }
    
        bank.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("coins"))";
        purple_gem.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("gems"))";
        shield_bank.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("sheild"))";
        
    }

    override func viewDidLoad() {
        NSUserDefaults.standardUserDefaults().setInteger(10000, forKey: "coins");
         NSUserDefaults.standardUserDefaults().setInteger(10000, forKey: "gems");
        bank.textColor=UIColor.yellowColor()
        bank.font=UIFont(name: "04b_19", size: 12);
        bank.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("coins"))";
        
        purple_gem.textColor=UIColor.magentaColor()
        purple_gem.font=UIFont(name: "04b_19", size: 12);
        purple_gem.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("gems"))";
        
        shield_bank.textColor=UIColor.cyanColor()
        shield_bank.font=UIFont(name: "04b_19", size: 12);
        shield_bank.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("shields"))";
    
        use_object.hidden=true;
        home_button.hidden=false;
        buy.hidden=true;
        Carousel.dataSource=self;
        Carousel.delegate=self;
        Carousel.type = iCarouselType.CoverFlow;
        Carousel.bounces=false;
        home_button.titleLabel!.font = UIFont(name: "04b_19", size: 30)
        
        cost.font = UIFont(name: "04b_19", size: 20)
        cost.text = descriptions.objectAtIndex(0) as? String
        //background_node.position=CGPointMake(self.size.width/2, (self.size.width*6/2));
        
        let background_image: UIImageView = UIImageView();
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
      
    
        print(NSUserDefaults.standardUserDefaults().boolForKey(images[index] as! String))
        print("\(index)")
        if((index == 8 || index == 9 || index == 10) && NSUserDefaults.standardUserDefaults().boolForKey(
            (images[index] as! String)) == true){
            print("using object now")
             use_object.hidden=false;
        }
        else{
             buy.hidden=false;
            
        }
        home_button.hidden=true;
       
        current_index = index
        carousel.reloadData()
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        home_button.hidden=false;
        buy.hidden=true;
        use_object.hidden=true;
        print(carousel.currentItemIndex);
        cost.text="\(descriptions[carousel.currentItemIndex])"
        if(current_index != -1){
        current_index = -1;
         carousel.reloadData()
        }
    }
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("got the request from Apple")
        let count : Int = response.products.count
        if (count>0) {
            let validProducts = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == current_ProductID) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    print("Product Purchased");
                    
                    let temp_coins = NSUserDefaults.standardUserDefaults().integerForKey("coins")
                    let temp_gems = NSUserDefaults.standardUserDefaults().integerForKey("gems");
                    let temp_saves = NSUserDefaults.standardUserDefaults().integerForKey("saves")
                    
                    if(buying_index==0){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_coins+10000, forKey: "coins")
                    }
                    else if(buying_index==1){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_coins+25000, forKey: "coins")
                    }
                    else if(buying_index==2){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_coins+50000, forKey: "coins")
                    }
                    else if(buying_index==3){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_gems+100, forKey: "gems")
                    }
                    else if(buying_index==4){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_gems+1000, forKey: "gems")
                    }
                    else if(buying_index==5){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_gems+2500, forKey: "gems")
                    }
                    else if(buying_index==11){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_saves+1, forKey: "saves")
                    }
                    else if(buying_index==12){
                        NSUserDefaults.standardUserDefaults().setInteger(temp_saves+3, forKey: "saves")
                    }
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .Failed:
                    print("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    // case .Restored:
                    //[self restoreTransaction:transaction];
                default:
                    break;
                }
            }
        }
    }
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    
}
