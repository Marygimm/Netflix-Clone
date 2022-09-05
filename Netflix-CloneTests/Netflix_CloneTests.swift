//
//  Netflix_CloneTests.swift
//  Netflix-CloneTests
//
//  Created by Mary Moreira on 02/09/2022.
//

import XCTest
@testable import Netflix_Clone

class should_test_api_caller: XCTestCase {

    let client = MockApiCaller()
    let homeViewModel = HomeViewModel(client: MockApiCaller(false))
    
    override func setUp() {
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_if_the_homeviewmodel_when_data_is_fetch_arrays_are_not_empty() {
        homeViewModel.fetchData()
        Sections.allCases.forEach { section in
            XCTAssertTrue(homeViewModel.getTitlesBySection(section: section).count != 0)
        }
    }
    

    func test_get_movie_by_section_sucessfull() {
        client.reset()
        client.getMovieBySection(url: Sections.Upcoming.url) { result in
            switch result {
            case .success(let titles):
                XCTAssertEqual(3, titles.count)
            default:
                XCTFail()
            }
        }
    }
    
    
    func test_get_movie_by_section_failing() {
        client.shouldReturnError = true
        client.getMovieBySection(url: Sections.Upcoming.url) { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            default:
                XCTFail()
            }
        }
    }
    
    func test_get_discover_movies_sucessfull() {
        client.reset()
        client.getDiscoverMovies(completion: { result in
            switch result {
            case .success(let titles):
                XCTAssertEqual(3, titles.count)
            default:
               XCTFail()
            }
        })
    }
    
    
    func test_get_discover_movies_failing() {
        client.shouldReturnError = true
        client.getDiscoverMovies(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            default:
                XCTFail()
            }
        })
    }
    
    func test_search_movies_sucessfull() {
        client.reset()
        client.search(with: "", completion: { result in
            switch result {
            case .success(let titles):
                XCTAssertEqual(3, titles.count)
            default:
                XCTFail()
            }
        })
    }
    
    func test_search_movies_failing() {
        client.shouldReturnError = true
        client.search(with: "", completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            default:
                XCTFail()
            }
        })
    }
    
    
}
