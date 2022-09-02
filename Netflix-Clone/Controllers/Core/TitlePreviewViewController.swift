//
//  TitlePreviewViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 31/08/2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController, UIScrollViewDelegate {
    
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isScrollEnabled = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        return webView
    }()
    
    private let contentWebView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Donwload", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        contentView.addSubview(contentWebView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(downloadButton)
        contentWebView.addSubview(webView)
        
        configureConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureConstraints() {
        
        let scrollViewConstraints = [scrollView.topAnchor.constraint(equalTo: view.topAnchor), scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor), scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor), scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        
        let contentViewConstraints = [contentView.topAnchor.constraint(equalTo: scrollView.topAnchor), contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)]
        let contentWebViewConstraints = [contentWebView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20), contentWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor), contentWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor), contentWebView.heightAnchor.constraint(equalToConstant: 250)]
    
        
        let titleLabelConstraints = [titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20), titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)]
        
        let overviewLabelConstraints = [overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15), overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let downloadButtonConstraints = [downloadButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                                         downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
                                         downloadButton.widthAnchor.constraint(equalToConstant: 140),
                                         downloadButton.heightAnchor.constraint(equalToConstant: 40), downloadButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
      ]
        NSLayoutConstraint.activate(scrollViewConstraints)

        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(contentWebViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

        webView.setFillingConstraints(in: contentWebView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentWebView.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.centerXAnchor.constraint(equalTo: contentWebView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentWebView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
    }
    
    
    
    func fetchMovie(with title: String, overview: String, titleToSearch: String) {
        self.titleLabel.text = title
        self.overviewLabel.text = overview
        APICaller.shared.getMovie(with: titleToSearch) { [weak self] result in
            switch result {
            case .success(let element):
                let viewModel = TitlePreviewViewModel(youtubeVideo: element)
                self?.configure(with: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
        func configure(with model: TitlePreviewViewModel) {
            DispatchQueue.main.async { [weak self] in
                guard let id = model.youtubeVideo.id.videoId, let url = URL(string: "https://www.youtube.com/embed/\(id)") else { return }
                self?.webView.load(URLRequest(url: url))
                self?.webView.isHidden = false
                self?.downloadButton.isHidden = false
                self?.activityIndicator.stopAnimating()
                
            }
        }
        
    }
