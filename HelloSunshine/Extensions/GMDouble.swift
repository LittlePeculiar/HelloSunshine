//
//  GMDouble.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/7/20.
//

import Foundation

extension Double {

    var toCelcius: Double {
        (self - 32.0) / 1.8
    }

    var toKPH: Double {
        self * 1.609344
    }
}
