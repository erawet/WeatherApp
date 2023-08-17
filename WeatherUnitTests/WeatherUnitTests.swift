//
//  WeatherUnitTests.swift
//  WeatherTests
//
//  Created by Don E Wettasinghe on 8/15/23.
//

import XCTest
@testable import Weather

final class WeatherUnitTests: XCTestCase {
    
   // var systemUnderTest: URLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Asynchronous test
    func testValidApiCallGetsHTTPStatusCode200() throws {
      // given
      let urlString =
        "https://api.openweathermap.org/data/2.5/weather?appid=4ae1505d22f0c83fcd013b5e7451f9e7&units=metric&q=Germantown,20874&lat=37.785834&lon=-122.406417"
      let url = URL(string: urlString)!
        
       /*
          Returns XCTestExpectation, stored in promise. description describes what you expect to happen.
       */
      let promise = expectation(description: "Status code: 200")

      // when
      let session = URLSession(configuration: .default)
      let dataTask = session.dataTask(with: url) { _, response, error in
          
          // then
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
              
             /*
               Call this in the success condition closure of the asynchronous method’s completion handler to flag that the expectation has been met.
             */
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
       /*
         Keeps the test running until all expectations are fulfilled or the timeout interval ends, whichever happens first
       */
      wait(for: [promise], timeout: 5)
    }
}
