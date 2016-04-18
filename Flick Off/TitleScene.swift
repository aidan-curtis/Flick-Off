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
import StoreKit


class TitleScene: SKScene, SKPhysicsContactDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    
    //GAME SCENE
    //YOU CAN CHANGE THESE CONSTANTS
    let power_speed=3;
    let regular_speed=1;
    let heart_frequency=2450;
    let rocket_frequency=2600;
    let shield_frequency=1963;
    let UFO_frequency=3000;
    let MAX_HEALTH = 150
    //DO NOT EDIT BELOW
    
    var game_status:Float=0.0
    var bubble_shield_active = false;
    var current_coins=0;
    var shield_activity:Int = 0
    var UFO_Column:CGPoint=CGPointMake(-1000,0);
    var UFO = SKSpriteNode();
    var emitterNode = SKEmitterNode();
    var UFO_set = false;
    
    var laser=SKEmitterNode();
    //var backup_emitterNode = SKEmitterNode();=
    enum GameMode : Int {
        case SPACE=0,CITY,UNDERWATER,MARS
    }
    enum Objects : UInt32{
        case Meteor=100
    }
    
    let next_coin: coin_dispenser = coin_dispenser()
    var oldparticlecolor=UIColor.clearColor();
    var oldparticlesize:CGFloat=20.0;
    //labels
    let score = SKLabelNode()
    var score_number = 0;
    var gems = [SKSpriteNode]();
    let number_of_backgrounds=8;
    var backgroundNode=[SKSpriteNode]();
    var rockets=[SKSpriteNode]();
    var shields=[SKSpriteNode]();
    var action = false;
    var rocket_power=0;
    var number_of_rockets=0;
    
    var falling_objects = [SKSpriteNode]();
    var falling_objects_speeds = [CGVector]();
    
    var coins=[SKSpriteNode]()
    var coins_position_x=0
    //hearts init
    var hearts=[SKSpriteNode]()
    var permanant_hearts=[SKSpriteNode]()
    var number_of_hearts=3;
    var buy_hearts = Life();
    let life = Life();
    //let space_objects:[String] = ["meteorBrown_big1", "meteorBrown_big2", "meteorBrown_big3", "meteorBrown_big4"];
    //fix later to stramline string formatting
    let paralax=["Rain.sks", "Bubbles.sks"]
    
    let space_objects: [String] = ["a30000","a10000", "a40000","b10000", "b30000", "b40000"];
    let city_objects: [String] = ["cat", "dog"]
    let underwater_objects: [String] = ["color_fish_1","color_fish_2","color_fish_3","color_fish_4","color_fish_5"]
    let mars_objects: [String] = ["UFO1", "UFO2", "UFO3"]
    var objects = Array<Array<String>>()
    
    
    var space_actions = [SKAction]();
    var frame_counter=0;
    var moving_object=SKSpriteNode();
    var touched_location=CGPoint();
    var isTouching=false;
    var character = SKSpriteNode();
    var shield_follow = Shield();
    var bubble_shield = BubbleShield();
    var fuel = SKEmitterNode();
    
    
    var game_mode=GameMode.SPACE.rawValue
    
    var coin_alternator=false;
    var spinning_asteroid = SKAction();
    let manager = CMMotionManager();
    var currentRoll = Double();
    
    var explosion = [SKTexture]()
    var menu = SKSpriteNode();
    
    let life_bar=SKSpriteNode();
    let shield_bar=SKSpriteNode();
    var health_cover=SKSpriteNode();
    var shield_cover=SKSpriteNode();
    
    var health_number = 150;
    
    
    var coin_cover=SKSpriteNode();
    var coin_image = SKSpriteNode();
    var coin_label = SKLabelNode();
    
    var gem_cover=SKSpriteNode();
    var gem_image = SKSpriteNode();
    var gem_label = SKLabelNode();
    
    var tutorial_status:Float = 0.0;
    var tutorial_cover = SKSpriteNode();
    var tutorial_cover_complete = SKSpriteNode();
    func presentMenu(){
        menu.size=CGSizeMake(200, 100)
        menu.color=UIColor.redColor()
    }
    
    
    func game_scene_begin() {
        
        
        print("starting setup")
        tutorial_status=NSUserDefaults.standardUserDefaults().floatForKey("tutorial_status");
        //tutorial_status=12;
        
        tutorial_cover.texture = SKTexture(imageNamed: "Tilt_to_move");
        tutorial_cover.size = CGSizeMake(100, 100);
        tutorial_cover.position = CGPointMake(self.size.width/2, self.size.height/2);
        tutorial_cover.zPosition = 10000
        tutorial_cover.alpha = 0;
        tutorial_cover.userInteractionEnabled=false;
        self.addChild(tutorial_cover)
        
        tutorial_cover_complete.texture = SKTexture(imageNamed: "complete_tutorial");
        tutorial_cover_complete.size = CGSizeMake(100, 100);
        tutorial_cover_complete.position = CGPointMake(self.size.width/2, self.size.height/2);
        tutorial_cover_complete.zPosition = 9999
        tutorial_cover_complete.alpha = 0;
        tutorial_cover_complete.userInteractionEnabled=false;
        self.addChild(tutorial_cover_complete)
        
        
        life.setup(self.size);
        life.position = CGPointMake(self.size.width/2.0, -300);
        
        buy_hearts.setup(self.size);
        buy_hearts.position = CGPointMake(self.size.width/2.0, -300);
        buy_hearts.texture = SKTexture(imageNamed: "Life_buy");
        buy_hearts.zPosition=10002;
        addChild(buy_hearts);
        addChild(life);
        
        //initial blast

        
        current_coins = NSUserDefaults.standardUserDefaults().integerForKey("coins");
        
        shield_follow.setup(CGSizeMake(120,107))
        
        self.physicsWorld.contactDelegate = self
        for(var i=0; i<34; i+=1){
            explosion.append(SKTexture(imageNamed: "explosion_\(i+1)"))
        }
        health_cover.position = CGPointMake(10, 18);
        health_cover.size = CGSizeMake(27,27);
        health_cover.texture = SKTexture(imageNamed: "Health_badge")
        
        addChild(health_cover);
        
        shield_cover.position = CGPointMake(10, 40);
        shield_cover.size = CGSizeMake(27,27);
        shield_cover.texture = SKTexture(imageNamed: "Shield_Badge")
        shield_cover.hidden=true;
        
        addChild(shield_cover);
        
        coin_cover.position = CGPointMake(self.size.width-50, 18);
        coin_cover.size = CGSizeMake(1, 1);
        coin_cover.texture = SKTexture(imageNamed: "coin_cover");
        
        addChild(coin_cover);
//
//        
        
        coin_image.position = CGPointMake(self.size.width+20, 18);
        coin_image.size = CGSizeMake(1 ,1)
        var coin_textures=[SKTexture]()
        for (var i=0; i<8; i=i+1){
            let name="spinning_coin_gold_"+(i+1 as NSNumber).stringValue
            coin_textures.append(SKTexture(imageNamed: name))
        }
        coin_image.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(coin_textures, timePerFrame: 0.1)))
        
        addChild(coin_image);
        
        coin_label.position = CGPointMake(self.size.width-30, 11);
        coin_label.fontName="04b_19"
        coin_label.fontSize=15
        coin_label.fontColor=UIColor.yellowColor()
        coin_label.text="\(current_coins)"
        coin_label.hidden=true;
        addChild(coin_label);
        
