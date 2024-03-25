//
//  ListService.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

final class ListService: ListServiceInterface {

    func getList() -> ListPublisher {
        let apiClient = APIClient<ListEndpoint>()
        return apiClient
            .request(ListEndpoint.getList)
            .eraseToAnyPublisher()
    }

}
