//
//  NewsAssessmentTests.swift
//  NewsAssessmentTests
//
//  Created by Mohammad Abu Maizer on 6/14/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import XCTest
@testable import NewsAssessment

class NewsAssessmentTests: XCTestCase {

    var resultStatus: Int = 0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        var finished = false

        runAsynchCode(){

            print("running asynch code before testing")

            finished = true

        }

        while !finished {
            RunLoop.current.run(mode: RunLoop.Mode.default, before: NSDate.distantFuture)
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // test number of items
    
    func testHttpFetch() {

        let expectation = XCTestExpectation(description: "Data is returned from collection.")
           
        WebServices.getNews(query: "", page: 0, size: 3, sortby: "", order: "", result: { status, news, total  in
               XCTAssert(news.count == 20)
            print(news.count)
               expectation.fulfill()
        }, onFailure: { error in
            
//            finished()
            
            return ()
            
        })
           wait(for: [expectation], timeout: 5)
       }
    
    
    
    
    func runAsynchCode(finished: @escaping () -> Void) {

        print("runAsynchCode : ")

        WebServices.getNews(query: "", page: 0, size: 3, sortby: "", order: "", result: { status, news, total in
            
            print( status )
            
            self.resultStatus = status
            
            
            finished()
            
            return ()
            
        }, onFailure: { error in
            
            finished()
            
            return ()
            
        })
        
    }


    func testNews() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        
        XCTAssertEqual( resultStatus, 1 )
        
    }
    

    
    
    func testPerformanceExample() {
        let expectation = self.expectation(description: "Alert")

        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0, execute: {

            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert(true)
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
