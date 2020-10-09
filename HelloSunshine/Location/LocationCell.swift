//
//  LocationCell.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/8/20.
//

import UIKit

class LocationCell: UITableViewCell {
    
    static var reuseIdentifier: String { return "LocationCell" }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var coordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        nameLabel.text = ""
        coordLabel.text = ""
    }

    func configure(withLocation loc: Location) {
        nameLabel.text = loc.name
        coordLabel.text = "\(loc.latitude), \(loc.longitude)"
    }
}
