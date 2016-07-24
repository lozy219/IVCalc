//
//  SharedPokemon.swift
//  IVCalc
//
//  Created by Lei Mingyu on 24/7/16.
//  Copyright © 2016 mingyu. All rights reserved.
//

import UIKit

class SharedPokemon {
    class var sharedInstance: SharedPokemon {
        struct Static {
            static var instance: SharedPokemon?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SharedPokemon()
        }
        
        return Static.instance!
    }
    
    private var _number: Int?
    var number: Int? {
        set(newValue) {
            _number = newValue
            let plistPath = NSBundle.mainBundle().pathForResource("pokemonStats", ofType: "plist")
            if let dataDict = NSDictionary(contentsOfFile: plistPath!) {
                if let pokemonList = dataDict["Pokemons"] as? NSArray {
                    let pokemonStats = pokemonList[_number! - 1] as! NSDictionary
                    baseStamina = pokemonStats["BaseStamina"] as? Double
                    baseAttack = pokemonStats["BaseAttack"] as? Double
                    baseDefense = pokemonStats["BaseDefense"] as? Double
                }
            }
        }
        get {
            return _number
        }
    }
    var baseStamina: Double?
    var baseAttack: Double?
    var baseDefense: Double?
    let pokemonCache = NSCache()
}
