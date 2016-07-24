//
//  ViewController.swift
//  IVCalc
//
//  Created by Lei Mingyu on 24/7/16.
//  Copyright © 2016 mingyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var fieldCombatPoint: UITextField!
    @IBOutlet var fieldHealthPoint: UITextField!
    @IBOutlet var fieldStarDustNumber: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    private var possibleCPMultiplier: [Double]?
    private var pickerStarDustNumber: UIPickerView?
    private let sharedPokemon = SharedPokemon.sharedInstance
    
    private var baseStamina: Double?
    private var baseAttack: Double?
    private var baseDefense: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerStarDustNumber = UIPickerView()
        pickerStarDustNumber?.delegate = self
        pickerStarDustNumber?.dataSource = self
        fieldStarDustNumber.inputView = pickerStarDustNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue-pick-pokemon" {
            let destinationViewController = segue.destinationViewController as! IVPMCollectionViewController
            destinationViewController.delegate = self
        }
    }

    @IBAction func calculatIVPerfection() {
        let CP = Double(fieldCombatPoint.text!)
        let HP = Double(fieldHealthPoint.text!)
        let SD = Double(fieldStarDustNumber.text!)
        var canShowPerfection = false
        var minimumPerfection = 100.0
        var maximumPerfection = -1.0
        var totalPerfection = 0.0
        var totalPerfectionCount = 0
        
        if (CP > 0) && (HP > 0) && (SD > 0) && (sharedPokemon.number != nil) {
            for CPM in possibleCPMultiplier! {
                for possibleIndStamina in 0...15 {
                    if (floor((possibleIndStamina + baseStamina!) * CPM) == HP) {
                        for possibleIndAttack in 0...15 {
                            for possibleIndDefense in 0...15 {
                                let termAttack = baseAttack! + possibleIndAttack
                                let termDefense = sqrt(baseDefense! + possibleIndDefense)
                                let termStamina = sqrt(baseStamina! + possibleIndStamina)
                                let calculatedCP = termAttack * termDefense * termStamina * CPM * CPM / 10
                                if (floor(calculatedCP) == CP) {
                                    canShowPerfection = true
                                    print("\(possibleIndAttack), \(possibleIndDefense), \(possibleIndStamina), \(CPM)")
                                    let perfection = (possibleIndAttack + possibleIndStamina + possibleIndDefense) / 45.0 * 100
                                    minimumPerfection = min(minimumPerfection, perfection)
                                    maximumPerfection = max(maximumPerfection, perfection)
                                    totalPerfection += perfection
                                    totalPerfectionCount += 1
                                }
                            }
                        }
                    }
                }
            }
        }
        if (canShowPerfection) {
            resultLabel.text = [String(format: "Max: %.2f%", maximumPerfection), String(format: "Min: %.2f%", minimumPerfection), String(format: "Avg: %.2f%", totalPerfection / totalPerfectionCount)].joinWithSeparator("\n")
        }
    }
    
    @IBAction func dismissKeyboard() {
        calculatIVPerfection()
        view.endEditing(true)
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.STARDUST_NUM.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(Constants.STARDUST_NUM[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fieldStarDustNumber.text = String(Constants.STARDUST_NUM[row])
        possibleCPMultiplier = Array(Constants.CP_MULTIPLIERS[(row * 2)...(row * 2 + 1)])
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}

extension ViewController: IVPMCollectionViewControllerDelegate {
    func didFinishPickingPokemon() {
        if (sharedPokemon.number != nil) {
            baseStamina = sharedPokemon.baseStamina!
            baseAttack = sharedPokemon.baseAttack!
            baseDefense = sharedPokemon.baseDefense!
            
            picture.image = sharedPokemon.pokemonCache.objectForKey(sharedPokemon.number!) as! UIImage
        }
    }
}


func + (left: Double, right: Int) -> Double {
    return left + Double(right)
}

func + (left: Int, right: Double) -> Double {
    return right + left
}

func / (left: Double, right: Int) -> Double {
    return left / Double(right)
}

func / (left: Int, right: Double) -> Double {
    return Double(left) / right
}
