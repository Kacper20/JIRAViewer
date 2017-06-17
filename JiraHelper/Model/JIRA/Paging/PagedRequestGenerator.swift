//
//  File.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//
import Foundation
import RxSwift

final class PagedRequestGenerator<T: Decodable> {
    typealias Index = Int
    typealias PageSize = Int

    typealias RequestGenerationFunction = (Index, PageSize) -> Observable<ArrayOfValuesWithPagingData<T>>

    private var currentIndex: Index
    private let pageSize: PageSize
    private let generationFunction: RequestGenerationFunction

    private var currentPagingData: PagingData?

    init(
        pageSize: PageSize,
        generationFunction: @escaping RequestGenerationFunction) {
        self.pageSize = pageSize
        self.currentIndex = 0
        self.generationFunction = generationFunction
    }

    func next() -> Observable<[T]>? {
        if let pagingData = currentPagingData, pagingData.isLastPage {
            return nil
        }
        let size = pageSize
        return generationFunction(currentIndex, pageSize )
                .map { [weak self] arrayWithPaging in
                    let pagingData = arrayWithPaging.pagingData
                    self?.currentPagingData = pagingData
                    self?.currentIndex = pagingData.startAt + size
                    return arrayWithPaging.values
        }
    }
}
