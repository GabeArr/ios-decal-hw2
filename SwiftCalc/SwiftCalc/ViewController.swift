//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    var numbersAndOperators: [(value: String, type: String)] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        print(content)
        resultLabel.text = content
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        let num1 = numbersAndOperators[0].0
        let op = numbersAndOperators[1].0
        let num2 = numbersAndOperators[2].0
        var decimal_index = 0
        var trailing_zeros = 0
        if (num1.characters.index(of: ".") != nil || num2.characters.index(of: ".") != nil || op == "/") {
            var result = String(calculate(a: num1, b: num2, operation: op))
            if (result.characters.count > 7) {
                let index = result.index(result.startIndex, offsetBy: 7)
                result = result.substring(to:index)
            }
            if (result.characters.index(of: ".") != nil) {
                for (index, element) in result.characters.enumerated() {
                    if (decimal_index != 0) {
                        if (element != "0") {
                            trailing_zeros = 1
                        }
                    }
                    if (element == ".") {
                        decimal_index = index
                    }
                }
                if (trailing_zeros == 0) {
                    let another_index = result.index(result.startIndex, offsetBy: decimal_index)
                    result = result.substring(to:another_index)
                }
            }
            return result
        } else {
            return String(intCalculate(a: Int(num1)!, b: Int(num2)!, operation: op))
        }
        //return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        if (operation == "+") {
            return a + b
        } else if (operation == "-") {
            return a - b
        } else if (operation == "*") {
            return a * b
        } else if (operation == "/") {
            return a / b
        }
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        if (operation == "+") {
            return Double(a)! + Double(b)!
        } else if (operation == "-") {
            return Double(a)! - Double(b)!
        } else if (operation == "*") {
            return Double(a)! * Double(b)!
        } else if (operation == "/") {
            return Double(a)! / Double(b)!
        }

        return 0.0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")

        if (numbersAndOperators.isEmpty) {
            numbersAndOperators.append((value: sender.content, type: "input"))
            updateResultLabel(sender.content)
        } else {
            let lastElem = numbersAndOperators[numbersAndOperators.count - 1]
            if (lastElem.1 == "operator") {
                numbersAndOperators.append((value: sender.content, type: "input"))
                updateResultLabel(sender.content)
            }else if (lastElem.1 != "calculation" && lastElem.0.characters.count < 7) {
                numbersAndOperators.removeLast()
                if (lastElem.0 == "0") {
                    numbersAndOperators.append((value:sender.content, type: "input"))
                    updateResultLabel(sender.content)
                } else {
                    numbersAndOperators.append((value: lastElem.0 + sender.content, type: "input"))
                    updateResultLabel(lastElem.0 + sender.content)
                }
            }
        }
        // Fill me in!
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        guard String(sender.content) != nil else {return}
        print("The operation \(sender.content) was pressed")
        
        let arithmetic_operations: [String] = ["+", "-", "*", "/"]
        if (arithmetic_operations.contains(sender.content)) {
            if (numbersAndOperators.isEmpty) {
                numbersAndOperators.append((value: "0", type: "input"))
                numbersAndOperators.append((value: sender.content, type: "operator"))
            } else if (numbersAndOperators.count == 3) {
                let calculation = calculate()
                
                
                numbersAndOperators.removeAll()
                numbersAndOperators.append((value: calculation, type: "calculation"))
                if (sender.content != "=") {
                    numbersAndOperators.append((value: sender.content, type: "operator"))
                }
                updateResultLabel(calculation)
            } else if (numbersAndOperators[numbersAndOperators.count - 1].1 == "operator") {
                numbersAndOperators.removeLast()
                numbersAndOperators.append((value: sender.content, type: "operator"))
            } else {
                if (sender.content != "=") {
                    numbersAndOperators.append((value: sender.content, type: "operator"))
                }
            }

        } else if (sender.content == "C") {
            numbersAndOperators.removeAll()
            updateResultLabel("0")
        } else if (sender.content == "+/-") {
            var lastElem = numbersAndOperators[numbersAndOperators.count - 1]
            if (lastElem.1 == "operator") {
                numbersAndOperators.removeLast()
                lastElem = numbersAndOperators[numbersAndOperators.count - 1]
            }
            let value = String(Int(lastElem.0)! * -1)
            if (value.characters.count > 7) {
                return
            }
            let type = lastElem.1
            numbersAndOperators.removeLast()
            numbersAndOperators.append((value: value, type: type))
            updateResultLabel(value)
            
            
        } else if (sender.content == "=") {
            print("what is going on")
            print(numbersAndOperators.count)
            for elem in numbersAndOperators {
                print(elem)
            }
            if(numbersAndOperators.isEmpty) {
                updateResultLabel("0")
            } else if (numbersAndOperators.count == 3){
                print("i should be calculating")
                updateResultLabel(calculate())
            }
        }
        
        // Fill me in!
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        guard String(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        
        if (sender.content == "0"){
            if (!numbersAndOperators.isEmpty) {
                let lastElem = numbersAndOperators[numbersAndOperators.count - 1]
                if (lastElem.1 != "calculation" && lastElem.0.characters.count < 7 && lastElem.0 != "0"){
                    print("first if statement for 0")
                    numbersAndOperators.removeLast()
                    numbersAndOperators.append((value: lastElem.0 + sender.content, type: "input"))
                    updateResultLabel(lastElem.0 + sender.content)
                } else if (lastElem.1 == "calculation" && lastElem.0.characters.count < 7){
                    print("second if statement for 0")
                    numbersAndOperators.removeLast()
                    numbersAndOperators.append((value: sender.content, type: "input"))
                    updateResultLabel(sender.content)
                } else if (lastElem.1 == "operator") {
                    print("we have an operation boys and girls. lets add 0")
                    numbersAndOperators.append((value: sender.content, type: "input"))
                    updateResultLabel(sender.content)
                }
            }
            else {
                print("I'M ADDING 0")
                numbersAndOperators.append((value: sender.content, type: "input"))
                updateResultLabel(sender.content)
                
            }
        } else if (sender.content == ".") {
            
        }
        
        if (sender.content == ".") {
            if (numbersAndOperators.isEmpty) {
                numbersAndOperators.append((value: "0" + sender.content, type: "input"))
                updateResultLabel("0" + sender.content)
            } else {
                let lastElem = numbersAndOperators[numbersAndOperators.count - 1]
                if (lastElem.1 == "input") {
                    if (lastElem.0.characters.index(of: ".") != nil) {
                        return
                    }
                    numbersAndOperators.removeLast()
                    numbersAndOperators.append((value: lastElem.0 + sender.content, type: "input"))
                    updateResultLabel(lastElem.0 + sender.content)
                } else if (lastElem.1 == "operator") {
                    numbersAndOperators.append((value: "0" + sender.content, type: "input"))
                    updateResultLabel("0" + sender.content)
                }
            }
        }
               // Fill me in!
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

