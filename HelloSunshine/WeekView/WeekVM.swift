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
    
    func didChangeDataClosure(callback: @escaping () -> Void)
    func weatherDayData(forIndex index: Int) -> WeatherDayData
}

class WeekVM: WeekVMContract {
    public var isLoading: Bool = false
    public var dailyData: [WeatherDayData] = [] {
        didSet {
            weatherDataDidChange?()
        }
    }
    public var numberOfDays: Int {
        dailyData.count
    }
    
    func didChangeDataClosure(callback: @escaping () -> Void) {
        weatherDataDidChange = callback
    }
    func weatherDayData(forIndex index: Int) -> WeatherDayData {
        return dailyData[index]
    }
    
    private var weatherDataDidChange: (() -> Void)?
    
    // MARK: Init
    init(data: [WeatherDayData]) {
        self.dailyData = data
    }
}
