//
//  WeekVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import Foundation

protocol WeekVMContract {
    var isLoading: Bool { get }
    var dailyData: [WeatherDayData] { get set }
    var numberOfDays: Int { get }
    
    func didChangeWeekDataClosure(callback: @escaping () -> Void)
    func weatherDayData(forIndex index: Int) -> WeatherDayData
}

class WeekVM: WeekVMContract {
    private var weekWeatherDataDidChange: (() -> Void)?
    
    public var isLoading: Bool = false
    public var dailyData: [WeatherDayData] = [] {
        didSet {
            weekWeatherDataDidChange?()
        }
    }
    public var numberOfDays: Int {
        dailyData.count
    }
    
    func didChangeWeekDataClosure(callback: @escaping () -> Void) {
        weekWeatherDataDidChange = callback
    }
    func weatherDayData(forIndex index: Int) -> WeatherDayData {
        return dailyData[index]
    }
}
