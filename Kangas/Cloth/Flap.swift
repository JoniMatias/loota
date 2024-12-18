//
//  Flap.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation


/*
 Puolisuunnikas, joiden molemmat kulmat ovat 45° kulmassa.
   _____________
  /             \
 /               \
 -----------------
 thinEdge muuttuja kertoo mihin suuntaan kuvio kapenee.
 */
class Flap: Rect {
    
    let thinEdge: Direction
    
    override class func withFold(from: Rect, towards: Direction, distance: Micron, margin: Micron = Micron(0), fold: FoldType, work: WorkSettings) -> Rect {
        
        let actualFold = work.clothThickness == Micron(0) ? .none : fold
        
        switch actualFold {
        case .hill:
            let foldRect = Rect(from: from, towards: towards, distance: work.clothThickness, margin: margin)
            let rect = Flap(from: foldRect, towards: towards, distance: distance)
            return rect
        case .valley:
            let rect = Flap(from: from, towards: towards, distance: distance - work.clothThickness, margin: margin)
            return rect
        case .none:
            let rect = Flap(from: from, towards: towards, distance: distance, margin: margin)
            return rect
        }
    }
    
    required init(from: Rect, towards: Direction, distance: Micron, margin: Micron = Micron(0)) {
        thinEdge = towards
        super.init(from: from, towards: towards, distance: distance, margin: margin)
    }
    
    override func corners() -> [Corner: Point] {
        
        var corners = super.corners()
        
        switch thinEdge {
        case .up:
            corners[.nw] = corners[.nw]! + p(size.height, Micron(0))
            corners[.ne] = corners[.ne]! - p(size.height, Micron(0))
        case .right:
            corners[.ne] = corners[.ne]! - p(Micron(0), size.width)
            corners[.se] = corners[.se]! + p(Micron(0), size.width)
        case .down:
            corners[.se] = corners[.se]! - p(size.height, Micron(0))
            corners[.sw] = corners[.sw]! + p(size.height, Micron(0))
        case .left:
            corners[.sw] = corners[.sw]! + p(Micron(0), size.width)
            corners[.nw] = corners[.nw]! - p(Micron(0), size.width)
        }
        
        return corners
        
    }
    
    override func lengthOf(edge: Direction) -> Micron {
        
        switch relation(of: edge, to: thinEdge) {
        case .same:
            if edge == .down || edge == .up {
                return size.width - size.height*2
            } else if edge == .left || edge == .right {
                return size.height - size.width*2
            }
        case .opposite:
            if edge == .down || edge == .up {
                return size.width
            } else if edge == .left || edge == .right {
                return size.height
            }
        case .nextTo, .inGroup, .noRelation:
            return Micron(0)
        }
        
        return Micron(0)

    }
    
}
