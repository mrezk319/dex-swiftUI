//
//  PokemonExt.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 19/07/2025.
//

import Foundation
import SwiftUI

extension Pockemon {
    
    var spriteImage: Image? {
        if let data = sprite, let image = UIImage(data: data){
            Image(uiImage: image)
        } else {
            nil
        }
    }
    
    var shinyImage: Image? {
        if let data = shiny, let image = UIImage(data: data){
            Image(uiImage: image)
        }else{
            nil
        }
    }
    
    var background: ImageResource {
        switch types![0]{
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psyic":
                .rockgroundsteelfightingghostdarkpsychic
        case "ice":
                .ice
        case "water":
                .water
        case "flying", "bug":
                .flyingbug
        case "fire", "dragon":
                .firedragon
        default:
                .normalgrasselectricpoisonfairy
        }
    }
    
    var stats: [Stat] {
        [
            Stat(id: 1, name: "hp", value: Int(self.hp)),
            Stat(id: 2, name: "attack", value: Int(self.attack)),
            Stat(id: 3, name: "defense", value: Int(self.defence)),
            Stat(id: 4, name: "sp attack", value: Int(self.specialAttack)),
            Stat(id: 5, name: "sp defense", value: Int(self.specialDefence)),
            Stat(id: 6, name: "speed", value: Int(self.speed))
        ]
    }
    var heighstStat: Stat {
        stats.max {
            $0.value < $1.value
        }!
    }
    struct Stat {
        var id: Int
        var name: String
        var value: Int
    }
    
    var typeColor:Color{
        switch types![0]{
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psy":
            return .init(red: 0.75, green: 0.48, blue: 0.3)
        case "ice":
            return .blue
        case "water":
            return .init(red: 0.28, green: 0.84, blue: 0.9)
    
        default:
            return .green
        }
    }
}
