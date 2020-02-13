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
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        let rightBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
    }
    
    override func setupViewModel() {
        viewModel?.recipeObject?.producer.startWithValues({ [unowned self] (repiceObject) in
            DispatchQueue.main.async {
                self.updateUI(recipeObject: repiceObject)
            }
        })
        
        viewModel?.nutritionsObject?.producer.startWithValues({ [unowned self] (nutritionsObject) in
            DispatchQueue.main.async {
                self.updateNutritions(nutritionsObject: nutritionsObject)
            }
        })
        
        viewModel?.analyzedInstructions?.producer.startWithValues({ (instructions) in
            print(instructions)
        })
    }
    
    // MARK: - Actions -
    
    @objc func saveButtonTapped() {
        
    }
    
    // MARK: - Helper functions -
    
    func updateNutritions(nutritionsObject: NutritionsResponseObject) {
        guard let calories = nutritionsObject.calories,
            let carbs = nutritionsObject.carbs,
            let proteins = nutritionsObject.protein,
            let fats = nutritionsObject.fat else { return }
        caloriesLabel.text = R.string.localizable.recipeDetailCaloriesLabelText(calories)
        carbsLabel.text = R.string.localizable.recipeDetailCarbsLabelText(carbs)
        fatsLabel.text = R.string.localizable.recipeDetailFatsLabelText(fats)
        proteinsLabel.text = R.string.localizable.recipeDetailProteinsLabelText(proteins)
    }
    
    func updateUI(recipeObject: RecipeObject) {
        self.title = recipeObject.title
        let imageName = recipeObject.image != nil ? recipeObject.image : recipeObject.imageUrls?.first
        if let imgUrl = imageName, let url = viewModel?.buildImageUrl(imageName: imgUrl) {
            self.recipeImageView.af_setImage(withURL: url)
        }
    }
}
