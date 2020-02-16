//
//  DetailedInstructionsViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/14/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import AlamofireImage
import ReactiveCocoa
import ReactiveSwift

class DetailedInstructionsViewController: BaseViewController {

    @IBOutlet weak var stepDescriptionTableView: UITableView!
    @IBOutlet weak var instructionsTextLabel: UILabel!
    
    var viewModel: DetailedInstructionsViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepDescriptionTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        reactive.makeBindingTarget { (localSelf, _) in
            if let number = object.number {
                self.title = R.string.localizable.recipeDetailInstructionsStepCountText("\(number)")
            }
            self.instructionsTextLabel.text = object.step
            self.stepDescriptionTableView.reloadData()
            } <~ viewModel.steps
    }
}

extension DetailedInstructionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.steps.value.ingredients?.count ?? 0
        } else if section == 1 {
            return viewModel?.steps.value.equipment?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? R.string.localizable.detailedStepesTableViewHeaderIngredientsText() : R.string.localizable.detailedStepesTableViewHeaderEquipmentsText()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: R.reuseIdentifier.instructionsTableViewCell.identifier)
        
        if indexPath.section == 0 {
            if let ingredients = viewModel?.steps.value.ingredients?[indexPath.row] {
                if let imageUrl = viewModel?.buildImageUrl(instructionType: .ingredient, imageName: ingredients.image ?? "") {
                    cell.imageView?.af_setImage(withURL: imageUrl,
                                                placeholderImage: R.image.recipePlaceholderImage(),
                                                filter: nil,
                                                progress: nil,
                                                progressQueue: DispatchQueue.global(),
                                                imageTransition: .noTransition,
                                                runImageTransitionIfCached: true,
                                                completion: nil)
                }
                cell.textLabel?.text = ingredients.name ?? ""
            }
        } else if indexPath.section == 1 {
            if let equipment = viewModel?.steps.value.equipment?[indexPath.row] {
                if let imageUrl = viewModel?.buildImageUrl(instructionType: .equipment, imageName: equipment.image ?? "") {
                    cell.imageView?.af_setImage(withURL: imageUrl,
                                                placeholderImage: R.image.recipePlaceholderImage(),
                                                filter: nil,
                                                progress: nil,
                                                progressQueue: DispatchQueue.global(),
                                                imageTransition: .noTransition,
                                                runImageTransitionIfCached: true,
                                                completion: nil)
                }
                cell.textLabel?.text = equipment.name ?? ""
            }
        }        
        return cell
    }
}