//
//        
//        
        
        //Coin repeat for gem popup
        
        
        gem_cover.position = CGPointMake(self.size.width-50, 18);
        gem_cover.size = CGSizeMake(1, 1);
        gem_cover.texture = SKTexture(imageNamed: "gem_cover");
        
        addChild(gem_cover);
        
        
        
        gem_image.position = CGPointMake(self.size.width+20, 18);
        gem_image.size = CGSizeMake(1 ,1)
        var gem_textures=[SKTexture]()
        for (var i=7; i<=103; i=i+8){
            let name="Gem v"+(i as NSNumber).stringValue
            gem_textures.append(SKTexture(imageNamed: name))
        }
        gem_image.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(gem_textures, timePerFrame: 0.1)))
        
        addChild(gem_image);
        
        gem_label.position = CGPointMake(self.size.width-30, 11);
        gem_label.fontName="04b_19"
        gem_label.fontSize=15
        gem_label.fontColor=UIColor.magentaColor()
        gem_label.text="\(current_coins)"
        gem_label.hidden=true;
        addChild(gem_label);

        //present menu at beginning and after death
        presentMenu()
        
        //addGem(CGPointMake(200, 200))
        
        //setting score label
        score.position = CGPointMake(30, self.size.height-30)
        score.fontName = "04b_19"
        score.fontSize = 30
        score.text = "0"
        addChild(score)
        
        game_starting_values()
        shield_bar.hidden=true;
        addChild(shield_bar)
        addChild(life_bar)
        self.life_bar.size = CGSizeMake(1, 14);
        self.shield_bar.size = CGSizeMake(1, 14);
        
        objects=[space_objects, city_objects,underwater_objects, mars_objects]
        self.physicsWorld.gravity=CGVectorMake(0, 0);
