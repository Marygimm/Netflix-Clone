//
//  UpcomingViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit
//TODO: - add loading button
class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private lazy var upcomingTable: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingTitles { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
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
