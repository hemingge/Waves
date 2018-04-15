//
//  GameViewController.swift
//  Swiftris
//
//  Created by Waves on 4/10/16.
//  Copyright (c) 2016 Waves. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, WavesDelegate, UIGestureRecognizerDelegate {

    var scene:GameScene!
    var waves:Waves!
    var panPointReference:CGPoint?
    
    @IBOutlet weak var health: UILabel!
    @IBOutlet weak var oppHealth: UILabel!
    @IBOutlet weak var charges: UILabel!
    @IBOutlet weak var oppCharges: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var oppAction: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        waves = Waves()
        waves.delegate = self
        waves.beginGame()
        
        scene.startTicking()
        
        // Present the scene.
        skView.presentScene(scene)
        
    }
    
    func didTick() {
        if (waves.currentRoundTicks == 0) {
            action.text = "\(waves.monster.currentAction.description)"
            oppAction.text = "\(3 - waves.currentRoundTicks)"
        } else if(waves.currentRoundTicks == ticksInOneRound) {
            oppAction.text = "\(waves.oppMonster.currentAction.description)"
        } else {
            oppAction.text = "\(3 - waves.currentRoundTicks)"
        }
        waves.tick()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        waves.charge()
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    waves.charge()
                    panPointReference = currentPoint
                } else {
                    waves.charge()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        waves.defend()
    }
    
    @IBAction func didSwipeUp(_ sender: UISwipeGestureRecognizer) {
        waves.attack()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func gameDidBegin(_ waves: Waves) {
        health.text = "\(waves.monster.health)"
        oppHealth.text = "\(waves.oppMonster.health)"
        charges.text = "\(waves.monster.charges)"
        oppCharges.text = "\(waves.oppMonster.charges)"
        action.text = "\(defaultAction.description)"
        oppAction.text = "\(ticksInOneRound)"
        scene.tickLengthMillis = TickLength
    }
    
    func gameDidEnd(_ waves: Waves, won: Bool) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        scene.playSound("gameover.mp3")
    }
    
    func charge(_ waves: Waves) {
        action.text = Action.charge.description
    }
    
    func attack(_ waves: Waves) {
        action.text = Action.attack.description
    }
    
    func defend(_ waves: Waves) {
        action.text = Action.defend.description
    }
    
    func nextRound(_ waves: Waves) {
        health.text = "\(waves.monster.health)"
        oppHealth.text = "\(waves.oppMonster.health)"
        charges.text = "\(waves.monster.charges)"
        oppCharges.text = "\(waves.oppMonster.charges)"
        action.text = "\(waves.monster.currentAction.description)"
        oppAction.text = "\(waves.oppMonster.currentAction.description)"
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
