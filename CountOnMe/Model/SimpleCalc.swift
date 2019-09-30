//
//  SimpleCalc.swift
//  CountOnMe
//
//  Created by Mélanie Obringer on 18/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class SimpleCalc {
    
    //PROPERTIES
    
    //display
    var calculText: String = "1 + 1 = 2" {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateDisplay"), object: nil, userInfo: ["updateDisplay":calculText])
        }
    }
    
    //separate each elements
    var elements: [String] {
        return calculText.split(separator: " ").map { "\($0)" }
    }
    
    /// check if element at last isn't an operator
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    /// check if expression contains enough elements
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    /// check if expression has a result
    var expressionHaveResult: Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    /// check if a number has been entered
    var arrayIsEmpty: Bool {
        return elements.count == 0
    }
    
    /// check if divisor is zero
    var expressionDivisionByZero: Bool {
        // create a copy variable
        var tempElements = elements
        // iterate while tempElements contains "/"
        while tempElements.contains("/") {
            // get the first index of the division
            guard let index = tempElements.firstIndex(of: "/") else { return false }
            // return true if 0 is behind /
            guard !(tempElements[index + 1] == "0") else { return true }
            // replace / by string to manage each division
            tempElements[index] = String()
        }
        return false
    }
    
    /// check if expression contains "x" or "/"
    var priorityOperator: Bool {
        return (elements.firstIndex(of: "x") != nil) || (elements.firstIndex(of: "/") != nil)
    }
    
    // METHODS
    //
    // send notification with a customed message for errors
    private func sendNotification(message: String) {
        let name = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["message": message])
    }
    
    // append a number
    func tappedNumberButton(numberText: String) {
        refreschCalcul()
        calculText.append(numberText)
    }
    
    /// append an operator
    func tappedOperatorSign(operand: String) {
        //check no operator to start the operation
        refreschCalcul()
        guard !arrayIsEmpty else {
            sendNotification(message: "Démarrez par un chiffre !")
            return calculText = String()
        }
        if expressionIsCorrect {
            calculText.append("\(operand)")
        } else {
            sendNotification(message: "Un opérateur est déja mis !")
        }
    }
    
    // methods for each operator
    func tappedAdditionButton() {
        tappedOperatorSign(operand: " + ")
    }
    func tappedSubstractionButton() {
        tappedOperatorSign(operand: " - ")
    }
    func tappedMultiplicationButton() {
        tappedOperatorSign(operand: " x ")
    }
    func tappedDivisionButton() {
        tappedOperatorSign(operand: " / ")
    }
    
    // clear operation and refresh calcul if expression has result
    func clear() {
        calculText = String()
    }
    
    func refreschCalcul() {
        if expressionHaveResult{
            calculText = ""
        }
    }
    
    // remove dot and zero to display an integer
   private func removeDotZero(result: Double) -> String {
    var doubleAsString = NumberFormatter.localizedString(from: (NSNumber(value: result)), number: .decimal)
        if doubleAsString.contains(",") {
           doubleAsString = doubleAsString.replacingOccurrences(of: ",", with: "")
        }
        return doubleAsString
    }
    
    /// method called when operation contains "x" or "/"
    private func priorityCalcul(elements: [String]) -> [String] {
        var operationsToreduce: [String] = elements
        while operationsToreduce.contains("x") || operationsToreduce.contains("/") {
            if let index = operationsToreduce.firstIndex(where: {$0 == "x" || $0 == "/"}) {
                let operand = operationsToreduce[index]
                guard let left = Double(operationsToreduce[index - 1]) else { return [] }
                guard let right = Double(operationsToreduce[index + 1]) else { return [] }
                let result: Double
                if operand == "x" {
                    result = left * right
                } else {
                    result = left / right
                }
                operationsToreduce[index - 1] = String(removeDotZero(result: result))
                operationsToreduce.remove(at: index + 1)
                operationsToreduce.remove(at: index)
            }
        }
        return operationsToreduce
    }
    
    
    // get the result of the operation
    func tappedEqualButton() {
        refreschCalcul()
        
        guard expressionIsCorrect else {
            sendNotification(message: "Entrez une expression correcte !")
            return
        }
        guard expressionHaveEnoughElement else {
            sendNotification(message: "Entrez une expression correcte !")
            return
        }
        // check if division by zero, return an alert message and reset calcul
        guard !expressionDivisionByZero else {
            sendNotification(message: "La division par zéro est impossible!")
            calculText = String()
            return
        }
        // create local copy of elements
        var operationsToReduce = elements
        // check if operation contains signs x and / (priority operators) to get priority calcul
        if priorityOperator {
            operationsToReduce = priorityCalcul(elements: elements)
        }
        // iterate operations while there's an operator to add and substract
        while operationsToReduce.count > 1 {
            guard let left = Double(operationsToReduce[0]) else { return }
            let operand = operationsToReduce[1]
            guard let right = Double(operationsToReduce[2]) else { return }
            
            var result: Double = 0.0
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default:  sendNotification(message: "Expression incorrecte !")
            }
            // Insert result at index 3
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(removeDotZero(result: result))", at: 0)
        }
        
        // display result at first index
        guard let result = operationsToReduce.first else { return }
        calculText.append(" = \(result)")
    }
}
