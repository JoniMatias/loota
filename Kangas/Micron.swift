//
//  Micron.swift
//  Kangas
//
//  Created by Joni Rajala on 9.12.2024.
//

import Foundation



class Micron: CustomStringConvertible {
    let microns: Int
    
    public var description: String { return "\(microns)" }
    
    init(_ value: Int) {
        self.microns = value
    }
    
    init(millimeters: Double) {
        self.microns = Int(millimeters * 1000.0)
    }
    
    
    func inMillimeter() -> Double {
        return Double(microns) / 1000.0
    }
}


func +(lhs: Micron, rhs: Micron) -> Micron {
    return Micron(lhs.microns + rhs.microns)
}

func -(lhs: Micron, rhs: Micron) -> Micron {
    return Micron(lhs.microns - rhs.microns)
}

func *(lhs: Micron, rhs: Int) -> Micron {
    return Micron(lhs.microns * rhs)
}

func *(lhs: Micron, rhs: Double) -> Micron {
    return Micron(Int(Double(lhs.microns) * rhs))
}

func *(lhs: Int, rhs: Micron) -> Micron {
    return Micron(rhs.microns * lhs)
}

func *(lhs: Double, rhs: Micron) -> Micron {
    return Micron(Int(Double(rhs.microns) * lhs))
}

func /(lhs: Micron, rhs: Int) -> Micron {
    return Micron(lhs.microns / rhs)
}

func /(lhs: Micron, rhs: Double) -> Micron {
    return Micron(Int(Double(lhs.microns) / rhs))
}

prefix func - (_ value: Micron) -> Micron {
    return Micron(-value.microns)
}


func ==(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns == rhs.microns
}

func >(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns > rhs.microns
}

func <(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns < rhs.microns
}

func >=(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns >= rhs.microns
}

func <=(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns <= rhs.microns
}

func !=(lhs: Micron, rhs: Micron) -> Bool {
    return lhs.microns != rhs.microns
}

func min(_ x: Micron, _ y: Micron) -> Micron {
    return Micron(min(x.microns, y.microns))
}

func max(_ x: Micron, _ y: Micron) -> Micron {
    return Micron(max(x.microns, y.microns))
}
