//
//  TitleScene.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/6/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene{
    var temp_score=0;
    var background_node=SKSpriteNode();
    var emitterNode=SKEmitterNode();
    //menus
    var main_menu = SKSpriteNode();
    var sub_menu_1 = SKSpriteNode();
    var play = SKSpriteNode();
    var store = SKSpriteNode();
    var main_panel = SKSpriteNode();
    var high_score_label = SKLabelNode();
    var title = SKSpriteNode();
    var score_label=SKLabelNode();

    
    
    
    override func didMoveToView(view: SKView){
        self.backgroundColor=UIColor.blackColor();
        background_node.size=CGSizeMake(self.size.width, self.size.width*6);
        background_node.texture=SKTexture(imageNamed: "Background7_4k");
        background_node.position=CGPointMake(self.size.width/2, -self.size.width);
        background_node.zPosition = -1000;
        print("node width \(self.size.width)")
        
        print("scene highscore \(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))")
        high_score_label.text="\(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))"
        play.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-120)
        play.size=CGSizeMake(270,70)
        play.texture=SKTexture(imageNamed: "play_button")
        play.name="play"
        
        store.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-200)
        store.size=CGSizeMake(270,70)
        store.texture=SKTexture(imageNamed: "store_button")
        store.name="store"
        
        title.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+210)
        title.size=CGSizeMake(270,70)
        title.texture=SKTexture(imageNamed: "title")
        title.name="title"
        
        main_panel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+50)
        main_panel.size=CGSizeMake(290,270)
        main_panel.texture=SKTexture(imageNamed: "Main_Panel")
        
        high_score_label.position = CGPointMake(self.frame.size.width/2,(self.frame.size.height/2)-30)
        score_label.position = CGPointMake(self.frame.size.width/2,(self.frame.size.height/2)+60)
        high_score_label.fontColor=UIColor.greenColor()
        score_label.fontColor=UIColor.greenColor()
        if( (score_label.text == nil) ){
            score_label.text = "0"
        }
        if( (high_score_label.text == nil) ){
            high_score_label.text = "0"
        }
        high_score_label.fontName = "04b_19"
        score_label.fontName = "04b_19"
        high_score_label.zPosition = 900
        score_label.zPosition = 900
        
        
        
        addChild(background_node);
        addChild(title);
        addChild(high_score_label)
        addChild(score_label)
        addChild(store)
        addChild(main_panel)
        addChild(play)
        print("added");
        
//        emitterNode=starfieldEmitter(SKColor.grayColor(), starSpeedY: 3, starsPerSecond: 10, starScaleFactor: 0.08,backup: false);
//        emitterNode.zPosition = -11;
//        self.addChild(emitterNode);
//     
//        emitterNode = starfieldEmitter(SKColor.darkGrayColor(), starSpeedY: 1, starsPerSecond: 2, starScaleFactor: 0.05, backup: false)
//        emitterNode.zPosition = -12
//        self.addChild(emitterNode)

        
//          saving score
//            if(Int(score.text!)>Int(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))){
//                NSUserDefaults.standardUserDefaults().setInteger(Int(score.text!)!, forKey: "highscore")
//            }
//            high_score_label.text="\(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))"
//            score_label.text="\(Int(score.text!)!)"
//            //backup_emitterNode.hidden=false
//            emitterNode.hidden=true
//            fuel.removeFromParent()
//            game_status=0
        
    }
//    override func update(currentTime: CFTimeInterval){
//        
//    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touched");
        
        for touches: AnyObject in touches{
            
            let location = touches.locationInNode(self)
            
            if(self.nodeAtPoint(location) == play){
                let gameScene = GameScene(fileNamed: "GameScene")!;
                let transition = SKTransition.fadeWithDuration(1)
                let skView = self.view as SKView!;
                skView.ignoresSiblingOrder = true;
                gameScene.size=skView.bounds.size;
                gameScene.scaleMode = .AspectFill
                skView.presentScene(gameScene, transition: transition)
            }
            if(self.nodeAtPoint(location) == store){
                let presenting = self.view?.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("UI_Store");
                presenting?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.view?.window?.rootViewController?.showViewController(presenting!, sender: nil)
            }
        }
        
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