//
//      
//        
//        
//        
//        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()

        
        if(NSUserDefaults.standardUserDefaults().objectForKey("ship") == nil){
            NSUserDefaults.standardUserDefaults().setObject("playerShip1_green.png", forKey: "ship")
            
        }

        
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("shield")>0){
            bubble_shield_active=true;
            bubble_shield.setup(CGSizeMake(100, 90));
            bubble_shield.position = CGPointMake(3*self.size.width/5, 4*self.size.height/24);
            addChild(bubble_shield);
            NSUserDefaults.standardUserDefaults().setInteger(NSUserDefaults.standardUserDefaults().integerForKey("shield")-1, forKey: "shield");
        }
        shield_follow.position = CGPointMake(3*self.size.width/5-3, 4*self.size.height/24+3);
        shield_follow.size = CGSizeMake(120, 107);
        addChild(shield_follow);
        shield_follow.hidden=true;
        
        //fuel = SKEmitterNode(fileNamed: "MyParticle.sks")!
        //fuel.position=CGPointMake(3*self.size.width/5, (4*self.size.height/24)-15);
    
        fuel.targetNode=self;
        fuel.removeFromParent()
        oldparticlecolor=fuel.particleColor;
        oldparticlesize=fuel.particleScale;
        
        
        
        
        
        let initial_rocket = NSUserDefaults.standardUserDefaults().integerForKey("blast")
        if(initial_rocket>0){
            blastOff(500);
        }

        
        emitterNode=starfieldEmitter(SKColor.grayColor(), starSpeedY: 150, starsPerSecond: 20, starScaleFactor: 0.1,backup: false)
        emitterNode.zPosition = -9
        self.addChild(emitterNode)
        emitterNode.paused=true

        
        game_starting_values()
        frame_counter=0
        game_status=1
        print("ending setup");
    }
    func didBeginContact(contact: SKPhysicsContact) {
        var velocity1 = CGVector(), velocity2=CGVector();
        var location1 = CGPoint(), location2=CGPoint();
        var node1=SKSpriteNode(), node2=SKSpriteNode()
        for node: SKSpriteNode in falling_objects{
            if(node.physicsBody==contact.bodyA){
                
                velocity1=(node.physicsBody?.velocity)!
                location1=node.position;
                node1=node;
            }
            if(node.physicsBody==contact.bodyB){
                
                velocity2=(node.physicsBody?.velocity)!
                location2=node.position;
                node2=node;
            }
        }
        let power = pow(pow(velocity1.dx,2)+pow(velocity1.dy,2),0.5)+pow(pow(velocity2.dx,2)+pow(velocity2.dy,2),0.5) ;
        if(power>700){
            if(arc4random_uniform(4)==0){
                if(tutorial_status>4){
                    addGem(node1.position)
                }
            }
            
            node1.removeFromParent()
            node2.removeFromParent()
            
            falling_objects.removeAtIndex(falling_objects.indexOf(node1)!)
            falling_objects.removeAtIndex(falling_objects.indexOf(node2)!)
            explode(CGSizeMake(power/15.0, power/15.0), location: CGPointMake((location1.x+location2.x)/2, (location1.y+location2.y)/2), speed: 0.01, explosion_color: "gray")
            if(tutorial_status<=3){
                tutorial_status+=1;
            }
        }
    }
    func game_starting_values(){
        setStaticHearts(MAX_HEALTH)
        setShieldBar(MAX_HEALTH)
        
        number_of_rockets=0;
        rocketIter(number_of_rockets);
        for coin: SKSpriteNode in coins{
            coin.removeFromParent()
        }
        coins.removeAll()
        for falling_object: SKSpriteNode in falling_objects{
            falling_object.removeFromParent()
        }
        falling_objects.removeAll()
        
        for heart: SKSpriteNode in hearts{
            heart.removeFromParent()
        }
        hearts.removeAll()
        UFO.removeFromParent()
        laser.removeFromParent()
        UFO_Column=CGPointMake(-1000, 0);
        for rocket: SKSpriteNode in rockets{
            rocket.removeFromParent()
        }
        rockets.removeAll()
        for shield: SKSpriteNode in shields{
            shield.removeFromParent()
        }
        shields.removeAll()
        
        
    }
    func addFallingObject(speed : Int){
        let falling_object = SKSpriteNode();
        let num = Int(arc4random_uniform(UInt32(objects[game_mode].count)));
        NSLog("%i", num);
        falling_object.zPosition=1000
        //falling_object.runAction(SKAction.repeatActionForever(space_actions[1]));
        falling_object.texture=SKTexture(imageNamed: objects[game_mode][num]);
        var temp_position:CGPoint=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width))),self.size.height+25);
        while(temp_position.x>UFO_Column.x-70 && temp_position.x<UFO_Column.x+70){
            temp_position=CGPointMake( CGFloat(arc4random_uniform(UInt32(self.size.width))),self.size.height+25);
        }
        
        falling_object.position = temp_position;
        falling_object.zRotation = CGFloat(3*M_PI/2)
        if(game_mode==GameMode.SPACE.rawValue){
            falling_object.size = CGSizeMake(100, 100);
        }
        else if(game_mode==GameMode.UNDERWATER.rawValue){
            falling_object.size = CGSizeMake(100, 55);
        }
        
        
        //        if(arc4random_uniform(UInt32(11))==10){
        //            falling_object.name="purple"
        //            //add emitter_node
        //            let emitterNode = SKEmitterNode(fileNamed: "Magic")!
        //            emitterNode.zPosition = -11
        //            emitterNode.position = CGPointMake(0, 0)
        //            emitterNode.targetNode=self
        //            falling_object.addChild(emitterNode)
        //        }
        //        else if(arc4random_uniform(UInt32(11))==10){
        //            falling_object.name="blue"
        //            //add emitter_node
        //            let emitterNode = SKEmitterNode(fileNamed: "Magic2")!
        //
        //            emitterNode.zPosition = -11
        //            emitterNode.position = CGPointMake(0, 0)
        //            emitterNode.targetNode=self
        //            falling_object.addChild(emitterNode)
        //        }
        
        //add physics body
        
        falling_object.physicsBody=SKPhysicsBody(circleOfRadius: falling_object.size.width/4);
        falling_object.physicsBody!.dynamic=true;
        falling_object.physicsBody!.allowsRotation=true;
        falling_object.physicsBody!.categoryBitMask = Objects.Meteor.rawValue
        falling_object.physicsBody!.usesPreciseCollisionDetection=true;
        falling_object.physicsBody!.contactTestBitMask = Objects.Meteor.rawValue
        
        
        
        
        if(rocket_power<=0){
            falling_object.physicsBody!.velocity=CGVectorMake(0, CGFloat(speed));
        }
        else{
            falling_object.physicsBody!.velocity=CGVectorMake(0, CGFloat(power_speed*speed));
        }
        if(!(GameMode.UNDERWATER.rawValue==game_mode)){
            falling_object.physicsBody!.angularVelocity=CGFloat(arc4random_uniform(4));
        }
        falling_object.physicsBody!.friction=100;
        falling_objects.append(falling_object);
        
        addChild(falling_object);
        
        
    }
    func explode(size: CGSize, location: CGPoint, speed: Double, explosion_color: String){
        var explosion_node=SKEmitterNode();
        if(explosion_color=="blue"){
            explosion_node=SKEmitterNode(fileNamed: "Blue_Explosion.sks")!;
        }
        else if(explosion_color=="gray"){
            explosion_node=SKEmitterNode(fileNamed: "Gray_Explosion.sks")!;
        }
        else{
            explosion_node=SKEmitterNode(fileNamed: "Fire_Explosion.sks")!;
        }
        
        explosion_node.position=location;
        explosion_node.zPosition=5000;
        explosion_node.particleAlpha=1
        explosion_node.targetNode=self;
        
        explosion_node.particleSpeed=CGFloat(Int(explosion_node.particleSpeed)*Int(size.width)/90)
        addChild(explosion_node);
        
        //        let explosion_node = SKSpriteNode()
        //        explosion_node.size = size
        //        explosion_node.position = location
        //        explosion_node.zPosition = 50
        //        explosion_node.runAction(SKAction.animateWithTextures(explosion, timePerFrame: speed), completion:{explosion_node.removeFromParent()})
        //        addChild(explosion_node)
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
        
        if(backup){
            
            emitterNode.advanceSimulationTime(NSTimeInterval(lifetime))
        }
        
        return emitterNode
    }
    func setStaticHearts(num : Int){
        life_bar.runAction(SKAction.scaleXTo(CGFloat(num+10), y: 1, duration: 0.2));
        
   
        life_bar.color=UIColor.redColor()
        
        life_bar.position=CGPointMake(CGFloat((num+10)/2)+3, 18)
    }
    func setShieldBar(num : Int){
        shield_bar.runAction(SKAction.scaleXTo(CGFloat(num+10), y: 1, duration: 0.2));
        
        if(num<=0){
            shield_bar.hidden=true;
        }
        shield_bar.size=CGSizeMake(CGFloat((num+10))+4, 14);
        shield_bar.color=UIColor.blueColor()
        
        shield_bar.position=CGPointMake(CGFloat((num+10)/2)+4, 40)
    }
    
    func addGem(location:CGPoint){
        let gem = SKSpriteNode()
        gem.size = CGSizeMake(50, 40)
        gem.position=location
        var gem_textures = [SKTexture]()
        for(var i = 7; i<106; i+=8){
            
            gem_textures.append(SKTexture(imageNamed: "Gem v\(i)"))
        }
        gem.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(gem_textures, timePerFrame: 0.1)))
        
        addChild(gem)
        gems.append(gem)
        
    }
    func addCoin(){
        let coin = SKSpriteNode()
        if(arc4random_uniform(20)==0){
            if(coin_alternator==true){
                let mode=Int(arc4random_uniform(3))
                next_coin.begin_action(mode, starting_location: Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
                next_coin.setAlternate(Int(arc4random_uniform(UInt32(self.size.width)-40)+20))
                next_coin.setWidth(Int(arc4random_uniform(15))+10)
                next_coin.power(Int(arc4random_uniform(2)))
                coin_alternator=false;
            }
            else{
                coin_alternator=true;
            }
        }
        if(coin_alternator==true){
            coins_position_x=next_coin.fetch_next_coin()
            if(next_coin.status==1){
                //coin.texture=SKTexture(imageNamed:"spinning_coin_gold_1")
                var coin_textures=[SKTexture]()
                for (var i=0; i<8; i=i+1){
                    let name="spinning_coin_gold_"+(i+1 as NSNumber).stringValue
                    coin_textures.append(SKTexture(imageNamed: name))
                }
                coin.runAction(SKAction.repeatActionForever( SKAction.animateWithTextures(coin_textures, timePerFrame: 0.1)))
                coin.position=CGPointMake(CGFloat(coins_position_x), self.size.height+25)
                coin.size=CGSizeMake(30, 30);
                addChild(coin)
                coins.append(coin)
            }
        }
    }
    
   
    func continueGame(){
        dispatch_async(dispatch_get_main_queue()) {
            self.life.runAction(SKAction.moveToY(-500, duration: 0.3));
        }
        
        for falling_object: SKSpriteNode in falling_objects{
            
            falling_object.physicsBody!.dynamic=true;
            falling_object.physicsBody!.velocity = falling_objects_speeds[falling_objects.indexOf(falling_object)!] as CGVector
        }
        setStaticHearts(MAX_HEALTH);
        game_status=2;
    }
    var static_rockets=[Rocket]();
    func rocketIter(number: Int){
        for rocket: Rocket in static_rockets{
            rocket.removeFromParent()
        }
        static_rockets.removeAll();
        var rocket_temp=Rocket();
        for (var i=0; i<number; i+=1){
            rocket_temp=Rocket();
            rocket_temp.setup(CGSizeMake(30, 30));
            rocket_temp.position=CGPointMake(CGFloat(Int(self.size.width)-(20*i+20)), CGFloat(Int(self.size.height)-(30)))
            static_rockets.append(rocket_temp);
        }
        for rocket: Rocket in static_rockets{
            addChild(rocket);
        }
        
        
    }
    func blastOff(power: Int){
        shield_follow.hidden=true;
        rocket_power=power;
        shield_follow.physicsBody=SKPhysicsBody(circleOfRadius: 50);
        shield_follow.physicsBody!.dynamic=false;
        fuel.particleColorSequence = nil;
        fuel.particleColorBlendFactor = 0.9;
        fuel.particleColor = SKColor.blueColor();
        fuel.particleScale=fuel.particleScale*2
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moving_object.runAction(SKAction.rotateToAngle(atan2(CGFloat((touched_location.y - moving_object.position.y)),CGFloat((touched_location.x - moving_object.position.x))), duration: 0.01))
        for touches: AnyObject in touches{
            touched_location = touches.locationInNode(self)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching=false
    }
    var last_coin_submit=0;
    var last_gem_submit=0;
    func update_game() {
        //emitterNode.paused=false;
        
       

        last_coin_submit-=1;
        last_gem_submit-=1;
        if (last_coin_submit<=0){
            self.coin_cover.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.coin_cover.runAction(SKAction.scaleYTo(1, duration: 0.1));
            self.coin_image.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.coin_image.runAction(SKAction.scaleYTo(1, duration: 0.1));
            coin_label.hidden=true;
            self.coin_image.runAction(SKAction.moveToX(self.size.width+25, duration: 0.1))
        }
        if( last_coin_submit == 40){
            self.coin_label.hidden=false
        }
        //same for gem
        if (last_gem_submit<=0){
            self.gem_cover.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.gem_cover.runAction(SKAction.scaleYTo(1, duration: 0.1));
            self.gem_image.runAction(SKAction.scaleXTo(1, duration: 0.1));
            self.gem_image.runAction(SKAction.scaleYTo(1, duration: 0.1));
            gem_label.hidden=true;
            self.gem_image.runAction(SKAction.moveToX(self.size.width+25, duration: 0.1))
        }
        if( last_gem_submit == 40){
            self.gem_label.hidden=false
        }
        
        
        coin_label.text="\(current_coins)"
        gem_label.text="\(NSUserDefaults.standardUserDefaults().integerForKey("gems"))"
        
        rocket_power-=1;
        //        if(shield_power==0){
        //            shield_follow.removeFromParent()
        //            shield_follow=Shield();
        //            shield_follow.setup(CGSizeMake(120, 107))
        //            shield_follow.position = CGPointMake(character.position.x-3, character.position.y+3);
        //            addChild(shield_follow);
        //            shield_follow.hidden=true;
        //            shield_bar.hidden=true;
        //        }
        
        
        if(rocket_power==0){
            shield_follow.removeFromParent()
            shield_follow=Shield();
            shield_follow.position = CGPointMake(character.position.x-3, character.position.y+3);
            shield_follow.setup(CGSizeMake(120, 107))
            shield_follow.hidden = true;
            addChild(shield_follow);
            //shield_follow.hidden=true;
            fuel.particleColor=oldparticlecolor;
            fuel.particleColorBlendFactor=1
            fuel.particleScale=fuel.particleScale*0.5
            
        }
        //improve shield power
        //score_label.text = "\(Int(score_label.text!)!+1)"

        if(game_status==1 || game_status == 0){
            
   
            addChild(fuel)
            score.text="0"
            score_number=0;
            //backup_emitterNode.hidden=true
            emitterNode.resetSimulation()
            emitterNode.hidden=false
            emitterNode.paused=false
            game_status=2
        }
        if(game_status==2){
    
            var lambda:CGFloat = 2.0;
            if(rocket_power<=0){
                lambda = 1.0
            }
            
                //tutorial home base
                if(tutorial_status<=1){
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    //tilt
                }
                else if(tutorial_status<=2){
                    //complete
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=3){
                    tutorial_cover.texture = SKTexture(imageNamed: "Tutorial_Cover_smash")
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    //complete
                }
                else if(tutorial_status<=4){
                    //Collect Coins to use in store
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=5){
                    //Hit the UFO to avoid trouble
                    tutorial_cover.texture = SKTexture(imageNamed: "Powerup_tutorial")
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                else if(tutorial_status<=6){
                    //Collect Coins to use in store
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=7){
                    //Hit the UFO to avoid trouble
                    tutorial_cover.texture = SKTexture(imageNamed: "Coins_tutorial")
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                else if(tutorial_status<=8){
                    //Collect Coins to use in store
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=9){
                    //Hit the UFO to avoid trouble
                    tutorial_cover.texture = SKTexture(imageNamed: "UFO_tutorial")
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                }
                else if(tutorial_status<=10){
                    //Collect Coins to use in store
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=11){
                    //Collect Coins to use in store
                    tutorial_cover.texture = SKTexture(imageNamed: "Start_Flicking")
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(1, duration: 0.3));
                    tutorial_cover_complete.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    tutorial_status += 0.005;
                }
                else if(tutorial_status<=12){
                    tutorial_cover.runAction(SKAction.fadeAlphaTo(0, duration: 0.3));
                    NSUserDefaults.standardUserDefaults().setFloat(tutorial_status, forKey: "tutorial_status");
                }
                
                
                
                
                if(UFO_set==true && character.position.x>UFO_Column.x-50 && character.position.x<UFO_Column.x+50){
                    explode(CGSizeMake(50, 50), location: character.position, speed: 0.02, explosion_color: "blue");
                    laser.removeFromParent()
                    health_number=0;
                    
                    life_bar.size.width = -1;
                    shield_bar.size.width = -1;
                }
                //UFO Special
                if(UFO_Column.x == -1000){
                    if((arc4random_uniform(UInt32(UFO_frequency))==0 && tutorial_status > 8) || (tutorial_status>8 && tutorial_status<=9)){
                        var texture_list=[SKTexture]();
                        for(var i=1; i<=12; i+=1){
                            texture_list.append(SKTexture(imageNamed: "UFO_\(i)"))
                            
                        }
                        UFO.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(texture_list, timePerFrame: 0.02)));
                        UFO.size=CGSizeMake(106,62);
                        UFO.zPosition = 1000000;
                        
                        UFO.physicsBody=SKPhysicsBody(circleOfRadius: UFO.size.width/4);
                        UFO.physicsBody!.dynamic=false;
                        UFO.physicsBody!.allowsRotation=false;
                        UFO.physicsBody!.categoryBitMask = Objects.Meteor.rawValue
                        UFO.physicsBody!.usesPreciseCollisionDetection=true;
                        UFO.physicsBody!.contactTestBitMask = Objects.Meteor.rawValue
                        
                        
                        UFO.position=CGPointMake(0,self.size.height*3/4);
                        let destination_point=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width-200))+100),self.size.height*3/4);
                        UFO_Column=destination_point;
                        UFO.runAction(SKAction.moveTo(destination_point, duration: 1));
                        
                        //laser
                        laser=SKEmitterNode(fileNamed: "Laser.sks")!;
                        laser.particleBirthRate=0
                        laser.targetNode=self;
                        laser.position=CGPointMake(destination_point.x, destination_point.y-30);
                        laser.runAction(
                            SKAction.sequence([
                                SKAction.waitForDuration(1),
                                SKAction.repeatAction(
                                    SKAction.sequence([
                                        SKAction.runBlock({ () -> Void in
                                            self.laser.particleBirthRate=1934
                                            self.laser.particlePositionRange=CGVectorMake(self.laser.particlePositionRange.dx, self.laser.particlePositionRange.dy+10)
                                            self.laser.position=CGPointMake(self.laser.position.x, self.laser.position.y-5);
                                        }), SKAction.waitForDuration(0.025)])
                                    , count: 50), SKAction.runBlock({ () -> Void in
                                        self.UFO_set=true;
                                    })]) );
                        
                        addChild(laser)
                        addChild(UFO)
                    }
                }
                //end UFO special
                
                emitterNode.paused=false
                if(tutorial_status>=11){
                    for(var i=0; i<number_of_backgrounds; i+=1){
                        backgroundNode[i].position = CGPointMake(self.size.width/2, backgroundNode[i].position.y-lambda)
                    }
                }
                if(health_number<=0){
            
                    game_status=3
                }
                
                if(frame_counter%5==0){
                    if(tutorial_status>=11){
                        if(rocket_power<=0){
                            score_number+=1;
                            
                        }
                        else{
                            score_number+=power_speed;
                        }
                        score.text = "\(score_number)"
                    }
                }
                if(arc4random_uniform(UInt32(shield_frequency))==0  && coin_alternator==false){
                    if(tutorial_status>4){
                        let shield=Shield();
                        shield.setup(CGSizeMake(60, 50))
                        shield.position=CGPointMake(CGFloat(arc4random_uniform(UInt32 (self.size.width))),self.size.height);
                        addChild(shield)
                        shields.append(shield);
                    }
                }
                
                if(isTouching){
                    //let force_vector = CGVectorMake(3*(touched_location.x - moving_object.position.x) , 3*(touched_location.y - moving_object.position.y))
                    let velocity_vector = CGVectorMake(15*(touched_location.x - moving_object.position.x), 15*(touched_location.y - moving_object.position.y))
                    moving_object.physicsBody?.velocity=velocity_vector
                }
                
                frame_counter+=1;
                
                let deviceMotion = self.manager.deviceMotion;
                if((deviceMotion) != nil){
                    currentRoll=deviceMotion!.attitude.roll as Double;
                }
                
                if(character.position.x<0){
                    character.position.x=self.size.width;
                    fuel.position.x=self.size.width;
                }
                
                if(character.position.x>self.size.width){
                    character.position.x=0;
                    fuel.position.x=0;
                }
                
                shield_follow.position=CGPointMake(character.position.x-3, character.position.y+3);
                bubble_shield.position=CGPointMake(character.position.x, character.position.y);
                if(tutorial_status<1){
               
                    tutorial_status+=abs(Float(currentRoll)/50)
                   
                }
                character.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
                fuel.runAction(SKAction.moveBy(CGVectorMake(CGFloat(10.0*currentRoll),0), duration: 0.10));
                
                //add coins
                if(tutorial_status>6.0){
                    if(rocket_power>=0){
                        if(frame_counter%(Int(7/power_speed)+1)==0){
                            addCoin();
                        }
                    }
                    else{
                        if(frame_counter%7==0){
                            addCoin();
                        }
                    }
                }
                for shield: SKSpriteNode in shields{
                    shield.position=CGPointMake(shield.position.x, shield.position.y-5)
                    if(CGRectIntersectsRect(shield.frame,character.frame)){
                        if(tutorial_status<5){
                            tutorial_status+=1
                        }
                        //shield_power=500;
                        //shield_follow.physicsBody=SKPhysicsBody(circleOfRadius: 50);
                        //shield_follow.physicsBody!.dynamic=false;
                        shield_follow.hidden=false;
                        shield_cover.hidden=false;
                        setShieldBar(MAX_HEALTH)
                        shield_bar.hidden=false;
                        shield.removeFromParent()
                        shields.removeAtIndex(shields.indexOf(shield)!)
                        
                    }
                }
                for rocket: SKSpriteNode in rockets{
                    rocket.position=CGPointMake(rocket.position.x, rocket.position.y-5)
                    if(CGRectIntersectsRect(rocket.frame,character.frame)){
                        if(tutorial_status<5){
                            tutorial_status+=1;
                        }
                        number_of_rockets+=1;
                        rocketIter(number_of_rockets);
                        rockets.removeAtIndex(rockets.indexOf(rocket)!)
                        rocket.removeFromParent()
                        
                    }
                }
                //move hearts
                for heart: SKSpriteNode in hearts{
                    heart.position=CGPointMake(heart.position.x, heart.position.y-5)
                    if(CGRectIntersectsRect(heart.frame,character.frame)){
                        if(tutorial_status<5){
                            tutorial_status+=1;
                        }
                        health_number += 50;
                        setStaticHearts(Int(CGFloat(health_number)+CGFloat(50.0)))
                        if(CGFloat(health_number)>CGFloat(MAX_HEALTH)){
                            setStaticHearts(MAX_HEALTH)
                        }
                        hearts.removeAtIndex(hearts.indexOf(heart)!)
                        heart.removeFromParent()
                        
                    }
                }
                for gem: SKSpriteNode in gems{
                    gem.position=CGPointMake(gem.position.x, gem.position.y-5)
                    if(CGRectIntersectsRect(gem.frame,character.frame)){
                        let number_of_gems = NSUserDefaults.standardUserDefaults().integerForKey("gems") ;
                        NSUserDefaults.standardUserDefaults().setInteger(Int(CGFloat(number_of_gems)+1.0), forKey: "gems")
                        
                        let a = { () -> Void in
                            if(self.last_coin_submit<=0){
                                self.gem_label.hidden=false;
                                self.gem_cover.runAction(SKAction.scaleXTo(100, duration: 0.1));
                                self.gem_cover.runAction(SKAction.scaleYTo(40, duration: 0.1));
                                self.gem_image.runAction(SKAction.scaleXTo(20, duration: 0.1));
                                self.gem_image.runAction(SKAction.scaleYTo(20, duration: 0.1));
                                self.last_gem_submit=50;
                            }
                            self.gem_image.runAction(SKAction.moveToX(self.size.width-75, duration: 0.1))
                            gem.removeFromParent()
                            
                            //coin.runAction(SKAction.scaleTo(CGFloat(0), duration: 0.5), completion: b)
                        }
                        
                 
                            if(tutorial_status<5){
                                tutorial_status+=1;
                            }
                            gem.runAction(SKAction.runBlock(a))
                            gems.removeAtIndex(gems.indexOf(gem)!);
                        
                    }
                    
                }
                //falling objects enumerate
                
                for falling: SKSpriteNode in falling_objects{
                    //bubble shield
                    
                    if(rocket_power==199){
                        falling.physicsBody!.velocity=CGVector(dx: CGFloat((falling.physicsBody?.velocity.dx)!)*CGFloat(power_speed), dy: CGFloat((falling.physicsBody?.velocity.dy)!)*CGFloat(power_speed));
                    }
                    if(rocket_power==0){
                        falling.physicsBody!.velocity=CGVector(dx: CGFloat((falling.physicsBody?.velocity.dx)!)*CGFloat(1.0/Double(power_speed)), dy: CGFloat((falling.physicsBody?.velocity.dy)!)*CGFloat(1.0/Double(power_speed)));
                        falling.speed*=0.2;
                        
                    }
                    let shrinkx:CGFloat=character.frame.width/2, shrinkx_m=character.frame.width/2
                    let shrinky:CGFloat=character.frame.height/2, shrinky_m=character.frame.height/2
                    if(CGRectIntersectsRect(CGRectMake(falling.frame.origin.x+shrinkx_m, falling.frame.origin.y+shrinky_m, 70, 70), CGRectMake(character.frame.origin.x+shrinkx, character.frame.origin.y+shrinky, 1, 1))){
                        if(bubble_shield_active){
                            
                            bubble_shield.removeFromParent();
                            self.explode(CGSizeMake(40, 40), location: falling.position, speed: 0.02, explosion_color: "gray")
                            falling.removeFromParent()
                            
                            //falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                            bubble_shield_active = false;
                        }
                        else{
                            
                            var explosion_size = 0.1*pow(pow((falling.physicsBody?.velocity.dx)!, 2)+pow((falling.physicsBody?.velocity.dy)!, 2), 0.5)
                            if(explosion_size < 60){
                                explosion_size = 60
                            }
                            if(shield_follow.hidden==true){
                                if(tutorial_status>=12){
                                self.explode(CGSizeMake(explosion_size, explosion_size), location: CGPointMake((character.position.x+falling.position.x)/2, (character.position.y+falling.position.y)/2), speed: (0.02), explosion_color: "red")
                                health_number = health_number - Int(explosion_size);
                                setStaticHearts(health_number - Int(explosion_size))
                                }
                            }
                            else{
                                
                                self.explode(CGSizeMake(explosion_size, explosion_size), location: CGPointMake((character.position.x+falling.position.x)/2, (character.position.y+falling.position.y)/2), speed: (0.02), explosion_color: "gray")
                                let change_shield=shield_bar.size.width-explosion_size
                                setShieldBar(Int(change_shield))
                                if(change_shield<0){
                                    shield_cover.hidden=true;
                                    shield_bar.hidden=true;
                                    shield_follow.hidden=true;
                                }
                            }
                        }
                        falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                        
                        
                        falling.removeFromParent()
                        
                        
                        
                    }
                    if(UFO_set==true){
                 
                        
                     
                        //UFO.anchorPoint=CGPoint(x: 0.0,y: 0.0);
                        
                        if(CGRectIntersectsRect(
                            CGRectMake(falling.position.x, falling.position.y, falling.size.width, falling.size.height), CGRectMake(UFO.position.x, UFO.position.y, UFO.size.width, UFO.size.height)
                            )){
                             print("power_value: \(CGFloat(sqrt(pow((falling.physicsBody?.velocity.dx)!,2)+pow((falling.physicsBody?.velocity.dy)!,2))))")
                            if(sqrt(pow((falling.physicsBody?.velocity.dx)!,2)+pow((falling.physicsBody?.velocity.dy)!,2))>=700 ){
                                explode(CGSizeMake(100, 100), location: UFO.position, speed: 0.02, explosion_color: "blue");
                                explode(CGSizeMake(100, 100), location: falling.position, speed: 0.02, explosion_color: "gray");
                     
                                falling.removeFromParent()
                                
                                tutorial_status+=1;
                                UFO.removeFromParent();
                                laser.removeFromParent()
                                UFO=SKSpriteNode();
                                UFO_Column=CGPointMake(-1000, 0);
                                UFO_set=false;
                            }
                            
                            
                            
                            
                            
                        }
                        //UFO.anchorPoint=CGPoint(x: 0.5,y: 0.5);
                    }
                    if(falling.position.y<character.position.y-character.size.height*2){
                        falling_objects.removeAtIndex(falling_objects.indexOf(falling)!)
                        falling.removeFromParent()
                    }
                    
                }
                
                //blast off
                if(number_of_rockets==3){
                    number_of_rockets=0 ;
                    rocketIter(number_of_rockets);
                    blastOff(200);
                }
                
                //move coins
                for coin: SKSpriteNode in coins{
                    if(CGRectIntersectsRect(coin.frame,character.frame)){
                        if(tutorial_status<=7){
                            tutorial_status+=1;
                        }
                        current_coins+=1;
                        
                        
                        let b = { () -> Void in
                            coin.removeFromParent()
                        }
                        let a = { () -> Void in
                            self.coin_label.hidden=false;
                            coin.runAction(SKAction.moveTo(CGPointMake(self.size.width,0), duration: 0.5), completion: b)
                            if(self.last_gem_submit<=0){
                                self.coin_cover.runAction(SKAction.scaleXTo(100, duration: 0.1));
                                self.coin_cover.runAction(SKAction.scaleYTo(40, duration: 0.1));
                                self.coin_image.runAction(SKAction.scaleXTo(20, duration: 0.1));
                                self.coin_image.runAction(SKAction.scaleYTo(20, duration: 0.1));
                                self.last_coin_submit=50;
                            }
                            self.coin_image.runAction(SKAction.moveToX(self.size.width-75, duration: 0.1))
                            
                            
                            //coin.runAction(SKAction.scaleTo(CGFloat(0), duration: 0.5), completion: b)
                        }
                        coin.runAction(SKAction.runBlock(a))
                    }
                    if(rocket_power>0){
                        coin.position=CGPointMake(coin.position.x, coin.position.y-CGFloat(5*power_speed))
                    }
                    else{
                        coin.position=CGPointMake(coin.position.x, coin.position.y-CGFloat(5))
                    }
                    if(coin.position.y<character.position.y-character.size.height*2){
                        coins.removeAtIndex(coins.indexOf(coin)!)
                        coin.removeFromParent()
                    }
                }
                
                //adding heart nodes
                if(arc4random_uniform(UInt32(heart_frequency))==0 && coin_alternator==false){
                    if(tutorial_status>4){
                        let heart = Heart();
                        heart.setup(30, parentsize: self.size)
                        addChild(heart)
                        hearts.append(heart);
                    }
                }
                
                if(arc4random_uniform(UInt32(rocket_frequency))==0 && coin_alternator==false){
                    if(tutorial_status>4){
                        let rocket = Rocket();
                        rocket.setup(CGSizeMake(60, 60));
                        
                        rocket.position=CGPointMake(CGFloat(arc4random_uniform(UInt32(self.size.width))), self.size.height)
                        addChild(rocket);
                        rockets.append(rocket);
                    }
                }
                //add falling objects
                var object_sequence = 50-frame_counter/200
                if(object_sequence<5){
                    object_sequence = 5
                }
                let object_speed = -300-frame_counter/50
                
                if(frame_counter%(object_sequence)==0 && !(frame_counter%600==0)){
                    if(tutorial_status>=2){
                        addFallingObject(object_speed);
                    }
                }
            }
        
        else if (game_status==3){
            
            
            life.runAction(SKAction.moveToY(self.size.height/2.0, duration: 0.3))
            game_status=4;
            falling_objects_speeds.removeAll()
            for falling_object: SKSpriteNode in falling_objects{
                falling_objects_speeds.append(falling_object.physicsBody!.velocity)
                falling_object.physicsBody!.dynamic=false;
            }
        }
        else if (game_status==4){
            //holding pattern
        }
        else if(game_status==5){
         
            NSUserDefaults.standardUserDefaults().setObject(current_coins, forKey: "coins");
            let scene = TitleScene()
            scene.score_label.text = "\(score_number)"
            let highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore");
        
            if(score_number > highscore){
 
                NSUserDefaults.standardUserDefaults().setInteger(score_number, forKey: "highscore");
            }
            // Configure the view.
            let skView = self.view as SKView?
            let transition = SKTransition.fadeWithDuration(1)
            skView!.showsFPS = false
            skView!.showsNodeCount = false
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView!.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.size=skView!.bounds.size;
            scene.scaleMode = .AspectFill
            skView!.presentScene(scene, transition:  transition)
            
        }
        
    }
    
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("got the request from Apple")
        
    }
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        print("Received Payment Transaction Response from Apple");
        
        
    }
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        print("in the payment queue");
    }
    

    
    //TITLE SCENE
    var temp_score=0;
    var background_node=SKSpriteNode();

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
        background_node.zPosition = -100000;
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
          

        }
        for(var i=0; i<number_of_backgrounds; i++){
                    backgroundNode.append(SKSpriteNode())
                    backgroundNode[i].texture=SKTexture(imageNamed: "Background7_\(i+1)k.png");
                    backgroundNode[i].zPosition = -1000000
                    backgroundNode[i].size = CGSizeMake(self.size.width, self.size.width*6)
                    backgroundNode[i].hidden=true;
                    addChild(backgroundNode[i])
            
        }
        for(var i=0; i<number_of_backgrounds; i+=1){
                backgroundNode[i].position = CGPointMake(self.size.width/2, (self.size.width*6/2)+CGFloat(i*Int(self.size.width*6)) - self.size.width*5.75);
                }
        
    }

    override func update(currentTime: CFTimeInterval){

     
        

        if(action==true){
         
            update_game();
        }
        else{
            let deviceMotion = self.manager.deviceMotion;
            if((deviceMotion) != nil){
                currentRoll=deviceMotion!.attitude.roll as Double;
            }
            
            character.position = CGPointMake(self.frame.size.width/2.0+35.0*CGFloat(currentRoll), character.position.y);
            fuel.position = CGPointMake(self.frame.size.width/2.0+35.0*CGFloat(currentRoll) ,fuel.position.y)
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touches: AnyObject in touches{
            
            let location = touches.locationInNode(self)
           
            if(game_status==4){
                if(location.y > CGFloat(life.position.y)+CGFloat(life.size.height/2.0) - 30 && location.y < CGFloat(life.position.y)+CGFloat(life.size.height/2.0) + 30 && location.x > CGFloat(life.position.x)+CGFloat(life.size.width/2.0) - 30 && location.x < CGFloat(life.position.x)+CGFloat(life.size.width/2.0) + 30){
                    //life.runAction(SKAction.moveToY(-500, duration: 0.8));
                    game_status=5;
                }
                else if(location.y > CGFloat(life.position.y)-CGFloat(life.size.height/2.0)+20 && location.y < CGFloat(life.position.y)+CGFloat(life.size.height/2.0)-140 && location.x > CGFloat(life.position.x)-CGFloat(life.size.width/2.0)+20 && location.x < CGFloat(life.position.x)+CGFloat(life.size.width/2.0)-20){
                    var number_of_lives = NSUserDefaults.standardUserDefaults().integerForKey("Lives");
                    if(number_of_lives>0){
                        self.continueGame();
                        number_of_lives-=1;
                        NSUserDefaults.standardUserDefaults().setInteger(number_of_lives, forKey: "Lives")
                    }
                    else{
                        game_status=4.5;
                        if(location.x-life.position.x < 106.0 && location.x-life.position.x > -106.0){
                            var temp_prod_id = ""
                            //button 1
                            if(location.y-life.position.y < -24 && location.y-life.position.y > -48){
                                temp_prod_id = "7"
                            }
                            //button 2
                            if(location.y-life.position.y < -59 && location.y-life.position.y > -80){
                                temp_prod_id = "8"
                            }
                            //button 3
                            if(location.y-life.position.y < -94 && location.y-life.position.y > -120){
                                temp_prod_id = "9"
                            }
                            
                            if(SKPaymentQueue.canMakePayments()){
                                let productID:NSSet = NSSet(object: temp_prod_id)
                                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                                productsRequest.delegate = self;
                                productsRequest.start();
                        
                            }
                        }
                        buy_hearts.runAction(SKAction.moveToY(self.size.height/2.0, duration: 0.3));
                    }
                    
                }
            }
            else if(game_status==4.5){
                if(location.y > CGFloat(life.position.y)+CGFloat(life.size.height/2.0) - 30 && location.y < CGFloat(life.position.y)+CGFloat(life.size.height/2.0) + 30 && location.x > CGFloat(life.position.x)+CGFloat(life.size.width/2.0) - 30 && location.x < CGFloat(life.position.x)+CGFloat(life.size.width/2.0) + 30){
                    //life.runAction(SKAction.moveToY(-500, duration: 0.8));
                    game_status=5;
                }
                else if(location.y > CGFloat(life.position.y)-CGFloat(life.size.height/2.0)+20 && location.y < CGFloat(life.position.y)+CGFloat(life.size.height/2.0)-140 && location.x > CGFloat(life.position.x)-CGFloat(life.size.width/2.0)+20 && location.x < CGFloat(life.position.x)+CGFloat(life.size.width/2.0)-20){
                    
                }
                
                
            }
            if(Mirror(reflecting: self.nodeAtPoint(location)).subjectType == SKSpriteNode.self && falling_objects.contains((self.nodeAtPoint(location) as! SKSpriteNode))){
                touched_location = touches.locationInNode(self)
                isTouching=true
                moving_object=self.nodeAtPoint(location) as! SKSpriteNode
            }
        }
//TITLE TOUCHES BEGAN
        
        
        
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
                
                
                store.runAction(SKAction.runBlock(c));
                high_score_label.runAction(SKAction.runBlock(d));
                high_score_label_title.runAction(SKAction.runBlock(e));
                score_label.runAction(SKAction.runBlock(f));
                score_label_title.runAction(SKAction.runBlock(g));
                self.play.runAction(SKAction.runBlock(a));
                self.title.runAction(SKAction.runBlock(b));
                
                // SKAction.moveTo(CGPointMake(background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0)
                let title_blast = { () -> Void in
                    for(var i=0; i<self.number_of_backgrounds; i+=1){
                        self.backgroundNode[i].hidden=false
                    }

                    self.background_node.runAction( SKAction.moveTo(CGPointMake(self.background_node.position.x,-self.size.width*4+self.size.height), duration: 1.0));
                    self.character.runAction(SKAction.scaleBy((1/(1.5)), duration: 1));
                    self.character.runAction(SKAction.moveToY(4*self.size.height/24, duration: 1))
                    self.fuel.runAction(SKAction.moveToY(4*self.size.height/24-20, duration: 1));
                    
                    //self.black_background_node.runAction(SKAction.fadeAlphaTo(1, duration: 1));
                    
                }
                let begin_game = { () -> Void in
                    for(var i=0; i<self.number_of_backgrounds; i+=1){
                        
                        self.backgroundNode[i].zPosition = -10;
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.action = true;
                        self.game_scene_begin();
                    })
               
                    
                    
                }
                self.background_node.runAction(SKAction.sequence([SKAction.runBlock(title_blast),SKAction.waitForDuration(1.0), SKAction.runBlock(begin_game)]))
                

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
    
    

}