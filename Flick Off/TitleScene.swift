//
//  TitleScene.swift
//  Flick Off
//
//  Created by Aidan Curtis on 3/6/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

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
    var score_label=SKLabelNode();
    
    var high_score_label_title = SKLabelNode();
    var score_label_title=SKLabelNode();
    
    var title = SKSpriteNode();

    var character = SKSpriteNode();
    var fuel = SKEmitterNode();
    
    
    let manager = CMMotionManager();
    var currentRoll = Double();
    var launch = false;

    var black_background_node = SKSpriteNode();
    override func didMoveToView(view: SKView){
        black_background_node.alpha=0;
        black_background_node.size = CGSizeMake(self.size.width, self.size.height);
        black_background_node.position = CGPointMake(self.size.width/2, self.size.height/2);
        black_background_node.color = UIColor.blackColor();
        black_background_node.zPosition = 20000;
        self.addChild(black_background_node);
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("black_screen")==true){
            black_background_node.alpha=1.0;
        }
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "black_screen");
       
        
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        self.manager.deviceMotionUpdateInterval=1.0/60.0;
        self.manager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical);
        
        fuel = SKEmitterNode(fileNamed: "MyParticle.sks")!
       
        addChild(fuel);
        fuel.targetNode=self;
        fuel.removeFromParent()
        addChild(fuel);
        if(NSUserDefaults.standardUserDefaults().objectForKey("ship") != nil){
                character.texture=SKTexture(imageNamed: NSUserDefaults.standardUserDefaults().objectForKey("ship") as! String);
        }
        else{
            character.texture=SKTexture(imageNamed: "playerShip1_green")
        }
   
        
        character.position=CGPointMake(self.frame.size.width/2, self.size.height/2);
        fuel.position=CGPointMake(self.frame.size.width/2, self.size.height/2-30);
        character.zPosition=0
        character.size=CGSizeMake(50*1.5, 38*1.5);
        addChild(character);
        
        self.backgroundColor=UIColor.blackColor();
        
        background_node.size=CGSizeMake(self.size.width, self.size.width*4.0 );
        background_node.anchorPoint=CGPoint(x: 0.0,y: 0.0);
       
        background_node.texture=SKTexture(imageNamed: "title_image_long");
        background_node.position=CGPointMake(0.0, 0.0);
        background_node.zPosition = -1000;
        //print("node width \(self.size.width)")
        
        //print("scene highscore \(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))")
        high_score_label.text="\(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))"
        
      
        title.position=CGPointMake(self.frame.size.width/2, self.size.height-70)
        title.size=CGSizeMake(self.frame.size.width,self.size.width*(1/4.61538))
        
        
        
        store.position=CGPointMake(self.frame.size.width/2, 40)
        store.size=CGSizeMake(50,50)
        store.texture=SKTexture(imageNamed: "store_icon")
        store.name="store"
       
        
        title.texture=SKTexture(imageNamed: "title_image")
        title.name="title"
       
        
        play.position=CGPointMake(self.frame.size.width/2,(title.position.y+self.frame.size.height/2)/2)
        play.size=CGSizeMake(80,80)
        play.texture=SKTexture(imageNamed: "play_button.png")
        play.name="play"

        
