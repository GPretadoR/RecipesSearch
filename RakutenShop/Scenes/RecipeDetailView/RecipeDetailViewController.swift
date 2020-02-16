//
//  RecipeDetailViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/11/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import AlamofireImage
import SVProgressHUD

class RecipeDetailViewController: BaseViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var similarRecipesCollectionView: UICollectionView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    
    var viewModel: RecipeDetailViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsTableView.dataSource = self
        instructionsTableView.delegate = self
        instructionsTableView.tableFooterView = UIView()
        
        similarRecipesCollectionView.dataSource = self
        similarRecipesCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        let rightBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
    }
    
    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.isLoading.producer.startWithValues { (showLoading) in
            DispatchQueue.main.async {
                showLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }
        }        
        
        viewModel.errorMessage.producer.skip(first: 1).startWithValues { (errorMessage) in
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
        
        viewModel.recipeObject.producer.startWithValues({ [unowned self] (repiceObject) in
            DispatchQueue.main.async {
                self.updateUI(recipeObject: repiceObject)
            }
        })
        
        viewModel.nutritionsObject.producer.startWithValues({ [unowned self] (nutritionsObject) in
            DispatchQueue.main.async {
                guard let nutritionObject = nutritionsObject else { return }
                self.updateNutritions(nutritionsObject: nutritionObject)
            }
        })
        
//        viewModel.analyzedInstructions.producer.startWithValues({ (instructions) in
//            print(instructions)
//        })
    
        reactive.makeBindingTarget { (localSelf, _)  in
            localSelf.instructionsTableView.reloadData()
            } <~ viewModel.analyzedInstructions
        
        reactive.makeBindingTarget { (localSelf, _) in
            localSelf.similarRecipesCollectionView.reloadData()
            } <~ viewModel.similarRecipes
    }
    
    // MARK: - Actions -
    
    @objc func saveButtonTapped() {
        
    }
    
    // MARK: - Helper functions -
    
    private func updateNutritions(nutritionsObject: NutritionsResponseObject) {
        guard let calories = nutritionsObject.calories,
            let carbs = nutritionsObject.carbs,
            let proteins = nutritionsObject.protein,
            let fats = nutritionsObject.fat else { return }
        caloriesLabel.text = R.string.localizable.recipeDetailCaloriesLabelText(calories)
        carbsLabel.text = R.string.localizable.recipeDetailCarbsLabelText(carbs)
        fatsLabel.text = R.string.localizable.recipeDetailFatsLabelText(fats)
        proteinsLabel.text = R.string.localizable.recipeDetailProteinsLabelText(proteins)
    }
    
    private func updateUI(recipeObject: RecipeObject) {
        title = recipeObject.title
        let imageName = recipeObject.image != nil ? recipeObject.image : recipeObject.imageUrls?.first
        if let imgUrl = imageName, let url = viewModel?.buildImageUrl(imageName: imgUrl) {
            self.recipeImageView.af_setImage(withURL: url)
        }
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.analyzedInstructions.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: R.reuseIdentifier.instructionsTableViewCell.identifier)
        cell.accessoryType = .disclosureIndicator
        if let instructions = viewModel?.analyzedInstructions.value[indexPath.row] {
            if let instructionsName = instructions.name {
                cell.textLabel?.text = instructionsName.isEmpty ? R.string.localizable.recipeDetailInstructionsNameDishDefaultText("\(indexPath.row)") : instructionsName
            }
            cell.detailTextLabel?.text = R.string.localizable.recipeDetailInstructionsStepCountText("\(instructions.steps?.count ?? 0)")
        }
        return cell
    }
}

extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(index: indexPath)
    }
}

extension RecipeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.similarRecipes.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.recipesCollectionViewCell, for: indexPath)!
        if let recipe = viewModel?.similarRecipes.value[indexPath.item] {
            if let title = recipe.title {
                cell.recipesTitleLabel.text = title
            }
            if let imageName = recipe.image, let url = viewModel?.buildImageUrl(imageName: imageName) {
                cell.recipesImageView?.af_setImage(withURL: url,
                                                   placeholderImage: R.image.recipePlaceholderImage(),
                                                   filter: nil,
                                                   progress: nil,
                                                   progressQueue: DispatchQueue.global(),
                                                   imageTransition: UIImageView.ImageTransition.noTransition,
                                                   runImageTransitionIfCached: true, completion: nil)
            }
        }
        
        return cell
    }
}

extension RecipeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 176)
    }
}
