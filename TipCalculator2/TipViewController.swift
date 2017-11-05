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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.whiteUnderlineTextField()
        peopleField.whiteUnderlineTextField()
        
        peopleField.text = "1"
        // Do any additional setup after loading the view, typically from a nib.
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
    
    @IBAction func calculateTip(_ sender: Any) {
        
        let tipPercentages = [0.18, 0.2, 0.15]
        
        let index = billField.text!.index(after: billField.text!.startIndex)
        let billString = billField.text![index...]
        let bill = Double(billString) ?? 0
        
        let numPeople = Double(peopleField.text!) ?? 1
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = (bill + tip) / numPeople
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
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
}

