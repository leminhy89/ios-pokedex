//
//  Pokemon.swift
//  pokedex
//
//  Created by Minh Y Le on 1/14/16.
//  Copyright © 2016 Minh Y Le. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defend: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoTxt: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    
    private var _pokemonUrl: String!
    
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defend == nil {
            _defend = ""
        }
        return _defend
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoLvl: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        
        Alamofire.request(.GET,url)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let weight = JSON["weight"] as? String {
                        self._weight = weight
                    }
                    
                    if let height = JSON["height"] as? String {
                        self._height = height
                    }
                    
                    if let attack = JSON["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                    
                    if let defense = JSON["defense"] as? Int {
                        self._defend = "\(defense)"
                    }
                    
                    print(self._weight)
                    print(self._height)
                    print(self._attack)
                    print(self._defend)
                    
                    
                    // lay types la 1 arrays, co' chua cac dictionary vs 2 doi so string/string , neu co nhieu hon doi so co the dung AnyObject
                    // voi dieu kien array tra ve co it nhat 1 object
                    if let types = JSON["types"] as? [Dictionary<String, String>] where types.count > 0 {
                        
                        if let name = types[0]["name"] {
                            self._type = name
                        }
                        
                        if types.count > 1 {
                            for var x = 1; x < types.count; x++ {
                                if let name = types[x]["name"] {
                                    //cong chuoi - them ky /name
                                    self._type! += "/\(name)"
                                }
                            }
                        }
                        
                    } else {
                        self._type = ""
                    }
                    
                    print(self._type)
                    
                    if let descArr = JSON["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0  {

                        if let url = descArr[0]["resource_uri"] {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            
                            Alamofire.request(.GET, nsurl)
                                .responseJSON { response in
                            
                                if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                        print(self._description)
                                    }
                                }
                                    
                                completed()
                            }

                        
                        }
                    } else {
                        self._description = ""
                    }
                    
                    if let evolutions = JSON["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                        
                        if let to = evolutions[0]["to"] as? String {
                            
                            //Can's support mega pokemon right now - but API still has returned
                            //Mega is not found
                            if to.rangeOfString("mega") == nil {
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    
                                    self._nextEvoId = num
                                    self._nextEvoTxt = to
                                    
                                    
                                    if let level = evolutions[0]["level"] as? Int {
                                        self._nextEvoLevel = "\(level)"
                                    }
                                    
                                    print(self._nextEvoId)
                                    print(self._nextEvoLevel)
                                    print(self._nextEvoTxt)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
        }
        

        
        
    }
    
    
}