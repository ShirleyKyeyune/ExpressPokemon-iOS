//
//  PokemonDetailsViewModelTests.swift
//  ExpressPokemonTests
//
//  Created by Shirley Kyeyune on 06/10/2023.
//

import Combine
import Quick
import Nimble
import Cuckoo
@testable import ExpressPokemon

class PokemonDetailsViewModelTests: QuickSpec {
    // swiftlint:disable function_body_length closure_body_length implicitly_unwrapped_optional
    override class func spec() {
        func loadSamplePokemonDetailResponse() -> PokemonDetailResponseDTO? {
            guard let url = Bundle(for: PokemonDetailsViewModelTests.self)
                .url(forResource: "SamplePokemonDetailResponse", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return nil
            }

            let decoder = JSONDecoder()
            return try? decoder.decode(PokemonDetailResponseDTO.self, from: data)
        }

        describe("PokemonDetailViewModel") {
            var subject: PokemonDetailViewModel!
            var mockPokemonRepository: MockPokemonRepositoryType!

            beforeEach {
                mockPokemonRepository = MockPokemonRepositoryType()
                subject = try? PokemonDetailViewModel(
                    pokemon: Pokemon(
                        id: "1",
                        name: "Pikachu",
                        url: "",
                        thumbnailUrl: "",
                        fullImageUrl: ""
                    ),
                    pokemonRepository: mockPokemonRepository
                )
            }

            context("when view did appear") {
                it("fetches Pokemon details") {
                    let sampleData = loadSamplePokemonDetailResponse()
                    stub(mockPokemonRepository) { stub in
                        when(stub.fetchDetails(for: any()))
                            .thenReturn(Just(sampleData).setFailureType(to: APIError.self).eraseToAnyPublisher())
                    }

                    _ = subject.transform(input: Just(.viewDidAppear).eraseToAnyPublisher())

                    let domainModel = sampleData?.toDomain()
                    expect(subject.pokemonDetail).toEventually(equal(domainModel))
                }
            }

            context("when refresh detail is fired") {
                it("fetches Pokemon details again") {
                    let sampleData = loadSamplePokemonDetailResponse()
                    stub(mockPokemonRepository) { stub in
                        when(stub.fetchDetails(for: any()))
                            .thenReturn(Just(sampleData).setFailureType(to: APIError.self).eraseToAnyPublisher())
                    }

                    _ = subject.transform(input: Just(.refreshDetailFired).eraseToAnyPublisher())

                    let domainModel = sampleData?.toDomain()
                    expect(subject.pokemonDetail).toEventually(equal(domainModel))
                }
            }
        }
    }
}
