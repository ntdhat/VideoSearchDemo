//
//  VideoSearchDemoUITests.swift
//  VideoSearchDemoUITests
//
//  Created by admin on 1/20/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

import XCTest
@testable import VideoSearchDemo

class VideoSearchDemoUITests: XCTestCase {
    var app: XCUIApplication!
    var searchFieldElement: XCUIElement!
    var tablesQuery: XCUIElementQuery!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        searchFieldElement = app.searchFields["Search"]
        tablesQuery = app.tables

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        super.tearDown()
    }
    
    func test_KeyboardShownWhenSearching() {
        searchFieldElement.tap()
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
    }
    
    func test_KeboardDismissedWhenSearchingCompleted() {
        searchFieldElement.tap()
        searchFieldElement.typeText("abc")
        app/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertFalse(app/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
    }
    
    func test_SearchVideoResultCellsLoaded() {
        // Generate a searching action
        searchFieldElement.tap()
        searchFieldElement.typeText("harry potter")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Create the expectation of tableview's cells is created
        let predication = NSPredicate(format: "isHittable == 1")
        let cellElem = self.tablesQuery.cells.matching(identifier: "SearchVideoResultCell").element(boundBy: 0)
        expectation(for: predication, evaluatedWith: cellElem, handler: nil)
        
        // When expectation is fulfilled/timeout
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            // Test whether the SearchVideoResultCell visible
            XCTAssertTrue(cellElem.isHittable)
        }
    }
    
    func test_Temp() {
        // Generate a searching action
        searchFieldElement.tap()
        searchFieldElement.typeText("harry potter")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Create the expectation of tableview's cells is created
        let predication = NSPredicate(format: "isHittable == 1")
        let cellElem = tablesQuery.cells.matching(identifier: "SearchVideoResultCell").element(boundBy: 0)
        let exp1 = expectation(for: predication, evaluatedWith: cellElem, handler: nil)
        wait(for: [exp1], timeout: 5)
        
        tablesQuery.cells.element(boundBy: 0).tap()
        
        let predication2 = NSPredicate(format: "exists == 1")
        let detailVC = app.otherElements["Video Detail VC"]
        let exp2 = expectation(for: predication2, evaluatedWith: detailVC, handler: nil)
        wait(for: [exp2], timeout: 3)
        
        XCTAssertTrue(detailVC.exists)
    }
}
