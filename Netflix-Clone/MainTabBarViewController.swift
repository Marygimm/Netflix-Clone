//
//  MainTabBarViewController.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 23/08/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let viewController = UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(client: APICaller.shared)))
        let viewController2 = UINavigationController(rootViewController: UpcomingViewController())
        let viewController3 = UINavigationController(rootViewController: SearchViewController())
        let viewController4 = UINavigationController(rootViewController: DownloadsViewController())
        
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController2.tabBarItem.image = UIImage(systemName: "play.circle")
        viewController3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        viewController4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        viewController.title = "Home"
        viewController2.title = "Coming Soon"
        viewController3.title = "Top Search"
        viewController4.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([viewController, viewController2, viewController3, viewController4], animated: true)
        
    }
}

