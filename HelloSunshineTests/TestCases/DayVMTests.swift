//
//  DayVMTests.swift
//  HelloSunshineTests
//
//  Created by Gina Mullins on 10/20/20.
//

import XCTest
import UIKit
@testable import HelloSunshine


class DayVMTests: XCTestCase {

    var viewModel: DayVM!

    override func setUpWithError() throws {
        let data = loadStub(name: "weather", ext: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        viewModel = DayVM()
        viewModel.weatherData = weatherData
    }

    override func tearDownWithError() throws {
        // good practice to reset any user values
        UserDefaults.standard.removeObject(forKey: "timeNotation")
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")
    }

    func test_Date() {
        XCTAssertEqual(viewModel.dateLabelText, "Mon, June 22")
    }

    func test_Time() {
        let timeNot: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNot.rawValue, forKey: "timeNotation")
        XCTAssertEqual(viewModel.timeLabelText, "07:53 AM")

        // todo - test 24 hour - not converting properly
    }

    func test_Units() {
        let tempNot: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(tempNot.rawValue, forKey: "temperatureNotation")
        XCTAssertEqual(viewModel.temperatureLabelText, "68.7 °F")
    }

    func test_Windspeed() {
        let unitNot: UnitsNotation = .imperial
        UserDefaults.standard.set(unitNot.rawValue, forKey: "unitsNotation")
        XCTAssertEqual(viewModel.windSpeedLabelText, "6 MPH")
    }

    func test_Image() {
        let image = Utils.shared.imageForIcon(withName: viewModel.weatherData.icon)
        let imageData = image?.pngData()!
        let imageDataRef = UIImage(named: "cloudy")!.pngData()!

        XCTAssertNotNil(image)
        XCTAssertEqual(imageData, imageDataRef)
    }
}
