//
//  SettingsVC.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/16/20.
//

import UIKit

protocol SettingsVCDelegate: AnyObject {
    func settingsDidChangeNotation(controller: SettingsVC)
}

class SettingsVC: UIViewController {

    @IBOutlet var tableView: UITableView!

    weak var delegate: SettingsVCDelegate?
    fileprivate var viewModel: SettingsVMContract

    // MARK: Init
    init(viewModel: SettingsVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: SettingsCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SettingsCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorInset = UIEdgeInsets.zero
    }

}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table View Data Source Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(forSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell else {
            fatalError("Unable to Dequeue Settings Table View Cell")
        }

        let label = viewModel.label(forIndexPath: indexPath)
        cell.configure(with: label.0, isChecked: label.1)

        return cell
    }

    // MARK: - Table View Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let section = viewModel.section(for: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .time:
            guard indexPath.row != UserDefaults.timeNotation.rawValue else { return }
            if let newTimeNotation = TimeNotation(rawValue: indexPath.row) {
                UserDefaults.timeNotation = newTimeNotation
            }
        case .units:
            guard indexPath.row != UserDefaults.unitsNotation.rawValue else { return }
            if let newUnitsNotation = UnitsNotation(rawValue: indexPath.row) {
                UserDefaults.unitsNotation = newUnitsNotation
            }
        case .temperature:
            guard indexPath.row != UserDefaults.temperatureNotation.rawValue else { return }

            if let newTemperatureNotation = TemperatureNotation(rawValue: indexPath.row) {
                UserDefaults.temperatureNotation = newTemperatureNotation
            }
        }

        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        delegate?.settingsDidChangeNotation(controller: self)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        headerView.backgroundColor =  UIColor(red: 1, green: 0.45, blue: 0.20, alpha: 1.0)
        let label = UILabel(frame:  CGRect(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10))
        label.text = viewModel.title(for: section)
        headerView.addSubview(label)
        return headerView
    }
}

