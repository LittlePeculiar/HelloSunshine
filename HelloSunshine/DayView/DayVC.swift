//
//  DayVC.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit

protocol DayVCDelegate: AnyObject {
    func controllerDidTapSettingsButton(controller: DayVC)
    func controllerDidTapLocationButton(controller: DayVC)
}

class DayVC: UIViewController {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    
    weak var delegate: DayVCDelegate?
    fileprivate var viewModel: DayVMContract
    
    var city: String = "" {
        didSet {
            locationLabel.text = city
        }
    }
    
    // MARK: Init
    init(viewModel: DayVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // set the closure in VM
        viewModel.didChangeDayDataClosure { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
        viewModel.foundCityFromLocationClosure { [weak self] (location) in
            DispatchQueue.main.async {
                self?.city = location
            }
        }
    }
    
    public func update(weatherData: WeatherData) {
        self.viewModel.weatherData = weatherData
    }
    
    private func setupUI() {
        
        dateLabel.text = viewModel.dateLabelText
        timeLabel.text = viewModel.timeLabelText
        descriptionLabel.text = viewModel.summaryLabelText
        temperatureLabel.text = viewModel.temperatureLabelText
        windSpeedLabel.text = viewModel.windSpeedLabelText
        iconImageView.image = Utils.shared.imageForIcon(withName: viewModel.weatherData.icon)
    }


    // MARK: - Actions

    @IBAction func didTapSettingsButton(sender: UIButton) {
        delegate?.controllerDidTapSettingsButton(controller: self)
    }

    @IBAction func didTapLocationButton(sender: UIButton) {
        delegate?.controllerDidTapLocationButton(controller: self)
    }

}
