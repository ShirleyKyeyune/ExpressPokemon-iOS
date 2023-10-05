//
//  PokemonViewModelTests.swift
//  ExpressPokemonTests
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Quick
import Nimble
import Cuckoo
import Combine

@testable import ExpressPokemon

func setupPokemonViewModelMocks() -> (MockPokemonRepositoryType, MockPokemonListResponseStorageType, PokemonViewModel) {
    let mockPokemonRepository = MockPokemonRepositoryType()
    let mockPokemonCacheRepository = MockPokemonListResponseStorageType()
    var viewModel: PokemonViewModel

    do {
        viewModel = try PokemonViewModel(
            pokemonRepository: mockPokemonRepository,
            pokemonCacheRepository: mockPokemonCacheRepository
        )
    } catch {
        fatalError("Initialization failed")
    }

    // Stubbing the saveItems method
    stub(mockPokemonCacheRepository) { stub in
        when(stub.saveItems(any())).thenDoNothing()
    }

    return (mockPokemonRepository, mockPokemonCacheRepository, viewModel)
}

class PokemonViewModelTests: QuickSpec {
    // swiftlint:disable function_body_length closure_body_length implicitly_unwrapped_optional
    override class func spec() {
        describe("PokemonViewModel") {
            var mockPokemonRepository: MockPokemonRepositoryType!
            var mockPokemonCacheRepository: MockPokemonListResponseStorageType!
            var viewModel: PokemonViewModel!

            beforeEach {
                (mockPokemonRepository, mockPokemonCacheRepository, viewModel) = setupPokemonViewModelMocks()
            }

            context("when fetchPokemons is called") {
                it("should emit fetchListDidSucceed event when fetching is successful") {
                    testFetchPokemons(
                        mockPokemonRepository: mockPokemonRepository,
                        mockPokemonCacheRepository: mockPokemonCacheRepository,
                        viewModel: viewModel
                    )
                }
            }

            context("when searchPokemons is called") {
                it("should emit searchResults event when pokemons are found") {
                    testSearchPokemonsFound(
                        mockPokemonRepository: mockPokemonRepository,
                        mockPokemonCacheRepository: mockPokemonCacheRepository,
                        viewModel: viewModel
                    )
                }

                it("should emit showEmptySearchResults event when no pokemons are found") {
                    testSearchPokemonsNotFound(
                        mockPokemonRepository: mockPokemonRepository,
                        mockPokemonCacheRepository: mockPokemonCacheRepository,
                        viewModel: viewModel
                    )
                }
            }

            context("when transform is called with viewDidAppear event") {
                it("should emit fetchListDidSucceed event when fetching is successful") {
                    testTransformWithViewDidAppear(
                        mockPokemonRepository: mockPokemonRepository,
                        mockPokemonCacheRepository: mockPokemonCacheRepository,
                        viewModel: viewModel
                    )
                }
            }
        }
    }
}

func testFetchPokemons(
    mockPokemonRepository: MockPokemonRepositoryType,
    mockPokemonCacheRepository: MockPokemonListResponseStorageType,
    viewModel: PokemonViewModel
) {
    var cancellables = Set<AnyCancellable>()
    // Arrange
    let pokemonResponseDTO1 = PokemonListResponseDTO.PokemonResponseDTO(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
    let pokemonResponseDTO2 = PokemonListResponseDTO.PokemonResponseDTO(name: "Ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
    let pokemonResponseDTOs = [pokemonResponseDTO1, pokemonResponseDTO2]
    let pokemonListResponseDTO = PokemonListResponseDTO(
        count: 2,
        next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
        results: pokemonResponseDTOs
    )

    stub(mockPokemonRepository) { stub in
        when(stub.fetchPage(nextPageUrl: any()))
            .thenReturn(Just(pokemonListResponseDTO).setFailureType(to: APIError.self).eraseToAnyPublisher()
            )
    }

    var outputEvent: PokemonViewModel.OutputEvent?
    viewModel.outputEvents.sink { event in
        outputEvent = event
    }
    .store(in: &cancellables)

    // Act
    viewModel.fetchPokemons()

    // Assert
    let domainPokemons = pokemonListResponseDTO.toDomain().result
    expect(outputEvent).toEventually(equal(.fetchListDidSucceed(pokemons: domainPokemons)))
}

func testSearchPokemonsFound(
    mockPokemonRepository: MockPokemonRepositoryType,
    mockPokemonCacheRepository: MockPokemonListResponseStorageType,
    viewModel: PokemonViewModel
) {
    var cancellables = Set<AnyCancellable>()
    // Arrange
    viewModel.pokemons = [samplePokemon1]
    var outputEvent: PokemonViewModel.OutputEvent?

    viewModel.outputEvents.sink { event in
        outputEvent = event
    }
    .store(in: &cancellables)

    // Act
    viewModel.searchPokemons("Bulbasaur")

    // Assert
    expect(outputEvent).toEventually(equal(.searchResults(pokemons: [samplePokemon1])))
}

func testSearchPokemonsNotFound(
    mockPokemonRepository: MockPokemonRepositoryType,
    mockPokemonCacheRepository: MockPokemonListResponseStorageType,
    viewModel: PokemonViewModel
) {
    var cancellables = Set<AnyCancellable>()
    // Arrange
    viewModel.pokemons = [samplePokemon1]
    var outputEvent: PokemonViewModel.OutputEvent?

    viewModel.outputEvents.sink { event in
        outputEvent = event
    }
    .store(in: &cancellables)

    // Act
    viewModel.searchPokemons("NonExistent")

    // Assert
    expect(outputEvent).toEventually(equal(.showEmptySearchResults))
}

func testTransformWithViewDidAppear(
    mockPokemonRepository: MockPokemonRepositoryType,
    mockPokemonCacheRepository: MockPokemonListResponseStorageType,
    viewModel: PokemonViewModel
) {
    var cancellables = Set<AnyCancellable>()
    // Arrange
    stub(mockPokemonRepository) { stub in
        when(stub.fetchPage(nextPageUrl: any()))
            .thenReturn(Just(samplePokemonListResponseDTO).setFailureType(to: APIError.self).eraseToAnyPublisher()
            )
    }

    var outputEvent: PokemonViewModel.OutputEvent?
    viewModel.outputEvents.sink { event in
        outputEvent = event
    }
    .store(in: &cancellables)

    // Act
    viewModel.fetchPokemons()

    // Assert
    let domainPokemons = samplePokemonListResponseDTO.toDomain().result
    expect(outputEvent).toEventually(equal(.fetchListDidSucceed(pokemons: domainPokemons)))
}
