//
//  SimpleCalcTests.swift
//  CountOnMeTests
//
//  Created by Mélanie Obringer on 18/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var simpleCalc: SimpleCalc!
    
    
    // Setup
    override func setUp() {
        super.setUp()
        simpleCalc = SimpleCalc()
    }
    // test operations
    // test addition
    func testGivenOneAddTwo_WhenTappedEqualButton_ThenResultIsThree() {
        simpleCalc.tappedNumberButton(numberText: "1")
        simpleCalc.tappedAdditionButton()
        simpleCalc.tappedNumberButton(numberText: "2")
        simpleCalc.tappedEqualButton()
        
        XCTAssertTrue(simpleCalc.expressionIsCorrect)
        XCTAssertTrue(simpleCalc.expressionHaveEnoughElement)
        XCTAssertEqual(simpleCalc.calculText, "1 + 2 = 3")
        XCTAssertEqual(simpleCalc.calculText.last, "3")
    }
    
    // test substraction
    func testGivenTwoSubbstractOne_WhenTappedEqualButton_ThenResultIsOne() {
        simpleCalc.tappedNumberButton(numberText: "2")
        simpleCalc.tappedSubstractionButton()
        simpleCalc.tappedNumberButton(numberText: "1")
        simpleCalc.tappedEqualButton()
        
        XCTAssertTrue(simpleCalc.expressionIsCorrect)
        XCTAssertTrue(simpleCalc.expressionHaveEnoughElement)
        XCTAssertEqual(simpleCalc.calculText, "2 - 1 = 1")
        XCTAssertEqual(simpleCalc.calculText.last, "1")
    }
    
    // test division
    func testGivenFourDivideByTwo_WhenTappedEqualButton_ThenResultIsTwo() {
        simpleCalc.tappedNumberButton(numberText: "3")
        simpleCalc.tappedDivisionButton()
        simpleCalc.tappedNumberButton(numberText: "2")
        simpleCalc.tappedEqualButton()
        
        XCTAssertTrue(simpleCalc.expressionIsCorrect)
        XCTAssertTrue(simpleCalc.expressionHaveEnoughElement)
        XCTAssertEqual(simpleCalc.calculText, "3 / 2 = 1.5")
        
    }
    
    // test multiplication
    func testGivenThreeMultiplyByTwo_WhenTappedEqualButton_ThenResultIsSix() {
        simpleCalc.tappedNumberButton(numberText: "3")
        simpleCalc.tappedMultiplicationButton()
        simpleCalc.tappedNumberButton(numberText: "2")
        simpleCalc.tappedEqualButton()
        
        XCTAssertTrue(simpleCalc.expressionIsCorrect)
        XCTAssertTrue(simpleCalc.expressionHaveEnoughElement)
        XCTAssertEqual(simpleCalc.calculText, "3 x 2 = 6")
        
    }
    
    // test priority calcul
    func testGivenCalculAllOperators_WhenTappedEqualButton_ThenResultIsOk() {
        simpleCalc.tappedNumberButton(numberText: "333")
        simpleCalc.tappedAdditionButton()
        simpleCalc.tappedNumberButton(numberText: "555")
        simpleCalc.tappedSubstractionButton()
        simpleCalc.tappedNumberButton(numberText: "222")
        simpleCalc.tappedMultiplicationButton()
        simpleCalc.tappedNumberButton(numberText: "333")
        simpleCalc.tappedDivisionButton()
        simpleCalc.tappedNumberButton(numberText: "22")
        simpleCalc.tappedEqualButton()
        
        XCTAssertTrue(simpleCalc.expressionIsCorrect)
        XCTAssertTrue(simpleCalc.expressionHaveEnoughElement)
        XCTAssertEqual(simpleCalc.calculText, "333 + 555 - 222 x 333 / 22 = -2472.273")
    }
    
    // Test - Division by zero
    func testGivenDivisionByZeroImpossible_WhenDivisionByZero_ThenIsFalse() {
        simpleCalc.tappedNumberButton(numberText: "1")
        simpleCalc.tappedDivisionButton()
        simpleCalc.tappedNumberButton(numberText: "0")
        simpleCalc.tappedEqualButton()
        
        XCTAssertFalse(simpleCalc.expressionDivisionByZero)
    }
    
    // Test - Button Clear
    func testGivenClearTextView_WhenTappedClear_ThenItClear() {
        simpleCalc.tappedNumberButton(numberText: "3")
        simpleCalc.clear()
        XCTAssertEqual(simpleCalc.calculText, String())
    }
    
    // Test - Error
    // Expression doesn't have enough elements, tapped 3 and equal
    func testGivenCalculWithOneNumber_WhenExpressionHaveNotEnoughElement_ThenMessageErrorExpression() {
        simpleCalc.tappedNumberButton(numberText: "3")
        simpleCalc.tappedEqualButton()
        
        XCTAssertFalse(simpleCalc.expressionHaveEnoughElement)
    }
    
    // Tapped = without number
    func testGivenCalculWithoutNumber_WhenTappedEqualButton_ThenMessageErrorStartWithNumber() {
        simpleCalc.tappedEqualButton()
        
        XCTAssertEqual(simpleCalc.calculText, String())
    }
    
    // Error tapped 2 operators, tapped 1 + x =
    func testGivenCalculWithTwoOperandsSuccessive_WhenExpressionHaveEnoughElements_ThenMessageErrorOperator() {
        simpleCalc.tappedNumberButton(numberText: "1")
        simpleCalc.tappedAdditionButton()
        simpleCalc.tappedDivisionButton()
        
        XCTAssertFalse(simpleCalc.expressionHaveEnoughElement)
        XCTAssertFalse(simpleCalc.expressionIsCorrect)
        XCTAssertEqual(simpleCalc.calculText, "1 + ")
    }
    
    // Error calcul start with operator
    func testGivenCalculWithOperatorAtFirst_WhenArrayIsEmpty_ThenMessageErrorAddNumber() {
        simpleCalc.tappedDivisionButton()
        
        XCTAssertTrue(simpleCalc.arrayIsEmpty)
        XCTAssertEqual(simpleCalc.calculText, String())
    }
    
    // Expression is incorrect, tapped 3 + 5 x =
    func testGivenCalculWithOperandAndEgalSucessive_WhenExpressionIsIncorrect_ThenMessageErrorExpression() {
        simpleCalc.tappedNumberButton(numberText: "3")
        simpleCalc.tappedAdditionButton()
        simpleCalc.tappedNumberButton(numberText: "5")
        simpleCalc.tappedMultiplicationButton()
        simpleCalc.tappedEqualButton()
        
        XCTAssertFalse(simpleCalc.expressionIsCorrect)
        XCTAssertEqual(simpleCalc.calculText, "3 + 5 x ")
    }
}
