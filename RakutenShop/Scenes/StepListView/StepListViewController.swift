//
//  StepListViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/13/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class StepListViewController: BaseViewController {

    @IBOutlet weak var stepListTableView: UITableView!
    
    var viewModel: StepListViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepListTableView.dataSource = self
    }

    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        reactive.makeBindingTarget { [unowned self] (weakself, object) in
            self.stepListTableView.reloadData()
            } <~ viewModel.analyzedInstructions
    }
}

extension StepListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.analyzedInstructions.value.steps?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: R.reuseIdentifier.instructionsTableViewCell.identifier)
        cell.accessoryType = .disclosureIndicator
        if let step = viewModel?.analyzedInstructions.value.steps?[indexPath.row],
            let number = step.number,
            let stepText = step.step {
            cell.textLabel?.text = R.string.localizable.recipeDetailInstructionsStepCountText("\(number)")
            cell.detailTextLabel?.text = stepText
        }
        return cell
    }
}
