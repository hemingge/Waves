//
//  Monster.swift
//  Waves
//
//  Created by Waves on 4/15/16.
//  Copyright © 2016 Waves. All rights reserved.
//

import SpriteKit

let numActions: UInt32 = 3

enum Action: Int, CustomStringConvertible {
    case charge = 0, attack, defend
    
    var description: String {
        switch self {
        case .charge:
            return "Charge"
        case .attack:
            return "Attack"
        case .defend:
            return "Defend"
        }
    }
    
    static func random() -> Action {
        return Action(rawValue:Int(arc4random_uniform(numActions)))!
    }
}

let defaultAction:Action = Action.defend
let defaultStartingCharges:Int = 0
let defaultStartingHealth:Int = 3

class Monster {
    var currentAction:Action
    var charges:Int
    var health:Int
    
    init(currentAction:Action, charges:Int, health:Int) {
        self.currentAction = currentAction
        self.charges = charges
        self.health = health
    }
    
    convenience init() {
        self.init(currentAction:defaultAction, charges:defaultStartingCharges, health: defaultStartingHealth)
    }
    
    convenience init(currentAction:Action) {
        self.init(currentAction:currentAction, charges:defaultStartingCharges, health: defaultStartingHealth)
    }
    
    func randomAction() {
        var possibleActions: [Int] = [2]
        if (charges < maxNumCharges) {
            possibleActions.append(0)
        } else if (charges > 0) {
            possibleActions.append(1)
        }
        self.currentAction =
            Action(rawValue:possibleActions[Int(arc4random_uniform(UInt32(possibleActions.count)))])!
    }
}
