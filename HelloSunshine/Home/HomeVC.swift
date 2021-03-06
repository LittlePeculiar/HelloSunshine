//
//  HomeVC.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    
    @IBOutlet private var dayContainerView: UIView!
    @IBOutlet private var weekContainerView: UIView!
    
    // MARK:  Private
    
    fileprivate var viewModel: HomeVMContract
    fileprivate var dayVC: DayVC!
    fileprivate var weekVC: WeekVC!
    fileprivate var setupComplete: Bool = false
    
    // MARK: Init
    init(viewModel: HomeVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        viewModel.didChangeLocationClosure { [weak self] in
            DispatchQueue.main.async {
                if self?.setupComplete == false {
                    self?.setupUI()
                    self?.setupComplete = true
                } else {
                    self?.updateUI()
                }
            }
        }
        
        viewModel.didFailLocationClosure { [weak self](type) in
            DispatchQueue.main.async {
                self?.presentAlert(of: type)
            }
        }
    }
    
    private func setupUI() {
        self.title = viewModel.title
        
        dayVC = DayVC(viewModel: DayVM())
        dayVC.delegate = self
        self.embed(viewController: dayVC, inView: dayContainerView)
        dayVC.update(weatherData: viewModel.weatherData)
        
        weekVC = WeekVC(viewModel: WeekVM())
        weekVC.delegate = self
        self.embed(viewController: weekVC, inView: weekContainerView)
        weekVC.update(dailyData: viewModel.weatherData.dailyData)
    }

    private func updateUI() {
        dayVC.update(weatherData: viewModel.weatherData)
        weekVC.update(dailyData: viewModel.weatherData.dailyData)
    }
    
    private func presentAlert(of alertType: AlertType) {
        
        let title: String = alertType.title()
        let message: String = alertType.message()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        present(alertController, animated: true)
    }
}

extension HomeVC:DayVCDelegate {
    func controllerDidTapSettingsButton(controller: DayVC) {
        let settingsVC = SettingsVC(viewModel: SettingsVM())
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func controllerDidTapLocationButton(controller: DayVC) {
        
        let location = Location(name: dayVC.city,
                                latitude: viewModel.weatherData.latitude,
                                longitude: viewModel.weatherData.longitude)
        
        let locationVC = LocationVC(viewModel: LocationVM(withCurrent: location))
        navigationController?.pushViewController(locationVC, animated: true)
    }
}

extension HomeVC: WeekVCDelegate {
    func controllerDidRefresh(controller: WeekVC) {
        
    }
}

extension HomeVC: SettingsVCDelegate {
    func settingsDidChangeNotation(controller: SettingsVC) {
        updateUI()
    }
}
