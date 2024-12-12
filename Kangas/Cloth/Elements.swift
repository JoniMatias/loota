//
//  Elements.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation



enum Direction: CaseIterable {
    case up
    case right
    case down
    case left
}

enum Direction3D: CaseIterable {
    case front
    case back
    case left
    case right
    case floor
    case ceiling
}

enum Corner: Int, CaseIterable {
    case nw = 0
    case ne = 1
    case se = 2
    case sw = 3
}

enum Relation {
    case same
    case nextTo
    case opposite
    case inGroup
    case noRelation
}

func neighbour(of: Corner) -> [Corner] {
    switch of {
    case .nw:
        return [.ne, .sw]
    case .ne:
        return [.nw, .se]
    case .se:
        return [.ne, .sw]
    case .sw:
        return [.se, .nw]
    }
}

func edges(of: Corner) -> [Direction] {
    switch of {
    case .nw:
        return [.left, .up]
    case .ne:
        return [.up, .right]
    case .se:
        return [.right, .down]
    case .sw:
        return [.down, .left]
    }
}

func opposite(of: Direction) -> Direction {
    switch of {
    case .up:
        return .down
    case .right:
        return .left
    case .down:
        return .up
    case .left:
        return .right
    }
}

func relation(of: Direction, to: Direction) -> Relation {
    if of == to {
        return .same
    }
    
    if opposite(of: of) == to {
        return .opposite
    }
    
    return .nextTo
}
