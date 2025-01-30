//
//  main.swift
//  Kangas
//
//  Created by Joni Rajala on 2.12.2024.
//

import Foundation
import ArgumentParser


struct Kangas: ParsableCommand {
    
    static var configuration = CommandConfiguration(
            abstract: "Luo laatikoiden leikattavia muotteja.",
            subcommands: [Huullos.self, Avoloota.self, Puristus.self],
            defaultSubcommand: Kangas.self)

    struct BoxOptions: ParsableArguments {
        @Argument(help:"Laatikon leveys (pitkä sivu). Milleinä.") var width: Double;
        @Argument(help:"Laatikon korkeus (ylöspäin). Milleinä.") var height: Double;
        @Argument(help:"Laatikon syvyys (lyhyt sivu). Milleinä.") var depth: Double;
        @Option(help:"Laatikon materiaalin paksuus. Milleinä.") var materialThickness: Double = 3
        @Option(help:"Kangasmateriaalin paksuus. Milleinä.") var clothThickness: Double = 0.5
        @Option(help:"Ylivuotokangaspalojen pituus. Milleinä.") var clothSlack: Double = 5
        @Option(help:"Sahan leikkaaman tai laserin polttaman uran leveys. Milleinä") var kerf: Double = 0.05

        @Flag(help:"Tämä lippu muuttaa annetut mittasuhteet laatikon sisämitoiksi.") var internalDimensions: Bool = false
        @Flag(help:"Tämä lippu muuttaa kankaan sisäkulmat päällekkäisiksi neliskanttisiksi kulmiksi, eikä yritä esileikata niitä jiiriin.") var squareCorners: Bool = false
    }
    
    struct InoutOptions: ParsableArguments {
        @Option(name: [.short, .long], help:"Tiedoston nimi, johon tulokset kirjoitetaan. Jos useita tiedostoja, nimenperään laitetaan lisämääreitä. Tiedostopäätettä ei pidä laittaa tähän. Oletuksena \"tulos\"") var outputFileName = "tulos";
        
        @Flag(help:"Tämä lippu estää lataamasta tiedostoja boxes.pystä. Sen sijaan tulostaa linkin päätteeseen.") var noDownload = false
        
        func write(content: [String], suffix: String) {
            let workingDirectoryUrl = URL(filePath: FileManager.default.currentDirectoryPath)
            
            do {
                for i in 0..<content.count {
                    let text = content[i]
                    let appendedIndex = content.count > 1 ? "-\(i)" : ""
                    
                    let filename = outputFileName + suffix + appendedIndex
                    let url = workingDirectoryUrl.appending(path: filename)
                    
                    print("Kirjoitetaan tiedostoa: \(url.path)")
                    try text.write(toFile:url.path,
                                   atomically: false,
                                   encoding: .utf8)
                }
            } catch {
                print("Kirjoittaessa tiedostoa \(suffix) tapahtui virhe: \(error).")
            }
        }
        
        func download(url: URL, suffix: String) {
            let filename = outputFileName + suffix
            
            guard noDownload == false else {
                print("Voit ladata tiedoston \(filename) osoitteesta \(url.absoluteString)")
                return
            }
            
            print("Ladataan tiedostoa \(filename)")
            
            FileDownloader.loadFileSync(url: url) { (path, error) in
                if let path = path {
                    do {
                        let currentFileUrl = URL(filePath: path)
                        let renamedUrl = currentFileUrl.deletingLastPathComponent().appending(component: filename)
                        let fm = FileManager.default
                        if fm.fileExists(atPath: renamedUrl.path) {
                            try fm.removeItem(at: renamedUrl)
                        }
                        try FileManager.default.moveItem(at: currentFileUrl, to: renamedUrl)
                        print("Tiedosto ladattiin sijaintiin \(renamedUrl.relativePath)")
                    } catch let error {
                        print("Ladatun tiedoston nimeäminen epäonnistui. Se on tallennettu nimellä \(path). Virhe: \(error)")
                    }
                } else {
                    print("Tiedoston lataaminen epäonnistui.")
                }
            }
            
            
        }
    }


    func run() {
        
    }
}

func findCuttableLines(from: [Rect]) -> [Line] {
    
    var lines: [Line] = []
    
    for rect in from {
        lines.append(contentsOf: rect.freeLines())
    }
    
    return lines
}


func boundingArea(from: [ContinuousLine]) -> Rect {
    
    var minX = Micron(Int.max)
    var minY = Micron(Int.max)
    var maxX = Micron(Int.min)
    var maxY = Micron(Int.min)
    
    for line in from {
        for point in line.points {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
    }
    
    return Rect(origin: Point(x: minX, y: minY), size: Size(width: maxX - minX, height: maxY - minY))
    
}

func svgFrom(continuousLines: [ContinuousLine]) -> String {

    var content = ""
    let bounds = boundingArea(from: continuousLines)
    let shift = Point(x: -bounds.origin.x, y: -bounds.origin.y)
    let header = "<svg width=\"\(bounds.size.width.inMillimeter())mm\" height=\"\(bounds.size.height.inMillimeter())mm\" viewBox=\"\(bounds.origin.x + shift.x) \(bounds.origin.y + shift.y) \(bounds.size.width) \(bounds.size.height)\" version=\"1.1\">\n"
    let footer = "</svg>"
    var index = 1
    
    content += header
    
    for continuousLine in continuousLines {
        var firstPoint = true
        var data = "<g id=\"p-\(index)\" style=\"fill:none;stroke-linecap:round;stroke-linejoin:round;\">\n<path d=\""
        for point in continuousLine.points {
            if firstPoint {
                firstPoint = false
                data += "M "
            } else {
                data += "L "
            }
            data += "\(point.x + shift.x) \(point.y + shift.y) "
        }
        data += "Z\" stroke=\"rgb(0,0,0)\" stroke-width=\"20\" />\n</g>"
        index += 1
        content += data
    }
    
    content += footer
    
    return content
    
}

func randomColor() -> String {
    
    switch Int.random(in: 0...5) {
    case 0:
        return "black"
    case 1:
        return "red"
    case 2:
        return "yellow"
    case 3:
        return "green"
    case 4:
        return "blue"
    case 5:
        return "orange"
    default:
        return "black"
    }
    
    return "black"
}



Kangas.main()


