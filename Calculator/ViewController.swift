//
//  ViewController.swift
//  Calculator
//
//  Created by Admin on 8/3/16.
//  Copyright © 2016 Yohoho. All rights reserved.
//

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, forState: forState)
}}

import UIKit

class LabelWithAdaptiveTextHeight: UILabel {
    
   }

class ViewController: UIViewController{
    
    //-= UI =-
    @IBOutlet var resultLabel: StyledLabel!
    
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var changeSignButton: UIButton!
    @IBOutlet var procentButton: UIButton!
    @IBOutlet var divisionButton: UIButton!
    @IBOutlet var multiplicationButton: UIButton!
    @IBOutlet var subtractionButton: UIButton!
    @IBOutlet var additionButton: UIButton!
    @IBOutlet var equalsButton: UIButton!
    @IBOutlet var decimalButton: UIButton!
    
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button0: UIButton!
    
    @IBOutlet var allButtons: [UIButton]!
    
    @IBAction func button7Pressed(sender: UIButton) {
        operateInput("7")
    }
    @IBAction func button8Pressed(sender: UIButton) {
        operateInput("8")
    }
    @IBAction func button9Pressed(sender: UIButton) {
        operateInput("9")
    }
    @IBAction func button4Pressed(sender: UIButton) {
        operateInput("4")
    }
    @IBAction func button5Pressed(sender: UIButton) {
        operateInput("5")
    }
    @IBAction func button6Pressed(sender: UIButton) {
        operateInput("6")
    }
    @IBAction func button1Pressed(sender: UIButton) {
        operateInput("1")
    }
    @IBAction func button2Pressed(sender: UIButton) {
        operateInput("2")
    }
    @IBAction func button3Pressed(sender: UIButton) {
        operateInput("3")
    }
    @IBAction func button0Pressed(sender: UIButton) {
        operateInput("0")
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        userInput = ""
        accumulator = 0
        updateDisplay()
        numberStack.removeAll()
        operatorStack.removeAll()
    }
    
    @IBAction func changeSignButtonPressed(sender: UIButton) {
        if userInput.isEmpty {
            userInput = resultLabel.text!
        }
        operateInput("-")
    }
    
    @IBAction func procentButtonPressed(sender: UIButton) {
        //!!!
    }
    
    @IBAction func divisionButtonPressed(sender: UIButton) {
        doMath("/")
    }
    
    @IBAction func multiplicationButtonPressed(sender: UIButton) {
        doMath("*")
    }
    
    @IBAction func subtractionButtonPressed(sender: UIButton) {
        doMath("-")
    }
    
    @IBAction func additionButtonPressed(sender: UIButton) {
        doMath("+")
    }
    
    @IBAction func equalsButtonPressed(sender: UIButton) {
        doEquals()
    }
    
    @IBAction func decimalButtonPressed(sender: UIButton) {
        if hasIndex(stringToSearch: userInput, characterToFind: ".") == false {
            operateInput(".")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.deviceRotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        // KVO ResultLabel signing
        resultLabel.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        
        updateButtons()
        resultLabel.text = "0"
    }
    
    // KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "text") {
            resultLabel.layoutSubviews()
        }
    }
    
    func updateButtons() {
        for button in allButtons {
            let borderWidth:CGFloat = 2.0;
            button.frame = CGRectInset(button.frame, -borderWidth, -borderWidth)
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.borderWidth = borderWidth
            button.setBackgroundColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }
        divisionButton.setBackgroundColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        multiplicationButton.setBackgroundColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        subtractionButton.setBackgroundColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        additionButton.setBackgroundColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        equalsButton.setBackgroundColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deviceRotated() {
        //updateButton0()
    }
    
    override func viewWillLayoutSubviews() {
        //updateButton0()
    }
    
    func updateButton0() {
        button0.contentHorizontalAlignment = .Left
        let inset = (button0.frame.width/2 - (button0.titleLabel?.intrinsicContentSize().width)!)/2
        //print("Inset: \(inset)")
        button0.titleEdgeInsets = UIEdgeInsetsMake(0.0, inset, 0.0, 0.0)
    }
    
    // -= Logic =-
    var accumulator: Double = 0.0 // Store the calculated value here
    var userInput = "" // User-entered digits
    
    var numberStack: [Double] = [] // Number stack
    var operatorStack: [String] = [] // Operator stack
    
    // Looks for a single character in a string.
    func hasIndex(stringToSearch string: String, characterToFind charter: Character) -> Bool {
        for chr in string.characters {
            if chr == charter {
                return true
            }
        }
        return false
    }
    
    func operateInput(string: String) {
        if string == "-" {
            if userInput.hasPrefix(string) {
                // Strip off the first character (a dash)
                userInput = userInput.substringFromIndex(userInput.startIndex.successor())
            } else {
                userInput = string + userInput
            }
        } else {
            userInput += string
        }
        accumulator = Double((userInput as NSString).doubleValue)
        updateDisplay()
    }
    
    func updateDisplay() {
        // If the value is an integer, don't show a decimal point
        let intAccumulator = Int(accumulator)
        if accumulator - Double(intAccumulator) == 0 {
            resultLabel.text = "\(intAccumulator)"
        } else {
            resultLabel.text = "\(accumulator)"
        }
    }
    
    func doMath(newOperation: String) {
        if userInput != "" && !numberStack.isEmpty {
            let stackOperation = operatorStack.last
            if !((stackOperation == "+" || stackOperation == "-") && (newOperation == "*" || newOperation == "/")) {
                let operation = operations[operatorStack.removeLast()]
                accumulator = operation!(numberStack.removeLast(), accumulator)
                doEquals()
            }
        }
        operatorStack.append(newOperation)
        numberStack.append(accumulator)
        userInput = ""
        updateDisplay()
    }
    
    func doEquals() {
        if userInput == "" {
            return
        }
        if !numberStack.isEmpty {
            let operation = operations[operatorStack.removeLast()]
            accumulator = operation!(numberStack.removeLast(), accumulator)
            if !operatorStack.isEmpty {
                doEquals()
            }
        }
        updateDisplay()
        userInput = ""
    }

}

// Basic mathematic operations
func addition(a: Double, b: Double) -> Double {
    let result = a + b
    return result
}
func substraction(a: Double, b: Double) -> Double {
    let result = a - b
    return result
}
func multiplication(a: Double, b: Double) -> Double {
    let result = a * b
    return result
}
func division(a: Double, b: Double) -> Double {
    let result = a / b
    return result
}

typealias BinaryOperation = (Double, Double) -> Double
let operations: [String: BinaryOperation] = [ "+" : addition, "-" : substraction, "*" : multiplication, "/" : division ]
