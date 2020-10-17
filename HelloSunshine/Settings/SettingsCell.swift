//
//  SettingsCell.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/16/20.
//

import UIKit

class SettingsCell: UITableViewCell {

    static var reuseIdentifier: String { return "SettingsCell" }

    @IBOutlet var mainLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        mainLabel.text = ""
    }

    func configure(with data: String, isChecked: Bool) {
        mainLabel.text = data
        self.accessoryType = isChecked ? .checkmark : .none
    }
    
}
