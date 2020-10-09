//
//  LocationVC.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/8/20.
//

import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate: AnyObject {
    func controller(_ controller: LocationVC, didSelectLocation location: Location)
}

class LocationVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet private var spinner: Spinner!

    // MARK: - properties

    weak var delegate: LocationsViewControllerDelegate?
    fileprivate var viewModel: LocationVM
    
    // MARK: Init
    init(viewModel: LocationVM) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.didChangeLocationClosure {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }
    
    private func setupUI() {
        let refresh = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addLocation))
                navigationItem.rightBarButtonItems = [refresh]
        
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: LocationCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LocationCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    @objc private func addLocation() {
        
    }

}

extension LocationVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as? LocationCell else { return UITableViewCell() }
        guard let section = LocationTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        var location: Location?
        
        switch section {
        case .current:
            location = viewModel.currentLocation
        case .favorite:
            if viewModel.hasFavorites {
                location = viewModel.favoriteLocations[indexPath.row]
            }
        case .recent:
            if viewModel.hasRecents {
                location = viewModel.recentLocations[indexPath.row]
            }
        }
        if let newLocation = location {
            cell.configure(withLocation: newLocation)
        } else {
            cell.nameLabel.text = viewModel.noRecordsFount(forSection: section)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(forSection: section)
    }
    
    // MARK: Edit
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        viewModel.canEdit(section: indexPath.section)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = LocationTableSection(rawValue: indexPath.section) else { return }
        
        let location = section == .favorite ? viewModel.favoriteLocations[indexPath.row] : viewModel.recentLocations[indexPath.row]
        viewModel.remove(location: location, forSection: section)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}

extension LocationVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = LocationTableSection(rawValue: indexPath.section) else { return }

        var location: Location?
        
        switch section {
        case .current:
            location = viewModel.currentLocation
        case .favorite:
            if viewModel.hasFavorites {
                location = viewModel.favoriteLocations[indexPath.row]
            }
        case .recent:
            if viewModel.hasRecents {
                location = viewModel.recentLocations[indexPath.row]
            }
        }
        
        if let newLocation = location {
            // Notify Delegate to reload home
            delegate?.controller(self, didSelectLocation: newLocation)

            // Dismiss View Controller
            dismiss(animated: true)
        }
    }

}
