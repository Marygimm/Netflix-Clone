//
//  CollectionViewTableViewCell.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

 static let identifier = "CollectionViewTableViewCell"
    private var titles: [Title] = [Title]()
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(index: IndexPath) {
        DataPersistanceManager.shared.downloadTitleWith(model: titles[index.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(Notification(name: NSNotification.Name("downloaded")))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return  UICollectionViewCell() }
        guard let path = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = titles[indexPath.row]
        guard let itemName = item.original_title ?? item.original_name else { return }
        
        APICaller.shared.getMovie(with: itemName + " trailer") { [weak self] result in
            switch result {
            case .success(let element):
            
                guard let title = self?.titles[indexPath.row], let strongSelf = self else { return }
                let viewModel = TitlePreviewViewModel(title: title.original_title ?? title.original_name ?? "",
                                                      youtubeVideo: element,
                                                      titleOverview: title.overview ?? "")
                strongSelf.delegate?.collectionViewTableViewCellDidTapCell(strongSelf,
                                                                 model: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", state: .off) { [weak self]_ in
                self?.downloadTitleAt(index: indexPath)
            }
            return UIMenu(title: "", options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
    
    
    
    
    
}
