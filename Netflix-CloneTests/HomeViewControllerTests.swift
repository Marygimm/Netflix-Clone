//
//  HomeViewControllerTests.swift
//  Netflix-CloneTests
//
//  Created by Mary Moreira on 06/09/2022.
//

import XCTest
@testable import Netflix_Clone

class HomeViewControllerTests: XCTestCase {
    
    var client = MockApiCaller()
    var homeViewModel = HomeViewModel(client: MockApiCaller(false))
    var tableView = UITableView()
    var homeViewController: HomeViewController!
    var item: Title!
    var titleItem: TitleItem!
    
    
    override func setUp() {
        homeViewModel.fetchData()
        homeViewController = HomeViewController(viewModel: homeViewModel)
        item = homeViewModel.getTitlesBySection(section: Sections.TrendingMovies).first!
    }
    
    override func tearDown() {
        deleteAllCoreDataInfo()
        homeViewController = nil
        item = nil
        super.tearDown()
    }
    
    func deleteAllCoreDataInfo() {
        guard let titleItem = titleItem else { return }
        DataPersistanceManager.shared.deleteTitleWith(model: titleItem, completion: { [weak self] result in
                switch result {
                case .success():
                   XCTAssertTrue(true)
                case .failure(_):
                    XCTFail()
                }
            })
        }
    
    func test_if_arrays_in_the_model_when_data_is_fetch_are_not_empty() {
        Sections.allCases.forEach { section in
            XCTAssertTrue(homeViewModel.getTitlesBySection(section: section).count != 0)
        }
    }
    
    func test_table_view() {
        let sut = HomeViewController(viewModel: homeViewModel)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
        tableView.delegate = sut
        tableView.dataSource = sut
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell as? CollectionViewTableViewCell)
        let item = homeViewModel.getTitlesBySection(section: Sections.TrendingMovies).first!
        sut.collectionViewTableViewCellDidTapCell(item: item)
        XCTAssertTrue(!sut.homeFeedTable.isUserInteractionEnabled)
    
    }
    
    
    func test_if_the_headerview_received_element_to_display() {
        let sut = HomeViewController(viewModel: homeViewModel)
        let item = sut.selectedTilte
        //before call to configureHeaderView
        XCTAssertNil(item)
        sut.configureHeroHeaderView()
        //after call configureHeaderView
        let newItem = sut.selectedTilte
        XCTAssertNotNil(newItem)
        
    }
    
    func test_hero_view_button_play() {
        homeViewController.configureHeroHeaderView()
        homeViewController?.headerView?.item = item
        let delegate = MockDelegate()
        XCTAssertFalse(delegate.isButtonTapped)
        homeViewController?.headerView?.delegate = delegate
        homeViewController?.headerView?.playButtonTapped()
        XCTAssertTrue(delegate.isButtonTapped)
    }
    
    func test_hero_view_button_play2() {
        homeViewController.configureHeroHeaderView()
        homeViewController?.headerView?.item = item
        let delegate = MockDelegate()
        XCTAssertFalse(delegate.isButtonTapped)
        homeViewController?.headerView?.delegate = delegate
        homeViewController?.headerView?.playButtonTapped()
        XCTAssertTrue(delegate.isButtonTapped)
    }
    
    func test_hero_view_button_download() {
        homeViewController.configureHeroHeaderView()
        homeViewController?.headerView?.item = item
        homeViewController?.headerView?.delegate = homeViewController
        homeViewController?.headerView?.downloadButtonTapped()
        DataPersistanceManager.shared.fetchTitlesFromDataBase {[weak self] result in
            switch result {
            case .success(let titles):
                guard let itemId = self?.item.id else {return}
                let isThereThisItem = titles.filter { $0.id == itemId}
                self?.titleItem = isThereThisItem.first
                XCTAssertTrue(!isThereThisItem.isEmpty)
            case .failure(_):
                XCTFail()
            }
        }
    }
        
    
    func test_if_we_can_push_preview_controller() {
        let mockNavigationController = SpyNavigationController(rootViewController: homeViewController)
        let item = homeViewModel.getTitlesBySection(section: Sections.TrendingMovies).first!
        homeViewController?.showPreviewViewController(item: item)
        if let topController = mockNavigationController.pushedViewController as? TitlePreviewViewController {
            XCTAssertNotNil(topController)
        }
    }

}
