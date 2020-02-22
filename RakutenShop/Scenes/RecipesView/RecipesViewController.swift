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
        title = R.string.localizable.recipesNavigationTitle()
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        rcTextField.resignFirstResponder()
    }
    // MARK: - Setup View -
    override func setupView() {
        rcTextField.placeholder = R.string.localizable.recipesSearchFieldPlacholder()
        let rightBarItem = UIBarButtonItem(title: R.string.common.commonStringMyRecipesButtonTitle(), style: .plain, target: self, action: #selector(myRecipesButtonTapped))
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
        
    }
    
    // MARK: - Setup ViewModel -
    
    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        rcTextField.reactive.continuousTextValues
            .filter({ !String($0).isEmpty })
            .debounce( viewModel.debounceInterval, on: QueueScheduler.main)
            .skipRepeats()
            .observeValues { (text) in
                viewModel.getRecipe(keyword: text)
        }
        
        reactive.makeBindingTarget { (localSelf, _) in
            localSelf.recipesCollectionView.reloadData()
            } <~ viewModel.recipeItems
        
        viewModel.isLoading.producer.startWithValues { (showLoading) in
            showLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }
        
        viewModel.errorMessage.signal.observeValues { (errorMessage) in
            SVProgressHUD.showError(withStatus: errorMessage)
        }
        
        viewModel.recipeItems.signal.observeValues { (recipes) in
            if recipes.count == 0 {
                DispatchQueue.main.async {
                    SVProgressHUD.showInfo(withStatus: "No Results")
                }
            }
        }
    }
    
    // MARK: - Actions -
       
    @objc func myRecipesButtonTapped() {
        viewModel?.didTapMyRecipesButton()
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
