//
//  Waves.swift
//  Waves
//
//  Created by Waves on 4/15/16.
//  Copyright © 2016 Waves. All rights reserved.
//

import SpriteKit

protocol WavesDelegate {
    // Invoked when the current round of Waves ends
    func gameDidEnd(_ waves: Waves, won: Bool)
    
    // Invoked after a new game has begun
    func gameDidBegin(_ waves: Waves)
    
    // Invoked when the player attacks
    func attack(_ waves: Waves)
    
    // Invoked when the player defends
    func defend(_ waves: Waves)
    
    // Invoked when the player charges
    func charge(_ waves: Waves)
    
    // Invoked when the current round ends
    func nextRound(_ waves: Waves)
}

let ticksInOneRound = 3
let maxNumCharges = 3

class Waves {
    var monster,oppMonster:Monster
    var currentRoundTicks:Int
    var delegate:WavesDelegate?
    
    init() {
        self.monster = Monster()
        self.oppMonster = Monster(currentAction: Action.random())
        self.currentRoundTicks = 0
    }
    
    func beginGame() {
        delegate?.gameDidBegin(self)
    }
    
    func tick() {
        currentRoundTicks += 1
        if (currentRoundTicks > ticksInOneRound) {
            currentRoundTicks = 0
            nextRound()
        }
    }
    
    func nextRound() {
        oppMonster.randomAction()
        switch (monster.currentAction, oppMonster.currentAction) {
        case (Action.attack, Action.attack):
            monster.charges -= 1
            oppMonster.charges -= 1
        case (Action.attack, Action.charge):
            monster.charges -= 1
            oppMonster.health -= 1
        case (Action.attack, Action.defend):
            monster.charges -= 1
        case (Action.charge, Action.attack):
            monster.health -= 1
            oppMonster.charges -= 1
        case (Action.charge, Action.charge):
            monster.charges += 1
            oppMonster.charges += 1
        case (Action.charge, Action.defend):
            monster.charges += 1
        case (Action.defend, Action.attack):
            oppMonster.charges -= 1
        case (Action.defend, Action.charge):
            oppMonster.charges += 1
        case (Action.defend, Action.defend):
            break;
        }
        if (monster.health == 0) {
            delegate?.gameDidEnd(self, won: false)
        } else if (oppMonster.health == 0) {
            delegate?.gameDidEnd(self, won: true)
        } else {
            delegate?.nextRound(self)
            monster.currentAction = defaultAction
            oppMonster.currentAction = defaultAction
        }
    }
    
    func charge() {
        if (monster.charges < maxNumCharges) {
            monster.currentAction = Action.charge
            delegate?.charge(self)
        }
    }
    
    func defend() {
        monster.currentAction = Action.defend
        delegate?.defend(self)
    }
    
    func attack() {
        if (monster.charges > 0) {
            monster.currentAction = Action.attack
            delegate?.attack(self)
        }
    }
}
