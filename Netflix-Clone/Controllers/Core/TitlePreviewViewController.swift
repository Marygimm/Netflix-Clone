//
//  TitlePreviewViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 31/08/2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
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
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()
        
    }
    
    private func configureConstraints() {
        let webViewConstraints = [webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50), webView.leadingAnchor.constraint(equalTo: view.leadingAnchor), webView.trailingAnchor.constraint(equalTo: view.trailingAnchor), webView.heightAnchor.constraint(equalToConstant: 250)]
                
        let titleLabelConstraints = [titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20), titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)]
        
        let overviewLabelConstraints = [overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15), overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let downloadButtonConstraints = [downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 50),
                                         downloadButton.widthAnchor.constraint(equalToConstant: 140),
                                         downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

    }
    
}
