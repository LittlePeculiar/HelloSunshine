//
//  WeekVMTests.swift
//  HelloSunshineTests
//
//  Created by Gina Mullins on 10/20/20.
//

import XCTest
import UIKit
@testable import HelloSunshine

class WeekVMTests: XCTestCase {

    var viewModel: WeekVM!

    override func setUpWithError() throws {
        let data = loadStub(name: "weather", ext: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        viewModel = WeekVM()
        viewModel.dailyData = weatherData.dailyData
    }

    override func tearDownWithError() throws {
        // good practice to reset any user values
        UserDefaults.standard.removeObject(forKey: "timeNotation")
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")
    }

    func test_DayData() {
        let dayData = viewModel.weekDayData(forIndex: 5)

        XCTAssertEqual(dayData.dayLabelText, "Friday")
        XCTAssertEqual(dayData.dateLabelText, "June 26")
        XCTAssertEqual(dayData.temperatureLabelText, "64.7 °F - 82.8 °F")
        XCTAssertEqual(dayData.windSpeedLabelText, "6 MPH")
        XCTAssertEqual(dayData.weatherIconName, "clear-day")
    }

}
