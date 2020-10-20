//
//  WeekCell.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/7/20.
//

import UIKit

class WeekCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    static var reuseIdentifier: String { return "WeekCell" }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        dayLabel.text = ""
        dateLabel.text = ""
        windSpeedLabel.text = ""
        temperatureLabel.text = ""
        iconImageView.image = nil
    }

    func configure(with data: WeekDayDataVM) {
        dayLabel.text = data.dayLabelText
        dateLabel.text = data.dateLabelText
        windSpeedLabel.text = data.windSpeedLabelText
        temperatureLabel.text = data.temperatureLabelText
        iconImageView.image = Utils.shared.imageForIcon(withName: data.weatherIconName)
    }
    
}
