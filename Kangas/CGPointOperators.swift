//
//  CGPointOperators.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation

struct Point: CustomStringConvertible {
    let x: Micron
    let y: Micron
    
    public var description: String { return "Point[\(x), \(y)]" }
    
    static func manhattanDistance(_ p1: Point, _ p2: Point) -> Micron {
        return Micron(abs(p1.x.microns - p2.x.microns) + abs(p1.y.microns - p2.y.microns))
    }
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
        
        let currentLine = unusedLines.first!
        unusedLines.remove(at: 0)
        let startPoint = currentLine.start
        var previousPoint = currentLine.end
        foundPoints.append(previousPoint)
        
        repeat {
            var closestPoint: Point = Point(x: Micron(Int.max), y: Micron(Int.max))
            var closestDistance = Micron(Int.max)
            var foundLine: Line?
            var foundLineIndex: Int? = nil
            var foundPoint: Point? = nil
            for i in 0..<unusedLines.count {
                let line = unusedLines[i]
                if line.start == previousPoint {
                    foundPoint = line.start
                    foundPoints.append(line.start)
                    foundPoints.append(line.end)
                    foundPoint = line.end
                    foundLineIndex = i
                    break
                } else if line.end == previousPoint {
                    foundPoint = line.end
                    foundPoints.append(line.end)
                    foundPoints.append(line.start)
                    foundPoint = line.start
                    foundLineIndex = i
                    break
                }
                
                let startDistance = Point.manhattanDistance(line.start, previousPoint)
                let endDistance = Point.manhattanDistance(line.end, previousPoint)
                if startDistance < closestDistance {
                    closestPoint = line.start
                    closestDistance = startDistance
                }
                if endDistance < closestDistance {
                    closestPoint = line.end
                    closestDistance = endDistance
                }
            }
            if let foundLineIndex = foundLineIndex {
                unusedLines.remove(at: foundLineIndex)
            }
            if let foundPoint = foundPoint {
                previousPoint = foundPoint
            }
        } while (unusedLines.count > 0)
        
        foundPoints.append(startPoint)
        points = foundPoints
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
    
    func expanded(with expansion: Micron, direction: [Direction3D] = Direction3D.allCases) -> Dimensions {
        let outerWidth =  self.width + (direction.contains(.left) ? expansion : Micron(0)) + (direction.contains(.right) ? expansion : Micron(0))
        let outerDepth =  self.depth  + (direction.contains(.front) ? expansion : Micron(0)) + (direction.contains(.back) ? expansion : Micron(0))
        let outerHeight = self.height + (direction.contains(.floor) ? expansion : Micron(0)) + (direction.contains(.ceiling) ? expansion : Micron(0))
        
        return Dimensions(width: outerWidth, height: outerHeight, depth: outerDepth)
    }
    
    func expanded(with expansion: Micron, except: [Direction3D]) -> Dimensions {
        var direction = Direction3D.allCases
        direction.removeAll(where: { except.contains($0) })
        return expanded(with: expansion, direction: direction)
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
