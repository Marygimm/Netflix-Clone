//
//  HomeViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit


class HomeViewController: UIViewController {
    
    //TODO: - Convert this into the viewModel
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private var trendingMovies: [Title] = [Title]() {
        didSet {
            reloadData()
        }
    }
    private var trendingTv: [Title] = [Title]() {
        didSet {
            reloadData()
        }
    }
    private lazy var popular: [Title] = [Title]()
    private lazy var upcoming: [Title] = [Title]()
    private lazy var topRated: [Title] = [Title]()
    
    private var randomTrendingMovie: Title?
    
    private var headerView: HeroHeaderUIView?
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.homeFeedTable.reloadData()
        }
    }
    
    func fetchData() {
        Sections.allCases.forEach { element in
            APICaller.shared.getMovieBySection(url: element.url) { [weak self] result in
                switch result {
                case .success(let titles):
                    self?.populateTitles(element: element, titles: titles)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func populateTitles(element: Sections, titles: [Title]) {
        switch element {
        case .TrendingMovies:
            trendingMovies = titles
        case .TrendingTv:
            trendingTv = titles
        case .Popular:
            popular = titles
        case .Upcoming:
            upcoming = titles
        case .TopRated:
            topRated = titles
        }
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getMovieBySection(url: Sections.TrendingMovies.url) { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch Sections(rawValue: indexPath.section) {
        case .TrendingMovies:
            cell.configure(with: trendingMovies)
        case .TrendingTv:
            cell.configure(with: trendingTv)
        case .Popular:
            cell.configure(with: popular)
        case .Upcoming:
            cell.configure(with: upcoming)
        case .TopRated:
            cell.configure(with: topRated)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = TitlePreviewViewController()
            viewController.configure(with: model)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
