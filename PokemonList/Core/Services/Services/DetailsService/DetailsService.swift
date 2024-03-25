//
//  DetailsService.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

final class DetailsService: DetailsServiceInterface {

    func getDetails(with id: String) -> DetailsPublisher {
        let apiClient = APIClient<DetailsEndpoint>()
        return apiClient
            .request(DetailsEndpoint.getDetails(id: id))
            .eraseToAnyPublisher()
    }

}
