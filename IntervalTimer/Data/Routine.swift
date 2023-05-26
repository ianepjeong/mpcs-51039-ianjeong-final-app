//
//  Routine.swift
//  IntervalTimer
//
//  Created by Ian Jeong on 5/17/23.
//

import Foundation

class Routine {
    var name: String
    var duration: [String:Int]
    
    init(name: String, duration: [String:Int]) {
        self.name = name
        self.duration = duration
    }
}
