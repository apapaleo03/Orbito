//
//  Helper.swift
//  GravityPool
//
//  Created by Andrea Papaleo on 4/30/21.
//



import Foundation
import UIKit
import Darwin
import SpriteKit

let gameFont = "Baskerville-Bold"

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}


extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Array where Element == Int{
    mutating func addScore(newScore:Int){
        
        var indexFound = false
        
        for i in 0..<self.count{
            if newScore < self.index(after: i){
                insert(newScore, at: i-1)
                indexFound = true
                break
            }
        }
        
        if !indexFound{
            append(newScore)
        }
        
        if self.count > 5{
            removeFirst()
        }
    }
}


func RandomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

func RandomFloat() -> Float {
    return Float(arc4random()) /  Float(UInt32.max)
}

func RandomFloat(min: Float, max: Float) -> Float {
    return (Float(arc4random()) / Float(UInt32.max)) * (max - min) + min
}

func RandomDouble(min: Double, max: Double) -> Double {
    return (Double(arc4random()) / Double(UInt32.max)) * (max - min) + min
}

func RandomCGFloat() -> CGFloat {
    return CGFloat(RandomFloat())
}

func RandomCGFloat(min: Float, max: Float) -> CGFloat {
    return CGFloat(RandomFloat(min: min, max: max))
}

func RandomColor() -> UIColor {
    return UIColor(red: RandomCGFloat(), green: RandomCGFloat(), blue: RandomCGFloat(), alpha: 1)
}

func invertCoords(_ pos: CGPoint) -> CGPoint{
    return CGPoint(x: -pos.x,y: -pos.y)
}

func mapToEdge(point:CGPoint, screenSize: CGSize) -> CGPoint {
    let width = screenSize.width/2 - 75
    let height = screenSize.height/2 - 75
    let x = point.x
    let y = point.y
    let theta = CGFloat((atan2(Double(y) , Double(x)) + 2*Double.pi).truncatingRemainder(dividingBy: 2*Double.pi))
    let topRight = atan2(height, width)
    let bottomRight = CGFloat(2*Double.pi) - topRight
    let topLeft = CGFloat(Double.pi) - topRight
    let bottomLeft = CGFloat(Double.pi) + topRight
    let newX: CGFloat
    let newY: CGFloat
    

    if ((theta < topRight) || (theta > bottomRight)) || ((theta > topLeft) && (theta < bottomLeft)){
        newX = width*x/abs(x)
        newY = newX*tan(theta)
    }else if theta == topRight{
        newX = width
        newY = height
    }else if theta == topLeft{
        newX = -width
        newY = height
    }else if theta == bottomLeft{
        newX = -width
        newY = -height
    }else if theta == bottomRight{
        newX = width
        newY = -height
    }else{
        newY = height*y/abs(y) - 50
        
        let newXTemp = newY/tan(theta)
        if newXTemp > width{
            newX = 0.0
        }
        else{
            newX = newXTemp
        }
        
    }
    
    return CGPoint(x: newX,y: newY)

}


