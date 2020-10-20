//
//  XCTestCase.swift
//  HelloSunshineTests
//
//  Created by Gina Mullins on 10/20/20.
//

import Foundation
import XCTest

extension XCTestCase {

    func loadStub(name: String, ext: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: ext)

        // only time its ok to force unwrap optional since we're looking for failure anyway
        // do not do this elsewhere!!!
        return try! Data(contentsOf: url!)
    }
}
