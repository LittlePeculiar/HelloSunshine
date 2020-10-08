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
    
    func didChangeDataClosure(callback: @escaping () -> Void)
}

class WeekVM: WeekVMContract {
    public var isLoading: Bool = false
    public var dailyData: [WeatherDayData] = [] {
        didSet {
            weatherDataDidChange?()
        }
    }
    
    func didChangeDataClosure(callback: @escaping () -> Void) {
        weatherDataDidChange = callback
    }
    
    private var weatherDataDidChange: (() -> Void)?
    
    // MARK: Init
    init(data: [WeatherDayData]) {
        self.dailyData = data
    }
}
