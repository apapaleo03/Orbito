//
//  HighScore.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/5/21.
//

import Foundation

class HighScore: NSObject, NSCoding {
    let score: Int
    let dateOfScore: NSDate
    let player: String
    
    init(player: String,score: Int, dateOfScore: NSDate){
        self.player = player
        self.score = score
        self.dateOfScore = dateOfScore
    }
    
    required init(coder: NSCoder){
        self.player = coder.decodeObject(forKey: "player") as! String
        self.score = coder.decodeObject(forKey: "score") as! Int
        self.dateOfScore = coder.decodeObject(forKey: "dateOfScore") as! NSDate
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.player, forKey: "player")
        coder.encode(self.score, forKey: "score")
        coder.encode(self.dateOfScore, forKey: "dateOfScore")
    }
    
    func show() -> String{
        return "\(self.player): \(self.score)\t\t\(self.dateOfScore)"
    }
}