//        main_panel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+50)
//        main_panel.size=CGSizeMake(290,270)
//        main_panel.texture=SKTexture(imageNamed: "Main_Panel")
   
        
        high_score_label.position = CGPointMake(40,20);
        score_label.position = CGPointMake(self.frame.size.width-40,20);
        high_score_label.fontColor=UIColor.whiteColor()
        score_label.fontColor=UIColor.whiteColor()
        if( (score_label.text == nil) ){
            score_label.text = "0"
        }
        if( (high_score_label.text == nil) ){
            high_score_label.text = "0"
        }
        high_score_label.fontName = "Helvetica"
        score_label.fontName = "Helvetica"
        high_score_label.fontSize = 20.0
        score_label.fontSize = 20.0
        high_score_label.zPosition = 900
        score_label.zPosition = 900
        
        
        high_score_label_title.position = CGPointMake(40,50);
        score_label_title.position = CGPointMake(self.frame.size.width-40,50);
        high_score_label_title.fontColor=UIColor.whiteColor()
        score_label_title.fontColor=UIColor.whiteColor()
        score_label_title.text = "Score"
        high_score_label_title.text = "Best"
        high_score_label_title.fontName = "Helvetica"
        score_label_title.fontName = "Helvetica"
        high_score_label_title.fontSize = 20.0
        score_label_title.fontSize = 20.0
        high_score_label_title.zPosition = 900
        score_label_title.zPosition = 900
    
     
        
        addChild(background_node);
        addChild(title);
        addChild(high_score_label)
        addChild(score_label)
        addChild(high_score_label_title)
        addChild(score_label_title)
        addChild(store)
        addChild(play)
        
        
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("launch")==true){
            //print("zooming");
                  NSUserDefaults.standardUserDefaults().setBool(false, forKey: "launch");
            fuel.position=CGPointMake(self.frame.size.width/2, -100);
            fuel.runAction(SKAction.moveToY(self.size.height/2-30, duration: 2));
            let a = { () -> Void in
                self.title.position.y = self.title.position.y-10;
                self.title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.title.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            let b = { () -> Void in
                self.play.position.y = self.play.position.y-10;
                self.play.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.play.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            let c = { () -> Void in
                self.store.position.y = self.store.position.y-10;
                self.store.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.store.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            let d = { () -> Void in
                self.high_score_label.position.y = self.high_score_label.position.y-10;
                self.high_score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.high_score_label.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            let e = { () -> Void in
                self.high_score_label_title.position.y = self.high_score_label_title.position.y-10;
                self.high_score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.high_score_label_title.runAction(SKAction.fadeAlphaTo(1, duration: 0.3))
                
            }
            let f = { () -> Void in
                self.score_label.position.y = self.score_label.position.y-10;
                self.score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.score_label.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            let g = { () -> Void in
                self.score_label_title.position.y = self.score_label_title.position.y-10;
                self.score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                self.score_label_title.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
            }
            character.position=CGPointMake(self.frame.size.width/2, -100);
            character.runAction(SKAction.moveToY(self.size.height/2, duration: 2));
            store.alpha=0;
            store.runAction(SKAction.sequence([SKAction.waitForDuration(1.8),SKAction.runBlock(c)]));
            
            title.alpha=0;
            title.runAction(SKAction.sequence([SKAction.waitForDuration(1.8),SKAction.runBlock(a)]));
     
            play.alpha=0;
            play.runAction(SKAction.sequence([SKAction.waitForDuration(1.8),SKAction.runBlock(b)]));
            
            play.alpha=0;
            play.runAction(SKAction.sequence([SKAction.waitForDuration(1.8),SKAction.runBlock(b)]));
            
            
            high_score_label.alpha=0;
            high_score_label.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),SKAction.runBlock(d)]));
            high_score_label_title.alpha=0;
            high_score_label_title.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),SKAction.runBlock(e)]));
            score_label.alpha=0;
            score_label.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),SKAction.runBlock(f)]));
            score_label_title.alpha=0;
            score_label_title.runAction(SKAction.sequence([SKAction.waitForDuration(2.0),SKAction.runBlock(g)]));
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
        
    }

    override func update(currentTime: CFTimeInterval){
        
        let deviceMotion = self.manager.deviceMotion;
        if((deviceMotion) != nil){
            currentRoll=deviceMotion!.attitude.roll as Double;
        }
        
        character.position = CGPointMake(self.frame.size.width/2.0+35.0*CGFloat(currentRoll), character.position.y);
        fuel.position = CGPointMake(self.frame.size.width/2.0+35.0*CGFloat(currentRoll) ,fuel.position.y)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touched");
        
        for touches: AnyObject in touches{
            
            let location = touches.locationInNode(self)
            
            if(self.nodeAtPoint(location) == play){
                
                let a = { () -> Void in
                    
                    self.title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let b = { () -> Void in
                    
                    self.play.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.play.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                
                let c = { () -> Void in
                    
                    self.store.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.store.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let d = { () -> Void in
                    
                    self.high_score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.high_score_label.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let e = { () -> Void in
                    
                    self.high_score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.high_score_label_title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                    
                }
                let f = { () -> Void in
                    
                    self.score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.score_label.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let g = { () -> Void in
                    
                    self.score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.score_label_title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let h = { () -> Void in
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "black_screen");
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        let gameScene = GameScene(fileNamed: "GameScene")!;
                        let transition = SKTransition.fadeWithDuration(1)
                        let skView = self.view as SKView!;
                        skView.ignoresSiblingOrder = true;
                        gameScene.size=skView.bounds.size;
                        gameScene.scaleMode = .AspectFill
                        skView.presentScene(gameScene, transition: transition)
                    })
                    
                }
                
                store.runAction(SKAction.runBlock(c));
                high_score_label.runAction(SKAction.runBlock(d));
                high_score_label_title.runAction(SKAction.runBlock(e));
                score_label.runAction(SKAction.runBlock(f));
                score_label_title.runAction(SKAction.runBlock(g));
                self.play.runAction(SKAction.runBlock(a));
                self.title.runAction(SKAction.runBlock(b));
                
                // SKAction.moveTo(CGPointMake(background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0)
                let title_blast = { () -> Void in
                    
                    self.background_node.runAction( SKAction.moveTo(CGPointMake(self.background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0));
                    self.black_background_node.runAction(SKAction.fadeAlphaTo(1, duration: 1));
                    
                }
                self.background_node.runAction(SKAction.sequence([SKAction.runBlock(title_blast),SKAction.waitForDuration(1.0), SKAction.runBlock(h)]))
                

            }
            if(self.nodeAtPoint(location) == store){
               
                
                let a = { () -> Void in

                    self.title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let b = { () -> Void in
                 
                    self.play.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.play.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                
                let c = { () -> Void in
 
                    self.store.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.store.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let d = { () -> Void in
    
                    self.high_score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.high_score_label.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let e = { () -> Void in
                   
                    self.high_score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.high_score_label_title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
                    
                }
                let f = { () -> Void in
           
                    self.score_label.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.score_label.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let g = { () -> Void in
                    
                    self.score_label_title.runAction(SKAction.moveBy(CGVectorMake(0, 10), duration: 0.3))
                    self.score_label_title.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                let h = { () -> Void in
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "black_screen");
                    dispatch_async(dispatch_get_main_queue(), {
                       
                    let presenting=self.view?.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("UI_Store");
                        presenting?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        UIApplication.sharedApplication().keyWindow!.rootViewController!.showViewController(presenting!, sender: nil)
                    })
                    
                }
        
                store.runAction(SKAction.runBlock(c));
                high_score_label.runAction(SKAction.runBlock(d));
                high_score_label_title.runAction(SKAction.runBlock(e));
                score_label.runAction(SKAction.runBlock(f));
                score_label_title.runAction(SKAction.runBlock(g));
                self.play.runAction(SKAction.runBlock(a));
                self.title.runAction(SKAction.runBlock(b));
                
               // SKAction.moveTo(CGPointMake(background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0)
                let title_blast = { () -> Void in
                   
                    self.background_node.runAction( SKAction.moveTo(CGPointMake(self.background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0));
                    self.black_background_node.runAction(SKAction.fadeAlphaTo(1, duration: 1));
                    
                }
                self.background_node.runAction(SKAction.sequence([SKAction.runBlock(title_blast),SKAction.waitForDuration(1.0), SKAction.runBlock(h)]))
                
                    
                
                
                
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