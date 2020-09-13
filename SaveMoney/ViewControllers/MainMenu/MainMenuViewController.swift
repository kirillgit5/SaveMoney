//
//  ViewController.swift
//  SaveMoney
//
//  Created by Кирилл Крамар on 24.06.2020.
//  Copyright © 2020 Кирилл Крамар. All rights reserved.
//

import UIKit
import RealmSwift
class MainMenuViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var moneyCategoryCollectionView: UICollectionView!
    @IBOutlet var navigationBar: MainNavigationBar!
    @IBOutlet var purchasesCategoryCollectionView: UICollectionView!
    
    // MARK: - Private Property
    private var moneyCategories: Results<MoneyCategory>!
    private var purchasesCategories: Results<PurchasesCategory>!
    
    private let viewModel = MainMenuViewModel()
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegat = self
        moneyCategoryCollectionView.register(MoneyCategoryCollectionViewCell.nib(),
                                             forCellWithReuseIdentifier: MoneyCategoryCollectionViewCell.identifier)
        moneyCategoryCollectionView.delegate = self
        moneyCategoryCollectionView.dataSource = self
        purchasesCategoryCollectionView.delegate = self
        purchasesCategoryCollectionView.dataSource = self
        purchasesCategoryCollectionView.register(MoneyCategoryCollectionViewCell.nib(),
                                                 forCellWithReuseIdentifier: MoneyCategoryCollectionViewCell.identifier)
        moneyCategories = StorageManager.shared.realm.objects(MoneyCategory.self)
        purchasesCategories = StorageManager.shared.realm.objects(PurchasesCategory.self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moneyCategoryCollectionView.reloadData()
        purchasesCategoryCollectionView.reloadData()
        navigationBar.setBalance(moneyCatigories: moneyCategories)
        navigationBar.setExpense(purchasesCatigories: purchasesCategories)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIndentifire.addIncome.rawValue {
            guard let viewModel = sender as? AddIncomeViewModelProtocol else { return }
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let vc = navController.topViewController as? AddIncomeViewController else { return }
            vc.viewModel = viewModel
        } else if segue.identifier == SegueIndentifire.addPurchases.rawValue {
            guard let viewModel = sender as? AddPurshaeseViewModelProtocol else { return }
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let vc = navController.topViewController as? AddPurshasesViewController else { return }
            vc.viewModel = viewModel
            
        } else  if segue.identifier == SegueIndentifire.detailAllCategories.rawValue {
            guard let categoryType = sender as? CategoriesType else { return }
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let addVC = navController.topViewController as? DetailAllCategoriesTableViewController else { return }
            addVC.categoriesType = categoryType
            
        } else if segue.identifier == SegueIndentifire.showDetailCategory.rawValue {
            guard let collectionView = sender as? UICollectionView else { return }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            let navController = segue.destination as! UINavigationController
            let detailCategoryVC = navController.topViewController as! DetailCategoryTableViewController
            if collectionView === moneyCategoryCollectionView {
                detailCategoryVC.category = moneyCategories[indexPath.item]
            } else {
                detailCategoryVC.category = purchasesCategories[indexPath.item]
            }
        } else if segue.identifier == SegueIndentifire.addCategory.rawValue {
            guard let collectionView = sender as? UICollectionView else { return }
            let createCategoryVC = segue.destination as! CreateCategoryViewController
            if collectionView === moneyCategoryCollectionView {
                createCategoryVC.categoriesType  = .moneyCategory
            } else {
                createCategoryVC.categoriesType = .purchasesCategory
            }
        }
    }
}

//MARK: - MainNavigationBarDelegate
extension MainMenuViewController: MainNavigationBarDelegate {
    func watchBalance() {
        performSegue(withIdentifier: SegueIndentifire.detailAllCategories.rawValue, sender: CategoriesType.moneyCategory)
    }
    func watchExpense() {
        performSegue(withIdentifier: SegueIndentifire.detailAllCategories.rawValue, sender: CategoriesType.purchasesCategory)
    }
    func watchPlan() {
        //        performSegue(withIdentifier: SegueIndentifire.showTaskList.rawValue, sender: nil)
    }
    func addMoney() {
        let incomeViewModel = viewModel.getAddIncomeViewModel()
        performSegue(withIdentifier: SegueIndentifire.addIncome.rawValue, sender: incomeViewModel)
    }
    func addExpense() {
        let purchasesViewModel = viewModel.getAddPurshasesViewModel()
        performSegue(withIdentifier: SegueIndentifire.addPurchases.rawValue , sender: purchasesViewModel)
    }
}

//MARK: - UICollectionViewDelegate
extension MainMenuViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionFlowDelegate
extension MainMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (moneyCategoryCollectionView.bounds.width - 30)/3, height: (moneyCategoryCollectionView.bounds.width - 30)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == moneyCategoryCollectionView {
            if indexPath.row < moneyCategories.count {
                performSegue(withIdentifier: SegueIndentifire.showDetailCategory.rawValue, sender: moneyCategoryCollectionView)
            } else {
                performSegue(withIdentifier: SegueIndentifire.addCategory.rawValue, sender: moneyCategoryCollectionView)
            }
        } else {
            if indexPath.row < purchasesCategories.count {
                performSegue(withIdentifier: SegueIndentifire.showDetailCategory.rawValue, sender: purchasesCategoryCollectionView)
            } else {
                performSegue(withIdentifier: SegueIndentifire.addCategory.rawValue, sender: purchasesCategoryCollectionView)
            }
        }
    }
}

//MARK: - extension UICollectionViewDataSource
extension MainMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView === moneyCategoryCollectionView ? moneyCategories.count + 1 : purchasesCategories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === moneyCategoryCollectionView {
            if indexPath.row < moneyCategories.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoneyCategoryCollectionViewCell.identifier,
                                                              for: indexPath) as! MoneyCategoryCollectionViewCell
                cell.setupCell(category: moneyCategories[indexPath.item])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.getAddMoneyCategoryCellIdentifire(), for: indexPath)
                return cell
            }
            
        } else {
            if indexPath.row < purchasesCategories.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoneyCategoryCollectionViewCell.identifier,
                                                              for: indexPath) as! MoneyCategoryCollectionViewCell
                cell.setupCell(category: purchasesCategories[indexPath.item])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.getAddPurchasesCategoryCellIdentifire(), for: indexPath)
                return cell
            }
        }
    }
}



