//
//  Store.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/6/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class Store: SKScene{
    var temp_score=0;
    var background_node=SKSpriteNode();
    var emitterNode=SKEmitterNode();
    //menus
   
    var title = SKSpriteNode();

    override func didMoveToView(view: SKView){
        self.backgroundColor=UIColor.blackColor();
        background_node.size=CGSizeMake(self.size.width, self.size.width*6);
        background_node.texture=SKTexture(imageNamed: "Background7_4k");
        background_node.position=CGPointMake(self.size.width/2, (self.size.width*6/2));
        background_node.zPosition = -1000;
        
        
        
        title.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+210)
        title.size=CGSizeMake(270,70)
        title.texture=SKTexture(imageNamed: "title")
        title.name="title"
        
        
        let a = UILabel()
        a.text="plssssss"
        a.textColor=UIColor.whiteColor()
      
        self.view!.addSubview(a)
        
        
        addChild(background_node);
        addChild(title);
    
        emitterNode = starfieldEmitter(SKColor.darkGrayColor(), starSpeedY: 1, starsPerSecond: 2, starScaleFactor: 0.05, backup: false)
        emitterNode.zPosition = -12
        self.addChild(emitterNode)
        
        
        
    }
    //    override func update(currentTime: CFTimeInterval){
    //
    //    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("touched");
//        let gameScene = GameScene(fileNamed: "GameScene")!;
//        let transition = SKTransition.fadeWithDuration(1)
//        let skView = self.view as SKView!;
//        skView.ignoresSiblingOrder = true;
//        gameScene.size=skView.bounds.size;
//        gameScene.scaleMode = .AspectFill
//        skView.presentScene(gameScene, transition: transition)
    }
    
    func starfieldEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat, backup: Bool) -> SKEmitterNode {
        
        // Determine the time a star is visible on screen
        let lifetime =  frame.size.height * UIScreen.mainScreen().scale / starSpeedY
        
        // Create the emitter node
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark")
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = SKColor.lightGrayColor()
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime
        
        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        
        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(NSTimeInterval(lifetime))
        
        
        return emitterNode
    }
    
}