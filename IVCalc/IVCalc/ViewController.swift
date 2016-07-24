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

    @IBAction func calculatIVPerfection() {
        let CP = Double(fieldCombatPoint.text!)
        let HP = Double(fieldHealthPoint.text!)
        let SD = Double(fieldStarDustNumber.text!)
        var canShowPerfection = false
        var minimumPerfection = 100.0
        var maximumPerfection = -1.0
        var totalPerfection = 0.0
        var totalPerfectionCount = 0
        
        if (CP > 0) && (HP > 0) && (SD > 0) {
            // testing formula
            
            // Eevee's base stats
            let baseSta = 110.0
            let baseAtk = 114.0
            let baseDef = 128.0
            
            for CPM in possibleCPMultiplier! {
                for possibleIndSta in 0...15 {
                    if (floor((possibleIndSta + baseSta) * CPM) == HP) {
                        for possibleIndAtk in 0...15 {
                            for possibleIndDef in 0...15 {
                                let calculatedCP = (baseAtk + possibleIndAtk) * sqrt(baseDef + possibleIndDef) * sqrt(baseSta + possibleIndSta) * CPM * CPM / 10
                                if (floor(calculatedCP) == CP) {
                                    canShowPerfection = true
                                    print("\(possibleIndAtk), \(possibleIndDef), \(possibleIndSta), \(CPM)")
                                    let perfection = (possibleIndAtk + possibleIndSta + possibleIndDef) / 45.0 * 100
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
