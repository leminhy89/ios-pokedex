//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Minh Y Le on 1/15/16.
//  Copyright © 2016 Minh Y Le. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefend: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblBaseAttack: UILabel!
    @IBOutlet weak var imgCurrentEvo: UIImageView!
    @IBOutlet weak var imgNextEvo: UIImageView!
    @IBOutlet weak var lblEvo: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        imgMain.image = img
        imgCurrentEvo.image = img

        
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after download is done
            self.updateUI()
        }

        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        
        lblDescription.text = pokemon.description
        lblType.text = pokemon.type
        lblDefend.text = pokemon.defense
        lblBaseAttack.text = pokemon.attack
        lblHeight.text = pokemon.height
        lblName.text = pokemon.name
        lblPokedexId.text = "\(pokemon.pokedexId)"
        lblWeight.text = pokemon.weight
        
        if pokemon.nextEvoId == "" {
            lblEvo.text = "No Evolutions"
            imgNextEvo.hidden = true
        } else {
            imgNextEvo.hidden = false
            imgNextEvo.image = UIImage(named: pokemon.nextEvoId)
            
            var str = "Next Evolution: \(pokemon.nextEvoTxt)"
            
            if pokemon.nextEvoLvl != "" {
                str += " - LVL \(pokemon.nextEvoLvl)"
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackPressed(sender: UIButton!) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }



}
