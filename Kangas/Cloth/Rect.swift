//
//  Rect.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation


class Rect {
    
    let origin: Point
    let size: Size
    var neighbours: [Direction: Rect]
    
    class func withHillEdge(from: Rect, towards: Direction, distance: Micron, work: WorkSettings) -> Rect {
        
        let edgeCurve = Rect(from: from, towards: towards, distance: work.clothThickness)
        let rect = Rect.init(from: edgeCurve, towards: towards, distance: distance)
        
        return rect
    }
    
    class func withValleyEdge(from: Rect, towards: Direction, distance: Micron, work: WorkSettings) -> Rect {
        
        let rect = Rect.init(from: from, towards: towards, distance: distance - work.clothThickness)
        
        return rect
    }
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
        neighbours = [:]
        ClothState.allRects.append(self)
    }
    
    required init(from: Rect, towards: Direction, distance: Micron, margin: Micron = Micron(0)) {
        
        let size: Size
        let origin: Point
        
        switch towards {
        case .up:
            origin = Point(x: from.corners()[.nw]!.x + margin,
                           y: from.corners()[.nw]!.y + distance)
            size = Size.init(width: from.lengthOf(edge: .up) - margin*2, height: distance)
        case .right:
            origin = Point(x: from.corners()[.ne]!.x,
                             y: from.corners()[.ne]!.y - margin)
            size = Size.init(width: distance, height: from.lengthOf(edge: .right) - margin*2)
        case .down:
            origin = Point(x: from.corners()[.sw]!.x + margin,
                             y: from.corners()[.sw]!.y)
            size = Size.init(width: from.lengthOf(edge: .down) - margin*2, height: distance)
        case .left:
            origin = Point(x: from.corners()[.nw]!.x - distance,
                           y: from.corners()[.nw]!.y - margin)
            size = Size.init(width: distance, height: from.lengthOf(edge: .left) - margin*2)
            
        }
        
        self.origin = origin
        self.size = size
        neighbours = [opposite(of: towards): from]
        
        for corner in corners() {
            if var rects = ClothState.sharedCorners[corner.value] {
                rects.append(self)
                ClothState.sharedCorners[corner.value] = rects
            } else {
                ClothState.sharedCorners[corner.value] = [self]
            }
        }
        
        from.neighbours[towards] = self
        ClothState.allRects.append(self)
    }
    
    public func freeCornerPointsNextTo(corner: Corner) -> [Point] {
        var freeCornerPoints: [Point] = []
        
        let edges = edges(of: corner)
        let pointAtThisCorner = corners()[corner]!
        
        for edge in edges {
            if neighbours[edge] == nil {
                let ends = pointsAlong(edge: edge)
                for end in ends {
                    if end != pointAtThisCorner {
                        freeCornerPoints.append(end)
                    }
                }
            }
        }
        
        return freeCornerPoints
    }
    
    public func lineAlong(edge: Direction) -> Line {
        let points = pointsAlong(edge: edge)
        return Line(points[0], points[1])
    }
    
    public func pointsAlong(edge: Direction) -> [Point] {
        switch edge {
        case .up:
            return [corners()[.nw]!, corners()[.ne]!]
        case .right:
            return [corners()[.ne]!, corners()[.se]!]
        case .down:
            return [corners()[.se]!, corners()[.sw]!]
        case .left:
            return [corners()[.sw]!, corners()[.nw]!]
        }
    }
    
    public func sharedEdges() -> [Direction] {
        return Array(neighbours.keys);
    }
    
    public func freeEdges() -> [Direction] {
        var edges: [Direction] = []
        let shared = sharedEdges()
        for dir in Direction.allCases {
            if shared.contains(dir) == false {
                edges.append(dir)
            }
        }
        return edges
    }
    
    public func cornerDirection(at: Point) -> Corner? {
        let corners = corners()
        for corner in Corner.allCases {
            if corners[corner] == at {
                return corner
            }
        }
        
        return nil
    }
    
    public func corners() -> [Corner: Point] {
        let nw = origin
        let ne = Point(x: origin.x + size.width, y: origin.y)
        let se = Point(x: origin.x + size.width, y: origin.y - size.height)
        let sw = Point(x: origin.x,              y: origin.y - size.height)
        return [.nw: nw, .ne: ne, .se: se, .sw: sw]
    }
    
    public func lengthOf(edge: Direction) -> Micron {
        switch edge {
        case .up, .down:
            return size.width
        case .left, .right:
            return size.height
        }
    }
    
    subscript(index: Corner) -> Point? {
        return corners()[index]
    }
}
