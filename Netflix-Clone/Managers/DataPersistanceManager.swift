//
//  DataPersistanceManager.swift
//  Netflix-Clone
//
//  Created by Mary Moreira on 31/08/2022.
//

import Foundation
import CoreData
import UIKit

struct DataPersistanceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData


    }
    
    static let shared = DataPersistanceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping(Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.id = Int64(model.id ?? 0)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.vote_count = Int64(model.vote_count ?? 0)
        item.vote_average = model.vote_average ?? 0.0
        item.release_date = model.release_date
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
        
    }
    
    func fetchTitlesFromDataBase(completion: @escaping(Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
        
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) //ask the data base manager to delete an object
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
        
        
    }
}
