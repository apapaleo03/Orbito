//
//  GameScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 4/30/21.
//

import SpriteKit
import GameplayKit
import Foundation

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball : SKShapeNode?
    var staticNodes : Int?
    var history : [TouchInfo]?
    var touchedNode: SKShapeNode?
    var scoreBoardArray = UserDefaults.standard.object(forKey: "scoreboard") as? [Int] ?? []
    var w : CGFloat?
    let difficulty = UserDefaults.standard.string(forKey: "difficulty") ?? "easy"
    let gravity = SKFieldNode.radialGravityField()
    let gravityCategory : UInt32 = 0x1 << 0
    var currentlyTouched : Bool?
    var gameOverBox: SKSpriteNode!
    var mainMenuButton: SKLabelNode!
    var restartButton: SKLabelNode!

    
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }

    
    var scoreLabel: SKLabelNode!
    var scoreValueLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreValueLabel.text = "\(score)"
        }
    }
    
    
    var highScoreLabel: SKLabelNode!
    var highScoreValueLabel: SKLabelNode!
    var highScoreValue = 0 {
        didSet {
            highScoreValueLabel.text = "\(highScoreValue)"
        }
    }
    
    
    
    var multiplierLabel: SKLabelNode!
    var multiplierValueLabel: SKLabelNode!
    var multiplierValue: Int = 0 {
        didSet {
            multiplierValueLabel.text = "\(multiplierValue)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.view?.isMultipleTouchEnabled = false
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        w = (self.size.width + self.size.height) * 0.01
        
        // Define gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx:0, dy:0)
        let gravityVector = vector_float3(0,-1,0)
        let gravityNode = SKFieldNode.linearGravityField(withVector: gravityVector)
        gravityNode.strength = 0
        addChild(gravityNode)
        
        self.gravity.strength = 10
        self.gravity.categoryBitMask = self.gravityCategory
        self.gravity.falloff = 0
        
        
        // Create point at which ball orbits
        createAnchor(at: CGPoint(x:0,y:0))
        
        
      
        // Create orbiting ball
        defineBall()
        self.ball?.physicsBody?.fieldBitMask = gravityCategory
        
        createHighScoreLabels(x: -(self.size.width/2-140), y: self.size.height/2-97)
        createScoreLabels(x: 0, y : self.size.height/2-97)
        createMultiplierLabels(x: self.size.width/2-140, y: self.size.height/2-97)
        
        gameOverBox = SKSpriteNode(color: .black, size: CGSize(width: self.size.width*0.7,height: self.size.height*0.3))
        gameOverBox.position = CGPoint(x:0, y:0)
        gameOverBox.drawBorder(color: .white, width: 3)
        gameOverBox.isHidden = true
        self.addChild(gameOverBox)
        
        mainMenuButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        mainMenuButton.fontColor = .white
        mainMenuButton.fontSize = 30
        mainMenuButton.position = CGPoint(x: 0, y: -40)
        mainMenuButton.text = "Main Menu"
        mainMenuButton.name = "mainMenu"
        gameOverBox.addChild(mainMenuButton)
        
        restartButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        restartButton.fontColor = .white
        restartButton.fontSize = 30
        restartButton.position = CGPoint(x: 0, y: 40)
        restartButton.text = "Restart"
        restartButton.name = "restart"
        gameOverBox.addChild(restartButton)
        
        
        self.staticNodes = self.children.count
        
    }
    
    func createAnchor(at pos: CGPoint){
        // Create point at which ball orbits
        
        let anchorPoint = SKShapeNode.init(circleOfRadius: self.w!/2)
        anchorPoint.physicsBody = SKPhysicsBody(circleOfRadius: self.w!/2)
        anchorPoint.physicsBody!.contactTestBitMask = anchorPoint.physicsBody!.collisionBitMask
        anchorPoint.physicsBody?.isDynamic = false
        anchorPoint.name = "anchor"
        anchorPoint.position = pos
        anchorPoint.addChild(self.gravity)
        self.addChild(anchorPoint)
    }
    
    func defineBall()  {
        self.ball = SKShapeNode.init(circleOfRadius: self.w!)
        self.ball?.lineWidth = 2.5
        self.ball?.physicsBody?.restitution = 0.4
        self.ball?.physicsBody?.mass = 1
        self.ball?.name = "ball"
    }
    func createBall(at pos: CGPoint){
        if let ball = self.ball?.copy() as? SKShapeNode {
            ball.physicsBody?.velocity = CGVector(dx:0,dy:0)
            ball.physicsBody?.isDynamic = false
            ball.position = pos
            ball.strokeColor = RandomColor()
            ball.name = "protoball"
            self.addChild(ball)
        }
    }
    
    func createScoreLabels(x: CGFloat, y: CGFloat){
        scoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: x, y: y + 20)
        scoreLabel.text = "Score"
        self.addChild(scoreLabel)
        
        scoreValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreValueLabel.fontColor = .white
        scoreValueLabel.fontSize = 24
        scoreValueLabel.position = CGPoint(x: x, y: y - 20)
        scoreValueLabel.text = "\(score)"
        self.addChild(scoreValueLabel)
    }
    
    func createHighScoreLabels(x: CGFloat, y: CGFloat){
        highScoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreLabel.fontColor = .white
        highScoreLabel.fontSize = 24
        highScoreLabel.position = CGPoint(x: x, y: y + 20)
        highScoreLabel.text = "High Score"
        highScoreLabel.name = "highscore"
        self.addChild(highScoreLabel)
        
        highScoreValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreValueLabel.fontColor = .white
        highScoreValueLabel.fontSize = 24
        highScoreValueLabel.position = CGPoint(x: x, y: y - 20)
        if !scoreBoardArray.isEmpty{
            self.highScoreValue = scoreBoardArray.last!
        }
        highScoreValueLabel.text = "\(highScoreValue)"
        self.addChild(highScoreValueLabel)
    }
    
    func createMultiplierLabels(x: CGFloat, y: CGFloat){
        multiplierLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierLabel.fontColor = .white
        multiplierLabel.fontSize = 24
        multiplierLabel.position = CGPoint(x: x, y: y + 20)
        multiplierLabel.text = "Multiplier"
        self.addChild(multiplierLabel)
        
        multiplierValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierValueLabel.fontColor = .white
        multiplierValueLabel.fontSize = 24
        multiplierValueLabel.position = CGPoint(x: x, y: y - 20)
        multiplierValueLabel.text = "\(multiplierValue)"
        self.addChild(multiplierValueLabel)
    }
    
    
    
    func startScorer() {
        let wait = SKAction.wait(forDuration: 0.1)
        let block = SKAction.run({
            [unowned self] in
            self.score += Int(0.1 * Double(self.multiplierValue * 10))
        })
        let sequence = SKAction.sequence([wait,block])
        if action(forKey: "timer") == nil {
            run(SKAction.repeatForever(sequence), withKey: "timer")
        }
        self.multiplierValue += 1
    }
    
    func movedBasedVelocity() -> CGVector {
        if let history = self.history, history.count > 1 {
            var vx: CGFloat = 0.0
            var vy: CGFloat = 0.0
            var previousTouchInfo: TouchInfo?
            let maxIterations = 3
            let numElts: Int = min(history.count, maxIterations)
            for index in 0..<numElts {
                let touchInfo = history[index]
                let location = touchInfo.location
                if let previousTouch = previousTouchInfo {
                    let dx = location.x - previousTouch.location.x
                    let dy = location.y - previousTouch.location.y
                    let dt = CGFloat(touchInfo.time - previousTouch.time)
                    
                    
                    vx += dx / dt
                    vy += dy / dt
                }
                previousTouchInfo = touchInfo
            }
            let count = CGFloat(numElts-1)
            
            return CGVector(dx: -vx/count,dy: -vy/count)
        }
        return CGVector(dx: 0, dy: 0)
    }
    
    func distanceBasedVelocity() -> CGVector {
        if let history = self.history, history.count > 1 {
            var vx: CGFloat = 0.0
            var vy: CGFloat = 0.0
            let firstTouch = history.first
            let lastTouch = history.last
            let dx = lastTouch!.location.x - firstTouch!.location.x
            let dy = lastTouch!.location.y - firstTouch!.location.y
            vx = dx * 5
            vy = dy * 5
            return CGVector(dx: vx, dy: vy)
        }
        return CGVector(dx: 0, dy: 0)
    }
    
    func touchDown(atPoint pos : CGPoint, atTime time : TimeInterval) {
       
        self.currentlyTouched = true
        createBall(at: pos)
        
        var thisNode: SKShapeNode?
        self.history = [TouchInfo(location: pos, time: time)]
        for node in nodes(at: pos) {
            if node.name == "protoball" {
                thisNode = node as? SKShapeNode
            }
        }
        self.touchedNode = thisNode
        
    }
    
    func touchMoved(toPoint pos : CGPoint, atTime time: TimeInterval) {
        //self.touchedNode?.position = pos
        self.history?.insert(TouchInfo(location: pos, time: time), at: 0)
    }
    
    
    func touchUp(atPoint pos : CGPoint,  last touche: TimeInterval) {
        
        startScorer()

        self.touchedNode?.physicsBody?.isDynamic = true
        self.touchedNode?.physicsBody = SKPhysicsBody(circleOfRadius: self.w! )
        self.touchedNode?.physicsBody!.contactTestBitMask = (self.touchedNode?.physicsBody!.collisionBitMask)!
        self.touchedNode?.name = "ball"
        
        let velocity: CGVector
        if self.difficulty == "easy" {
            velocity = distanceBasedVelocity()
        }else {
            velocity = movedBasedVelocity()
        }
        self.touchedNode?.physicsBody?.velocity = velocity
        self.history = nil
        self.touchedNode = nil
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let t = touches.first!
        let pos = t.location(in: self)
        let node = self.atPoint(pos)
        if node.name == "mainMenu"{
            if let view = view {
                let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                let scene = SKScene(fileNamed: "MenuScene")
                scene?.scaleMode = .aspectFill
                view.presentScene(scene!, transition: transition)
            }
            
        }else{
            if gameOverBox.isHidden{
                self.touchDown(atPoint: t.location(in: self), atTime: t.timestamp)
            }
                
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), atTime: t.timestamp) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!
        let pos = t.location(in: self)
        let node = self.atPoint(pos)
        if node.name == "restart"{
            gameOverBox.isHidden = true
        }else{
            if gameOverBox.isHidden{
                for t in touches { self.touchUp(atPoint: t.location(in: self), last:t.timestamp) }
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self),last:t.timestamp) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let nodes = self.children
        if nodes.count - self.staticNodes! >= 10 {
            let width = self.size.width
            let height = self.size.height
            var outOfScene = 0
            for child in nodes{
                if child.name == "ball" {
                    if abs(child.position.x) > width || abs(child.position.y) > height {
                        outOfScene += 1
                    }
                }
                if outOfScene >= 10 {
                    collisionBetween(ball: child, object: child)
                    return
                }
            }
        }
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        if object.name == "anchor" || object.name == "ball" {
            if let fireParticles = SKEmitterNode(fileNamed: "mainImpact") {
                fireParticles.position = CGPoint(x: (ball.position.x + object.position.x)/2, y: (ball.position.y + object.position.y)/2)
                addChild(fireParticles)
            }
            if action(forKey: "timer") != nil {removeAction(forKey: "timer")}
            
            if self.score > self.highScoreValue{
                self.highScoreValue = self.score
                self.scoreBoardArray.append(self.highScoreValue)
                if self.scoreBoardArray.count > 10{
                    self.scoreBoardArray.removeFirst()
                }
                UserDefaults.standard.set(self.scoreBoardArray, forKey: "scoreboard")
            }
            self.score = 0
            self.multiplierValue = 0
            if object.name == "ball"{
                ball.removeFromParent()
                object.removeFromParent()
            }else{
                ball.removeFromParent()
            }
            for child in self.children{
                if child.name == "ball"{
                    destroy(ball: child)
                }
            }
            
            //gameOverBox.isHidden = false
        }
        
    }
    
    func destroy(ball:SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "secondaryImpact") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball:nodeB, object: nodeA)
        }
    }
    
}
