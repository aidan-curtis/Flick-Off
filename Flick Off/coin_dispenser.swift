//
//  coin_dispenser.swift
//  Flick Off
//
//  Created by Aidan Curtis on 2/7/16.
//  Copyright © 2016 southpawac. All rights reserved.
//

import Foundation
class coin_dispenser{
    enum coin_mode:Int{
    case vertical=0, zigzag, alternate
    }
    var alternate=0;
    var mode=0;
    var width=0;
    var last_location=0;
    var direction=0;
    var status=1;
    init(){
        mode=0
    }
    func setAlternate(setting_alternate: Int){
        alternate = setting_alternate
    }
    func setWidth(setting_width: Int){
        width = setting_width
        direction = width
    }
    func power(power_switch : Int){
        status=power_switch
    }
    func fetch_next_coin() -> Int{
        var thing_to_return=0;
        if(mode==coin_mode.vertical.rawValue){
            thing_to_return = last_location
        }
        if(mode==coin_mode.zigzag.rawValue){
            print(thing_to_return)
            thing_to_return = last_location+25*(direction/abs(direction))
            direction -= (direction/abs(direction));
            if(abs(direction)==1){
                direction*=(-width)
            }
            last_location=thing_to_return
        }
        if(mode==coin_mode.alternate.rawValue){
            thing_to_return = alternate
            let temp=last_location
            last_location=alternate
            alternate=temp
        }
        return thing_to_return
    }
    func begin_action(action_num: Int, starting_location: Int){
        if(action_num==coin_mode.vertical.rawValue){
           mode=coin_mode.vertical.rawValue
        }
        if(action_num==coin_mode.zigzag.rawValue){
            mode=coin_mode.zigzag.rawValue

        }
        if(action_num==coin_mode.alternate.rawValue){
            mode=coin_mode.alternate.rawValue
        }
        last_location=starting_location
    }
    
    
    
}