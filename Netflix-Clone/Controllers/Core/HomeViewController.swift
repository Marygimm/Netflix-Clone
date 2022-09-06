//
//  HomeViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit


class HomeViewController: UIViewController {
        
    var viewModel: HomeViewModel
        
    var headerView: HeroHeaderUIView?
    var selectedTilte: Title?
            
    lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func configureHeroHeaderView() {
        guard let title = viewModel.getTitlesBySection(section: Sections.TrendingMovies).randomElement() else { return }
        self.selectedTilte = title
        self.headerView?.configure(with: title)
        self.headerView?.delegate = self
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
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        cell.configure(with: viewModel.getTitlesBySection(section: Sections.init(rawValue: indexPath.section) ?? Sections.TrendingMovies))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections(rawValue: section)?.title
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
    func collectionViewTableViewCellDidTapCell(item: Title) {
        homeFeedTable.isUserInteractionEnabled = false
        self.showPreviewViewController(item: item)
    }
    
    func showPreviewViewController(item: Title) {
        guard let itemName = item.original_title ?? item.original_name else { return }
        DispatchQueue.main.async { [weak self] in
            let viewController = TitlePreviewViewController()
            viewController.fetchMovie(with: itemName, overview: item.overview ?? "", titleToSearch: itemName + " trailer")
            self?.navigationController?.pushViewController(viewController, animated: true)
            self?.homeFeedTable.isUserInteractionEnabled = true
        }
    }
    
}


extension HomeViewController: HeroHeaderUIViewDelegate {
    func playButtonTapped(_ item: Title) {
        showPreviewViewController(item: item)
    }
    
    func donwloadButtonTapped(_ item: Title) {
        DataPersistanceManager.shared.downloadTitleWith(model: item) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(Notification(name: NSNotification.Name("downloaded")))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
