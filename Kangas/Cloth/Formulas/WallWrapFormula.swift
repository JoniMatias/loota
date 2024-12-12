//
//  WallWrap.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


extension Cloth {
 
    struct WallWrapOptions {
        let outerWallFill: Micron;//Paljonko ulkoseinää täytetään ylhäältä päin. Jos isompi kuin korkeus, niin käytetään korkeutta.
        
        let bottomSlack: Micron; //Jos koko ulkoseinä täytetään, niin paljonko alapintaan jätetään ylimääräistä. Ei tee mitään, jo outerWallFill on vähemmän kuin korkeus.
        
        init(outerWallFill: Micron, bottomSlack: Micron) {
            self.outerWallFill = outerWallFill
            self.bottomSlack = bottomSlack
        }
        
        static func defaults() -> WallWrapOptions {
            return WallWrapOptions(outerWallFill: Micron(-1), bottomSlack: Micron(-1))
        }
    }
    
    /*
     Palauttaa stringing, jossa on svg-tiedoston sisältö.
     */
    static func createWallWrap(parameters: WallWrapOptions, box: BoxData, work: WorkSettings) -> [String]  {
        
        ClothState.reset()
        
        let hasBottomSlack = parameters.bottomSlack > Micron(0) && parameters.outerWallFill > box.outer.height
        let outerFillLength = parameters.outerWallFill > Micron(0) ? min(box.outer.height, parameters.outerWallFill) : box.outer.height
        
        
        let outerWall1 = Rect(origin: p(0,0), size: Size(width: box.outer.width, height: outerFillLength))
        let outerWall2 = Rect(from: outerWall1, towards: .right, distance: box.outer.depth)
        let outerWall3 = Rect(from: outerWall2, towards: .right, distance: box.outer.width)
        let outerWall4 = Rect(from: outerWall3, towards: .right, distance: box.outer.depth)
        let outerFlap = Flap(from: outerWall4, towards: .right, distance: outerFillLength / 6)
        
        let rim1 = Flap(from: outerWall1, towards: .up, distance: work.materialThickness)
        let rim2 = Flap(from: outerWall2, towards: .up, distance: work.materialThickness)
        let rim3 = Flap(from: outerWall3, towards: .up, distance: work.materialThickness)
        let rim4 = Flap(from: outerWall4, towards: .up, distance: work.materialThickness)
        
        
        let innerWall1 = Rect(from: rim1, towards: .up, distance: box.inner.height)
        let innerWall2 = Rect(from: rim2, towards: .up, distance: box.inner.height)
        let innerWall3 = Rect(from: rim3, towards: .up, distance: box.inner.height)
        let innerWall4 = Rect(from: rim4, towards: .up, distance: box.inner.height)
        
        let slack1 = Flap(from: innerWall1, towards: .up, distance: work.clothSlack)
        let slack2 = Flap(from: innerWall2, towards: .up, distance: work.clothSlack)
        let slack3 = Flap(from: innerWall3, towards: .up, distance: work.clothSlack)
        let slack4 = Flap(from: innerWall4, towards: .up, distance: work.clothSlack)
        
        
        return [svgFrom(lines: findCuttableLines(from: ClothState.allRects))]
    }

    
}
