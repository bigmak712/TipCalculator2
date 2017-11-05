//
//  ViewController.swift
//  TipCalculator2
//
//  Created by Timothy Mak on 11/1/17.
//  Copyright © 2017 Timothy Mak. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var peopleField: UITextField!
    
    // Default tip percentages that are initially set
    var tipPercentages = [0.15, 0.18, 0.2]
    
    // Default tip percentage that is currently being used
    var tipPercent = 0.0
    
    // Used to save and load saved values
    let defaults = UserDefaults.standard
    
    let tipKey = "defaultTip"
    let customTipKey1 = "customTipKey1"
    let customTipKey2 = "customTipKey2"
    let customTipKey3 = "customTipKey3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.whiteUnderlineTextField()
        peopleField.whiteUnderlineTextField()
        
        peopleField.text = "1"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)

        billField.text = "$"
        tipLabel.text = "$0.00"
        peopleField.text = "1"
        totalLabel.text = "$0.00 / $0.00"
        
        loadTipPercentages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addSymbolToBill(_ sender: Any) {
        billField.text = "$"
    }
    
    @IBAction func setPeopleToOne(_ sender: Any) {
        if peopleField.text == "" {
            peopleField.text = "1"
        }
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func tipPercentageChanged(_ sender: Any) {
        // Set the default tip percentage and save it
        defaults.set(tipPercentages[tipControl.selectedSegmentIndex], forKey: tipKey)
        defaults.synchronize()
        
        calculateTip(self)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        let index = billField.text!.index(after: billField.text!.startIndex)
        let billString = billField.text![index...]
        let bill = Double(billString) ?? 0
        
        let numPeople = Double(peopleField.text!) ?? 1
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = (bill + tip)
        let splitTotal = total / numPeople
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total) + " / " + String(format: "$%.2f", splitTotal)
    }
    
    func loadTipPercentages() {
        // Get the custom tip percentages
        var custom1 = defaults.double(forKey: customTipKey1)
        var custom2 = defaults.double(forKey: customTipKey2)
        var custom3 = defaults.double(forKey: customTipKey3)
        
        // If any tip percentages are 0%, set them to the default tip percentages
        if(custom1 == 0){
            custom1 = tipPercentages[0]
        }
        if(custom2 == 0){
            custom2 = tipPercentages[1]
        }
        if(custom3 == 0){
            custom3 = tipPercentages[2]
        }
        
        // Set the values in the tipPercentages array
        tipPercentages[0] = custom1
        tipPercentages[1] = custom2
        tipPercentages[2] = custom3
        
        // Load the default tip key
        tipPercent = defaults.double(forKey: tipKey)
        
        // If tipPercent is 0, set it to default tip value 0.15 and save it
        if(tipPercent == 0){
            tipPercent = 0.15
            defaults.set(tipPercent, forKey: tipKey)
            defaults.synchronize()
        }
        
        // Set the selected tipControl segment
        if(tipPercent == tipPercentages[0]){
            tipControl.selectedSegmentIndex = 0
        }
        else if(tipPercent == tipPercentages[1]){
            tipControl.selectedSegmentIndex = 1
        }
        else{
            tipControl.selectedSegmentIndex = 2
        }
        
        // Multiply the custom tip percentages by 100
        custom1 = custom1 * 100
        custom2 = custom2 * 100
        custom3 = custom3 * 100
        
        // Set the titles in the segment control to the custom tip percentages
        tipControl.setTitle(String(format: "%.0f", custom1) + "%", forSegmentAt: 0)
        tipControl.setTitle(String(format: "%.0f", custom2) + "%", forSegmentAt: 1)
        tipControl.setTitle(String(format: "%.0f", custom3) + "%", forSegmentAt: 2)
    }
}

extension UITextField{
    func whiteUnderlineTextField(){
        let border = CALayer()
        let width = CGFloat(0.75)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func darkUnderlineTextField(){
        let border = CALayer()
        let width = CGFloat(0.75)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

