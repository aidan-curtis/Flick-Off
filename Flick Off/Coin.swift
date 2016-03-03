//
//  Coin.swift
//  Flick Off
//
//  Created by Aidan Curtis on 2/29/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode{
    
    init() {
        
        let coin = SKSpriteNode()
        if(arc4random_uniform(20)==0){
            let mode=Int(arc4random_uniform(3))
            next_coin.begin_action(mode, starting_location: Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setAlternate(Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
            next_coin.setWidth(Int(arc4random_uniform(15))+10)
            next_coin.power(Int(arc4random_uniform(2)))
        }
        coins_position_x=next_coin.fetch_next_coin()
        if(coins_position_x<Int(self.size.width) && next_coin.status==1){
            //coin.texture=SKTexture(imageNamed:"spinning_coin_gold_1")
            var coin_textures=[SKTexture]()
            for (var i=0; i<8; i=i+1){
                let name="spinning_coin_gold_"+(i+1 as NSNumber).stringValue
                coin_textures.append(SKTexture(imageNamed: name))
            }
            coin.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(coin_textures, timePerFrame: 0.1)))
            coin.position=CGPointMake(CGFloat(coins_position_x), self.size.height+25)
      
        }

    
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}