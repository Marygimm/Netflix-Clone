//
//  MockApiCaller.swift
//  Netflix-CloneTests
//
//  Created by Mary Moreira on 05/09/2022.
//

import Foundation
@testable import Netflix_Clone


class MockApiCaller {
    
    var shouldReturnError = false
    
    enum MockServiceError: Error {
        case failedToGetData
        
    }
    
    func reset() {
        shouldReturnError = false
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    convenience init() {
        self.init(false)
    }
    
}

extension MockApiCaller: NetworkService {
    func getMovieBySection(url: URL?, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let urlSelected = Bundle(for: MockApiCaller.self).url(forResource: "title-success", withExtension: "json"), let data = try? Data(contentsOf: urlSelected), !shouldReturnError else {
            completion(.failure(MockServiceError.failedToGetData))
            return
        }
        
        if let titles = try? JSONDecoder().decode(TrendingTitleResponse.self, from: data) {
            completion(.success(titles.results))
        } else {
            completion(.failure(MockServiceError.failedToGetData))
        }
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = Bundle(for: MockApiCaller.self).url(forResource: "title-success", withExtension: "json"), let data = try? Data(contentsOf: url), !shouldReturnError else {
            completion(.failure(MockServiceError.failedToGetData))
            return
        }
        
        if let titles = try? JSONDecoder().decode(TrendingTitleResponse.self, from: data) {
            completion(.success(titles.results))
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = Bundle(for: MockApiCaller.self).url(forResource: "title-success", withExtension: "json"), let data = try? Data(contentsOf: url), !shouldReturnError else {
            completion(.failure(MockServiceError.failedToGetData))
            return
        }
        
        if let titles = try? JSONDecoder().decode(TrendingTitleResponse.self, from: data) {
            completion(.success(titles.results))
        }
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockServiceError.failedToGetData))
        }
    }
}
