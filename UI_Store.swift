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
    var descriptions = NSMutableArray(array: [
        "25,000 Coins for $0.99",
        "50,000 Coins for $3.99",
        "100,000 Coins for $10.99",
        "100 Gems for $0.99",
        "1,000 Gems for $3.99",
        "2,500 Gems for $10.99",
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
        "Bag-300px",
        "Bag-300px",
        "Gem v95",
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
        let coins = NSUserDefaults.standardUserDefaults().integerForKey("coins");
        
        
        if((current_index>=0 && current_index<=5) || current_index==11 || current_index==12){
            print("buying object...\(descriptions[current_index])");
            if(SKPaymentQueue.canMakePayments()){
                current_ProductID="000\(current_index+1)"
                let productID:NSSet = NSSet(object: current_ProductID)
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start();
                print("Fething Products");
            }else{
                print("can not make purchases");
            }
        }else if(current_index==6){
            
        }else if(current_index==7){
            
        }else if(current_index==8){
            if(coins>=1000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-1000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_red", forKey: "ship")
            
            }
        }else if(current_index==9){
            if(coins>=10000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-10000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_blue", forKey: "ship")
            }
        }
        else if(current_index==10){
            if(coins>=25000){
                NSUserDefaults.standardUserDefaults().setInteger(coins-25000, forKey: "coins")
                NSUserDefaults.standardUserDefaults().setObject("playerShip1_orange", forKey: "ship")
            }
        }
       
        
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
        cost.text = descriptions.objectAtIndex(0) as! String
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
  
    
}
