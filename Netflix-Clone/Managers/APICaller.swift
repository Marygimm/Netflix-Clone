//
//  ApiCaller.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 24/08/2022.
//

import Foundation

struct Constants {
    static let apiKey = "c70bada7df0e8d58c9c7542240cc488b"
    static let baseURL = "https://api.themoviedb.org/"
    static let youtubeApiKey = "AIzaSyCgFxTCPNb6CyHHNrJcxTrj8tMpP0X8jVI"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
}

enum Sections: Int, CaseIterable {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    
    var url: URL? {
        switch self {
        case .TrendingMovies:
            return URL(string: "\(Constants.baseURL)3/trending/movie/day?api_key=\(Constants.apiKey)")
        case .TrendingTv:
            return URL(string: "\(Constants.baseURL)3/trending/tv/day?api_key=\(Constants.apiKey)")
        case .Popular:
            return URL(string: "\(Constants.baseURL)3/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1")
        case .Upcoming:
            return URL(string: "\(Constants.baseURL)3/movie/upcoming?api_key=\(Constants.apiKey)&language=en-US&page=1")
        case .TopRated:
            return URL(string: "\(Constants.baseURL)3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1")
        }
    }
}

enum APIError: Error {
    case failedToGetData
}

//TODO: - Change all this repeated code
class APICaller {
    static let shared = APICaller()
    
    func getMovieBySection(url: URL?, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/discover/movie?api_key=\(Constants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: "\(Constants.baseURL)3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youtubeApiKey)") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                if let first = results.items.first {
                    completion(.success(first))

                }
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
}

