//
//  ViewController.swift
//  ImperialConverter
//
//  Created by Kevin Olive on 3/13/19.
//  Copyright © 2019 Kevin Olive. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var measureType: UISegmentedControl!
    @IBOutlet weak var valueToConvertText: UITextField!
    @IBOutlet weak var measurePicker: UIPickerView!
    @IBOutlet weak var outputConversionText: UILabel!
    
    typealias Measure = (title:String, standardMultiplier:Float)
    
    //    values are standardized to grams
    let weightMeasure : [Measure] = [("Select", 1.0),
                                     ("Pounds", 453.59237),
                                     ("Ounces", 28.349523125),
                                     ("Stone", 6350.2934),
                                     ("Milligrams", 0.001),
                                     ("Grams", 1.0),
                                     ("Kilograms", 1000.0),
                                     ("Tons", 907184.74)]
    
    // values are standardized on centimeters
    let lengthMeasure : [Measure] = [("Select", 1.0),
                                     ("Inches", 2.54),
                                     ("Feet", 30.48),
                                     ("Yards", 91.44),
                                     ("Miles", 160934.4),
                                     ("Centimeters", 1.0),
                                     ("Meters", 100.0),
                                     ("Kilometers", 100000.0)]
    
    // values are standardized on cups
    let volumeMeasure : [Measure] = [("Select", 1.0),
                                     ("Teaspoons", 48.0),
                                     ("Tablespoons", 16.0),
                                     ("Cups", 1.0),
                                     ("Quarts", 0.25),
                                     ("Gallons", 0.0625),
                                     ("Milliliters", 236.588),
                                     ("Deciliters", 2.36588),
                                     ("Liters", 0.236588)]
    
    var convertFrom : Float = 1.0
    var convertTo : Float = 1.0
    var conversionTable : [Measure] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up picker view
        measurePicker.delegate = self
        measurePicker.dataSource = self
        
        resetInput()
    }
    
    @IBAction func conversionType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            conversionTable = weightMeasure
            print("switch to weight table")
        case 1:
            conversionTable = lengthMeasure
            print("switch to length table")
        case 2:
            conversionTable = volumeMeasure
            print("switch to volume table")
        default :
            conversionTable = weightMeasure
        }
        measurePicker.reloadAllComponents()
        let defaultFrom = 0
        let defaultTo = 0
        measurePicker.selectRow(defaultFrom, inComponent: 0, animated: false)
        measurePicker.selectRow(defaultTo, inComponent: 1, animated: false)
        convertFrom = conversionTable[defaultFrom].standardMultiplier
        convertTo = conversionTable[defaultTo].standardMultiplier
        selectionView.isHidden = false
        measureType.isHidden = true
    }
    
    @IBAction func convertValue(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let inputText = valueToConvertText.text else { return }
        let inputValue : Float = Float(inputText)!
        let answer : Float = inputValue * convertFrom / convertTo
        outputConversionText.text = String(format: "%.4f", answer)
        
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        resetInput()
    }
    
    func resetInput() {
//        measureType.selectedSegmentIndex = 1
        measureType.selectedSegmentIndex = UISegmentedControl.noSegment
        conversionTable = lengthMeasure
        selectionView.isHidden = true
        valueToConvertText.text?.removeAll()
        outputConversionText.text?.removeAll()
        measureType.isHidden = false
    }
    
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conversionTable.count
    }
    
    
    // UPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conversionTable[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            convertFrom = conversionTable[row].standardMultiplier
        case 1:
            convertTo = conversionTable[row].standardMultiplier
        default:
            break
        }
        self.view.endEditing(true)
    }
    
}

