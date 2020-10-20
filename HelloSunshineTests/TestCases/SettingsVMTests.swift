//
//  SettingsVMTests.swift
//  HelloSunshineTests
//
//  Created by Gina Mullins on 10/19/20.
//

import XCTest
@testable import HelloSunshine

class SettingsVMTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // good practice to reset any user values
        UserDefaults.standard.removeObject(forKey: "timeNotation")
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")

    }

    func test_Sections() {
        let viewModel = SettingsVM()
        var indexPath = IndexPath(row: 0, section: 0)

        // test time values

        let timeNot: TimeNotation = .twelveHour
        UserDefaults.standard.set(timeNot.rawValue, forKey: "timeNotation")

        guard let sectionTime = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionTime == .time {
            let time = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(time.0, "12 Hour")
            XCTAssertEqual(time.1, true)
        } else {
            XCTAssertEqual(sectionTime, .time)
        }


        // test metric values
        indexPath = IndexPath(row: 0, section: 1)

        let unitNot: UnitsNotation = .imperial
        UserDefaults.standard.set(unitNot.rawValue, forKey: "unitsNotation")

        guard let sectionUnit = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionUnit == .units {
            let metric = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(metric.0, "Imperial")
            XCTAssertEqual(metric.1, true)
        } else {
            XCTAssertEqual(sectionUnit, .units)
        }

        // test temperature values
        indexPath = IndexPath(row: 0, section: 2)

        let tempNot: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(tempNot.rawValue, forKey: "temperatureNotation")

        guard let sectionTemp = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionTemp == .temperature {
            let temp = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(temp.0, "Fahrenheit")
            XCTAssertEqual(temp.1, true)
        } else {
            XCTAssertEqual(sectionTemp, .temperature)
        }
    }

    func test_Rows() {
        let viewModel = SettingsVM()
        var indexPath = IndexPath(row: 1, section: 0)

        // test time values

        let timeNot: TimeNotation = .twentyFourHour
        UserDefaults.standard.set(timeNot.rawValue, forKey: "timeNotation")

        guard let sectionTime = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionTime == .time {
            let time = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(time.0, "24 Hour")
            XCTAssertEqual(time.1, true)
        } else {
            XCTAssertEqual(sectionTime, .time)
        }

        // test metric values
        indexPath = IndexPath(row: 1, section: 1)

        let unitNot: UnitsNotation = .metric
        UserDefaults.standard.set(unitNot.rawValue, forKey: "unitsNotation")

        guard let sectionUnit = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionUnit == .units {
            let metric = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(metric.0, "Metric")
            XCTAssertEqual(metric.1, true)
        } else {
            XCTAssertEqual(sectionUnit, .units)
        }

        // test temperature values
        indexPath = IndexPath(row: 1, section: 2)

        let tempNot: TemperatureNotation = .celsius
        UserDefaults.standard.set(tempNot.rawValue, forKey: "temperatureNotation")

        guard let sectionTemp = Section(rawValue: indexPath.section) else {
            XCTFail("Section failed to be created from indexPath.section: /(indexPath.section)")
            return
        }
        if sectionTemp == .temperature {
            let temp = viewModel.label(forIndexPath: indexPath)
            XCTAssertEqual(temp.0, "Celcius")
            XCTAssertEqual(temp.1, true)
        } else {
            XCTAssertEqual(sectionTemp, .temperature)
        }
    }
}
