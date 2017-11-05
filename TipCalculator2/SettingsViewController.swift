//
//  SettingsViewController.swift
//  TipCalculator2
//
//  Created by Timothy Mak on 11/3/17.
//  Copyright © 2017 Timothy Mak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTipControl: UISegmentedControl!
    @IBOutlet weak var firstTipField: UITextField!
    @IBOutlet weak var secondTipField: UITextField!
    @IBOutlet weak var thirdTipField: UITextField!
    
    // Default tip percentages that are initially set
    var tipPercentages = [0.15, 0.18, 0.2]
    
    // Default tip percentage that is currently being used
    var tipPercent = 0.0
    
    // Default tip values
    let defaultTip1 = 0.15
    let defaultTip2 = 0.18
    let defaultTip3 = 0.20
    
    // Used to save and load saved values
    let defaults = UserDefaults.standard
    
    let tipKey = "defaultTip"
    let customTipKey1 = "customTipKey1"
    let customTipKey2 = "customTipKey2"
    let customTipKey3 = "customTipKey3"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstTipField.darkUnderlineTextField()
        secondTipField.darkUnderlineTextField()
        thirdTipField.darkUnderlineTextField()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTipPercentages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setDefaultTip(_ sender: Any) {
        // Set the default tip percentage and save it
        defaults.set(tipPercentages[settingsTipControl.selectedSegmentIndex], forKey: tipKey)
        defaults.synchronize()
    }
    
    @IBAction func changeCustomTip1(_ sender: Any) {
        let tipValue = Double(firstTipField.text!) ?? 0
        setCustomTip(tip: tipValue, index: 0)
    }
    @IBAction func changeCustomTip2(_ sender: Any) {
        let tipValue = Double(secondTipField.text!) ?? 0
        setCustomTip(tip: tipValue, index: 1)
    }
    @IBAction func changeCustomTip3(_ sender: Any) {
        let tipValue = Double(thirdTipField.text!) ?? 0
        setCustomTip(tip: tipValue, index: 2)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    func setCustomTip(tip: Double, index: Int) {
        
        var customTipKey: String = ""
        var defaultTip: Double
        
        if index == 0 {
            customTipKey = customTipKey1
            defaultTip = defaultTip1
        }
        else if index == 1 {
            customTipKey = customTipKey2
            defaultTip = defaultTip2
        }
        else {
            customTipKey = customTipKey3
            defaultTip = defaultTip3
        }
        
        // tip1 value is between 0 and 100 exclusive
        if(tip > 0 && tip < 100){
            
            // Set the first segment to the new tip value
            settingsTipControl.setTitle(String(format: "%.0f", tip) + "%", forSegmentAt: index)
            
            // Divide the tip by 100 to get the percentage value
            let tipPercentage = tip / 100
            
            // Update the tip percentage in the tipPercentages array
            tipPercentages[index] = tipPercentage
            
            // Update the tip key if the selected tip was changed
            if(settingsTipControl.selectedSegmentIndex == index){
                defaults.set(tipPercentage, forKey: tipKey)
            }
            
            // Save the new default tip percentage
            defaults.set(tipPercentage, forKey: customTipKey)
            defaults.synchronize()
        }
            
        // tip is an invalid tip value
        else{
            
            // Set the segment to the default tip value
            settingsTipControl.setTitle(String(format: "%.0f", tipPercentages[index] * 100) + "%", forSegmentAt: index)
            
            // Update the tip percentage in the tipPercentages array to defaultTip
            tipPercentages[index] = defaultTip
            
            // Update the tip key if the selected tip was changed
            if(settingsTipControl.selectedSegmentIndex == index){
                defaults.set(tipPercentages[index], forKey: tipKey)
            }
            
            // Save the new default tip percentage
            defaults.set(tipPercentages[index], forKey: customTipKey)
            defaults.synchronize()
            
        }
    }
    
    func loadTipPercentages() {
        // Load the default tip percentages
        var custom1 = defaults.double(forKey: customTipKey1)
        var custom2 = defaults.double(forKey: customTipKey2)
        var custom3 = defaults.double(forKey: customTipKey3)
        
        // If any tip percentages are 0%, set them to the default tip values
        if(custom1 == 0){
            custom1 = tipPercentages[0]
        }
        if(custom2 == 0){
            custom2 = tipPercentages[1]
        }
        if(custom3 == 0){
            custom3 = tipPercentages[2]
        }
        
        // Update the tipPercentages array values
        tipPercentages[0] = custom1
        tipPercentages[1] = custom2
        tipPercentages[2] = custom3
        
        // Multiply the default tip percentages by 100
        custom1 = custom1 * 100
        custom2 = custom2 * 100
        custom3 = custom3 * 100
        
        // Set the segment control titles to the 3 default tip percentages
        settingsTipControl.setTitle(String(format: "%.0f", custom1) + "%", forSegmentAt: 0)
        settingsTipControl.setTitle(String(format: "%.0f", custom2) + "%", forSegmentAt: 1)
        settingsTipControl.setTitle(String(format: "%.0f", custom3) + "%", forSegmentAt: 2)
        
        firstTipField.text = String(format: "%.0f", custom1)
        secondTipField.text = String(format: "%.0f", custom2)
        thirdTipField.text = String(format: "%.0f", custom3)

        // Load the default tip key
        tipPercent = defaults.double(forKey: tipKey)
        
        if(tipPercent == tipPercentages[0]){
            settingsTipControl.selectedSegmentIndex = 0
        }
        else if(tipPercent == tipPercentages[1]){
            settingsTipControl.selectedSegmentIndex = 1
        }
        else{
            settingsTipControl.selectedSegmentIndex = 2
        }
    }
}
