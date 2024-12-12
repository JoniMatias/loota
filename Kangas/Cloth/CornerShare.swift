//
//  CornerShare.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation


class ClothState {
    static var allRects: [Rect] = []

    static var sharedCorners: [Point: [Rect]] = [:]
    
    static func reset() {
        allRects = []
        sharedCorners = [:]
    }
}
