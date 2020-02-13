//
//  ViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/1/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SVProgressHUD

class RecipesViewController: BaseViewController {
    
    @IBOutlet weak var rcTextField: UITextField!
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var viewModel: RecipesViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        self.title = R.string.localizable.recipesNavigationTitle()
       
    }

    // MARK: - Setup View -
    override func setupView() {
        rcTextField.placeholder = R.string.localizable.recipesSearchFieldPlacholder()
    }
    
    // MARK: - Setup ViewModel -
    
    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        rcTextField.reactive.continuousTextValues
//            .skip(while: {$0 == ""})
            .filter({ !String($0).isEmpty })
            .debounce( viewModel.debounceInterval, on: QueueScheduler.main)
            
            .observeValues { (text) in
            print("text: ", text)
//            viewModel.getRecipe(keyword: text)
        }
        
        reactive.makeBindingTarget { (weakself, object) in
            self.recipesCollectionView.reloadData()
            } <~ viewModel.recipeItems
        
        viewModel.isLoading.producer.startWithValues { (showLoading) in
            DispatchQueue.main.async {
                showLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }
        }
        
        viewModel.recipeItems.producer.skip(first: 1).startWithValues { (recipes) in
            if recipes.count == 0 {
                DispatchQueue.main.async {
                    SVProgressHUD.showInfo(withStatus: "No Results")
                }
            }
        }
        
        viewModel.errorMessage.producer.skip(first: 1).startWithValues { (errorMessage) in
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
    }
}

extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.recipeItems.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.recipesCollectionViewCell, for: indexPath)!
        if let recipe = viewModel?.recipeItems.value[indexPath.item] {
            if let title = recipe.title {
                cell.recipesTitleLabel.text = title
            }
            if let id = recipe.id, let url = viewModel?.buildImageUrl(id: id) {
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

extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didTapItem(at: indexPath)
    }
}

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 200)
    }
}
