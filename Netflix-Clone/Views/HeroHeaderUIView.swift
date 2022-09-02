//
//  HeroHeaderUIView.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit

protocol HeroHeaderUIViewDelegate: AnyObject {
    func playButtonTapped(_ item: Title)
    func donwloadButtonTapped(_ item: Title)
}

class HeroHeaderUIView: UIView {
    
    private var item: Title?
    
    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    weak var delegate: HeroHeaderUIViewDelegate?
    
    private lazy var playButton: UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints() {
        addSubview(playButton)
        let playButtonConstraints = [playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50), playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), playButton.widthAnchor.constraint(equalToConstant: 120)]
        let downloadButtonConstraints = [downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50), downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), downloadButton.widthAnchor.constraint(equalToConstant: 120)]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

    }
    
    @objc func downloadButtonTapped() {
        guard let item = item else {
            return
        }
        delegate?.donwloadButtonTapped(item)
    }
    
    @objc func playButtonTapped() {
        guard let item = item else {
            return
        }
        delegate?.playButtonTapped(item)
    }
    
    func configure(with item: Title) {
        self.item = item
        guard let posterURL = item.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") else { return }
        heroImageView.sd_setImage(with: url)
    }
    
}
