//
//  SearchViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//
import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private lazy var searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private lazy var discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(discoverTable)
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies {[weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
                 let title = titles[indexPath.row]
                 cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknow title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let element):
            
               guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    let viewController = TitlePreviewViewController()
                    let viewModel = TitlePreviewViewModel(title: title.original_title ?? title.original_name ?? "",
                                                          youtubeVideo: element,
                                                          titleOverview: title.overview ?? "")
                    viewController.configure(with: viewModel)
                    strongSelf.navigationController?.pushViewController(viewController, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultController.delegate = self
        APICaller.shared.search(with: query) { result in
            switch result {
            case .success(let titles):
                resultController.titles = titles
                DispatchQueue.main.async {
                    resultController.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        
        }
    }
    
    
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
