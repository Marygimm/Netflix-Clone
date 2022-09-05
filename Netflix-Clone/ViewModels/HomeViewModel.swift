//
//  HomeViewModel.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 02/09/2022.
//

import Foundation

class HomeViewModel {
    
    private var client: NetworkService?
    private lazy var trendingMovies: [Title] = [Title]()
    private lazy var trendingTv: [Title] = [Title]()
    private lazy var popular: [Title] = [Title]()
    private lazy var upcoming: [Title] = [Title]()
    private lazy var topRated: [Title] = [Title]()
    
    init(client: NetworkService) {
        self.client = client
    }
    
    
    func fetchData() {
        guard let client = client else {
            return
        }
        Sections.allCases.forEach { element in
            client.getMovieBySection(url: element.url) { [weak self] result in
                switch result {
                case .success(let titles):
                    self?.populateTitles(element: element, titles: titles)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func populateTitles(element: Sections, titles: [Title]) {
        switch element {
        case .TrendingMovies:
            self.trendingMovies = titles
        case .TrendingTv:
            self.trendingTv = titles
        case .Popular:
            self.popular = titles
        case .Upcoming:
            self.upcoming = titles
        case .TopRated:
            self.topRated = titles
        }
    }
    
    func getTitlesBySection(section: Sections) -> [Title] {
        switch section {
        case .TrendingMovies:
           return trendingMovies
        case .TrendingTv:
            return trendingTv
        case .Popular:
            return popular
        case .Upcoming:
            return upcoming
        case .TopRated:
            return topRated
        }
    }
    
    
}
