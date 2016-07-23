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
    
    let SDNums = [200, 400, 600, 800, 1000, 1300, 1600, 1900, 2200, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
    
    let CPMs = [0.094000, 0.166398, 0.215732, 0.255720, 0.290250, 0.321088, 0.349213, 0.375236, 0.399567, 0.422500, 0.443108, 0.462798, 0.481685, 0.499858, 0.517394, 0.534354, 0.550793, 0.566755, 0.582279, 0.597400, 0.612157, 0.626567, 0.640653, 0.654436, 0.667934, 0.681165, 0.694144, 0.706884, 0.719399, 0.731700, 0.737769, 0.743789, 0.749761, 0.755686, 0.761564, 0.767397, 0.773187, 0.778933, 0.784637, 0.790300]

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
        return SDNums.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(SDNums[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fieldStarDustNumber.text = String(SDNums[row])
        possibleCPMultiplier = Array(CPMs[(row * 2)...(row * 2 + 1)])
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
