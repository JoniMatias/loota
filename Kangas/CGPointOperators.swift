//
//  CGPointOperators.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation

struct Point {
    let x: Micron
    let y: Micron
}

struct Size {
    let width: Micron
    let height: Micron
}

struct Line {
    let start: Point
    let end: Point
    init(_ start: Point, _ end: Point) {
        self.start = start
        self.end = end
    }
}

struct ContinuousLine {
    let points: [Point]
    
    init(lines: [Line]) {
        var unusedLines = lines
        var foundPoints: [Point] = []
        
        var currentLine = unusedLines.first!
        unusedLines.remove(at: 0)
        let startPoint = currentLine.start
        var previousPoint = currentLine.end
        
        repeat {
            for line in unusedLines {
                if line.start == previousPoint {
                    
                } else if line.end == previousPoint {
                    
                }
             }
        } while (unusedLines.count > 0)
    }
}

struct Dimensions {
    
    let width: Micron
    let height: Micron
    let depth: Micron
    
    init(width: Micron, height: Micron, depth: Micron) {
        self.width = width
        self.height = height
        self.depth = depth
    }
    
    func expanded(with expansion: Micron) -> Dimensions {
        let outerWidth =  self.width  + 2*expansion
        let outerDepth =  self.depth  + 2*expansion
        let outerHeight = self.height + 2*expansion
        
        return Dimensions(width: outerWidth, height: outerHeight, depth: outerDepth)
    }
    
    //Staattisen valmiit "konstruktorit"
    static let zero = Dimensions(width: Micron(0), height: Micron(0), depth: Micron(0))
    
}



func p(_ x: Micron, _ y: Micron) -> Point {
    return Point(x:x, y:y)
}

func p(_ x: Int, _ y: Int) -> Point {
    return Point(x:Micron(x), y:Micron(y))
}



func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}



func +(lhs: Dimensions, rhs: Dimensions) -> Dimensions {
    return Dimensions(width: lhs.width + rhs.width, height: lhs.height + rhs.height, depth: lhs.depth + rhs.depth)
}

func -(lhs: Dimensions, rhs: Dimensions) -> Dimensions {
    return Dimensions(width: lhs.width - rhs.width, height: lhs.height - rhs.height, depth: lhs.depth - rhs.depth)
}



extension Point : Hashable, Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x.microns == rhs.x.microns && lhs.y.microns == rhs.y.microns
    }
    
    
  public func hash(into hasher: inout Hasher) {
      hasher.combine(x.microns)
      hasher.combine(y.microns)
  }
}
