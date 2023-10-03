//
//  PokemonListViewController.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit
import Combine

protocol PokemonListDelegate: AnyObject {
    func viewDidLoad(in viewController: PokemonListViewController)
    func viewWillAppear(in viewController: PokemonListViewController)
    func didSelectItem(pokemon: Pokemon, in viewController: PokemonListViewController)
}

class PokemonListViewController: UIViewController {
    var viewModel: PokemonViewModelType
    let input: PassthroughSubject<PokemonViewModel.InputEvent, Never> = .init()
    let searchTextSubject = PassthroughSubject<String, Never>()
    let errorSubject = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    internal lazy var mainView: PokemonListViewType = {
        let view = PokemonListView()
        return view
    }()

    weak var delegate: PokemonListDelegate?

    init(viewModel: PokemonViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        searchCancellable?.cancel()
    }

    override func loadView() {
        view = mainView

        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBar.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = viewModel.pageTitle

        bind()
        bindSearchBar()

        delegate?.viewDidLoad(in: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewDidAppear)
        delegate?.viewWillAppear(in: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.viewWillLayoutUpdate()
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let `self` = self else {
                    return
                }
                switch event {
                case .searchResults(let pokemons):
                    self.mainView.updateData(pokemons: pokemons)

                case .fetchListDidSucceed(let pokemons):
                    self.mainView.updateData(pokemons: pokemons)

                case .fetchListDidFail(let error):
                    logApp(error.localizedDescription)
                    self.mainView.showErrorView()
                    self.didFailWithError(error: error)

                case .showLoadingView(let isVisible):
                    self.mainView.showLoadingView(isVisible: isVisible)

                case .showLoadingMoreView(let isVisible):
                    self.mainView.showLoadingMoreView(isVisible: isVisible)

                case .showEmpty:
                    self.mainView.showEmptyView()

                case .showEmptySearchResults:
                    self.mainView.showSearchEmptyView()
                }
            }
            .store(in: &cancellables)
    }

    private func bindSearchBar() {
        searchCancellable = searchTextSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] term in
                guard let `self` = self else {
                    return
                }
                self.input.send(.searchFired(term: term))
            }

        errorSubject
            .sink { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.input.send(.refreshListFired)
            }
            .store(in: &cancellables)
    }
}
