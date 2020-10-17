//
//  SettingsVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/16/20.
//

import Foundation

enum Section: Int, CaseIterable {
    case time
    case units
    case temperature

    var numberOfRows: Int { 2 }
    var title: String {
        switch self {
        case .time: return "Time Notation"
        case .units: return "Metric Notation"
        case .temperature: return "Temperature Notation"
        }
    }

}

protocol SettingsVMContract {

    var numberOfSections: Int { get }

    func didChangeSettingsClosure(callback: @escaping () -> Void)
    func numberOfRows(forSection section: Int) -> Int
    func label(forIndexPath indexPath: IndexPath) -> (String, Bool)
    func section(for section: Int) -> Section?
    func title(for section: Int) -> String
}

class SettingsVM: SettingsVMContract {

    public var numberOfSections: Int {
        Section.allCases.count
    }

    func didChangeSettingsClosure(callback: @escaping () -> Void) {
        settingsDidChange = callback
    }

    func numberOfRows(forSection section: Int) -> Int {
        let section = Section(rawValue: section)
        return section?.numberOfRows ?? 0
    }

    func label(forIndexPath indexPath: IndexPath) -> (String, Bool) {
        guard let section = Section(rawValue: indexPath.section) else {
            return ("", false)
        }

        switch section {
        case .time:
            let label = indexPath.row == 0 ? "12 Hour" : "24 Hour"
            let isChecked = indexPath.row == UserDefaults.timeNotation.rawValue ? true : false
            return (label, isChecked)
        case .units:
            let label = indexPath.row == 0 ? "Imperial" : "Metric"
            let isChecked = indexPath.row == UserDefaults.unitsNotation.rawValue ? true : false
            return (label, isChecked)
        case .temperature:
            let label = indexPath.row == 0 ? "Fahrenheit" : "Celcius"
            let isChecked = indexPath.row == UserDefaults.temperatureNotation.rawValue ? true : false
            return (label, isChecked)
        }
    }

    func section(for section: Int) -> Section? {
        return Section(rawValue: section)
    }

    func title(for section: Int) -> String {
        guard let section = Section(rawValue: section) else {
            return ""
        }
        return section.title
    }

    private var settingsDidChange: (() -> Void)?

    // MARK: Init
    init() {

    }
}

