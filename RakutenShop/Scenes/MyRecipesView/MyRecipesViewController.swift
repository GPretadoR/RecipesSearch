//
//  MyRecipesViewController.swift
//  RakutenShop
//
//  Created by Garnik Ghazaryan on 2/21/20.
//  Copyright © 2020 Garnik Ghazaryan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import AlamofireImage

class MyRecipesViewController: BaseViewController {

    @IBOutlet weak var myRecipesCollectionView: UICollectionView!
    
    var viewModel: MyRecipesViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRecipesCollectionView.dataSource = self
        myRecipesCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        reactive.makeBindingTarget { (localSelf, _) in
            localSelf.myRecipesCollectionView.reloadData()
            } <~ viewModel.recipeItems
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyRecipesViewController: UICollectionViewDataSource {
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

extension MyRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 200)
    }
}
