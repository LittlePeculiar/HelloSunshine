//
//  WeekVC.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit

protocol WeekVCDelegate: AnyObject {
    func controllerDidRefresh(controller: WeekVC)
}

class WeekVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet private var spinner: Spinner!
    
    weak var delegate: WeekVCDelegate?
    fileprivate var viewModel: WeekVMContract
    
    // MARK: Init
    init(viewModel: WeekVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.didChangeDataClosure { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }
    
    public func update(dailyData: [WeatherDayData]) {
        self.viewModel.dailyData = dailyData
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: WeekCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: WeekCell.reuseIdentifier)

        // make row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 105
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions

    @objc func didRefresh(sender: UIRefreshControl) {
        if viewModel.isLoading == false {
            delegate?.controllerDidRefresh(controller: self)
        }
    }

}

extension WeekVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: WeekCell.reuseIdentifier, for: indexPath) as? WeekCell, indexPath.row < viewModel.dailyData.count else { return UITableViewCell() }
                
        let data = viewModel.dailyData[indexPath.row]
        cell.configure(with: data)
        return cell
    }
}
