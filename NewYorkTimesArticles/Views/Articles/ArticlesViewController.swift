//
//  ArticlesViewController.swift
//  NewYorkTimesArticles
//
//  Created by Bheem Singh on 09/07/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import DropDown

class ArticlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public let articles : PublishSubject<[RArticle]> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    public var articlesViewModel = ArticlesViewModel()
    
    let dropDown = DropDown() // dropdown to change article section
    var refreshControl = UIRefreshControl() // pull to refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpChangeSection()
        bindPullToRefreash()
        setUpViewModel()
        setupBinding()
        articlesViewModel.articleSection = ArticleSection.science.rawValue
    }
    
    func setUpView(){
        
        self.title = ArticleSection.science.rawValue
        
        // Adding navigation right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: StringConstants.changeSection, style: .plain, target: self, action: #selector(changeSectionTapped))
        
        
    }
    
    func bindPullToRefreash(){
        
        refreshControl.attributedTitle = NSAttributedString(string: StringConstants.refreshing)
        refreshControl.rx.controlEvent(.valueChanged).subscribe({[unowned self] _ in
            // perform action you want to perform
            
            self.articlesViewModel.isRefreshing.onNext(true)
            self.articlesViewModel.fetchDataFromServer()
            
        }).addDisposableTo(disposeBag)
        tableView.addSubview(refreshControl)
    }
    
    func setUpChangeSection(){
        
        // The view to which the drop down will appear on
        dropDown.anchorView = navigationItem.rightBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = [ArticleSection.science.rawValue, ArticleSection.technology.rawValue, ArticleSection.business.rawValue, ArticleSection.world.rawValue, ArticleSection.movies.rawValue, ArticleSection.travel.rawValue]
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.title = item.capitalized
            self.dropDown.hide()
            self.articlesViewModel.articleSection = item
        }
    }
    
    private func setUpViewModel() {
        
        // observing errors to show
        
        articlesViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    self.alertWithMessage(title: StringConstants.fetchDataFailed, message: message, handler: {
                        let _ = self.navigationController?.popViewController(animated: true)
                    })
                case .serverMessage(let message):
                    self.alertWithMessage(title: StringConstants.fetchDataFailed, message: message, handler: {
                        let _ = self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding issues to view's issues
        
        articlesViewModel
            .articles
            .observeOn(MainScheduler.instance)
            .bind(to: self.articles)
            .disposed(by: disposeBag)
        
        articlesViewModel
            .isRefreshing
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (isRefreshing) in
            if isRefreshing{
                self.refreshControl.beginRefreshing()
            }else{
                self.refreshControl.endRefreshing()
            }
        })
        .disposed(by: disposeBag)
        
    }
    
    
    
    private func setupBinding(){
        
        tableView.register(UINib(nibName: ArticleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleTableViewCell.identifier)
        
        // binding issues to tableView
        articles.bind(to: tableView.rx.items(cellIdentifier:ArticleTableViewCell.identifier, cellType: ArticleTableViewCell.self)){
            (row, article, cell) in
            
            cell.article = article
            
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        
        // if tableViewCell is selected
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
                let cell = self?.tableView.cellForRow(at: indexPath) as? ArticleTableViewCell
                
                // Pushing to details
                let detailView = self?.storyboard?.instantiateViewController(withIdentifier: StoryboardId.details) as? DetailsViewController
                if let article = cell?.article{
                    detailView?.article = article
                }
                
                self?.navigationController?.pushViewController(detailView!, animated: true)
                
            }).addDisposableTo(disposeBag)
        
    }
    
    @objc func changeSectionTapped(){
        // open dropdown to change section
        self.dropDown.show()
    }
    
    
}
