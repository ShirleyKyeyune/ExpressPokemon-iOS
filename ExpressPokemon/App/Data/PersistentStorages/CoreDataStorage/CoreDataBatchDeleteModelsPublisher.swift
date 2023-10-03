//
//  CoreDataBatchDeleteModelsPublisher.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Combine
import CoreData

struct CoreDataBatchDeleteModelsPublisher<Entity: NSManagedObject>: Publisher {
    typealias Output = NSBatchDeleteResult
    typealias Failure = NSError

    private let predicate: NSPredicate?
    private let context: NSManagedObjectContext

    init(delete predicate: NSPredicate?, context: NSManagedObjectContext) {
        self.predicate = predicate
        self.context = context
    }

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription<Entity, S>(subscriber: subscriber, context: context, predicate: predicate)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataBatchDeleteModelsPublisher {
    class Subscription<Entity: NSManagedObject, S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
        private var subscriber: S?
        private let predicate: NSPredicate?
        private var context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, predicate: NSPredicate?) {
            self.subscriber = subscriber
            self.context = context
            self.predicate = predicate
        }

        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            guard let subscriber = subscriber, demand > 0 else { return }

            do {
                demand -= 1
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Entity.self))
                request.predicate = predicate

                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                batchDeleteRequest.resultType = .resultTypeCount

                if let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                    demand += subscriber.receive(result)
                } else {
                    let error = CustomError(description: "Failure", code: 0) as NSError
                    subscriber.receive(completion: .failure(error))
                }
            } catch {
                subscriber.receive(completion: .failure(error as NSError))
            }
        }
    }
}

extension CoreDataBatchDeleteModelsPublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
    }
}
