//
//  PokemonListView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit

protocol PokemonListViewType: UIView {
    var searchBar: UISearchBar { get }
    var collectionView: UICollectionView { get }

    func updateData(pokemons: [Pokemon])
    func viewWillLayoutUpdate()
    func showLoadingView(isVisible: Bool)
    func showLoadingMoreView(isVisible: Bool)
    func showEmptyView()
    func showSearchEmptyView()
    func showErrorView()
    func addNewItems(newPokemons: [Pokemon])
}

class PokemonListView: UIView {
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let loadingMoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    internal var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    internal var emptyView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "empty_state") {
            view.setEmptyImage(image)
        }
        view.setEmptyLabelText(Constants.AppState.empty)
        return view
    }()

    internal var searchEmptyView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "nothing_found") {
            view.setEmptyImage(image)
        }
        view.setEmptyLabelText(Constants.AppState.emptySearchResults)
        return view
    }()

    internal lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.PlaceHolder.search
        return searchBar
    }()

    internal lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    internal var loadingMoreView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    var pokemons: [Pokemon] = []

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Setup the search bar
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Setup the collection view
        addSubview(collectionView)
        addSubview(loadingView)

        let spacerView = UIView()
        let anotherSpacerView = UIView()
        loadingMoreStackView.addArrangedSubview(spacerView)
        loadingMoreStackView.addArrangedSubview(loadingMoreView)
        loadingMoreStackView.addArrangedSubview(anotherSpacerView)
        bottomStackView.addArrangedSubview(loadingMoreStackView)
        addSubview(bottomStackView)

        addSubview(emptyView)
        addSubview(searchEmptyView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: UISize.pt80),

            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),

            loadingMoreStackView.heightAnchor.constraint(equalToConstant: UISize.pt18),
            spacerView.widthAnchor.constraint(equalTo: anotherSpacerView.widthAnchor),

            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: UISize.pt12),

            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchEmptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchEmptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Register cell
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: "PokemonCell")

        showLoadingView(isVisible: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCollectionViewFlowLayout()
    }

    /// Required for the collectionView to display on the screen
    func setupCollectionViewFlowLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 20
            let availableWidth = frame.width - (padding * 3)
            let widthPerItem = availableWidth / 2

            layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.minimumLineSpacing = padding
            layout.minimumInteritemSpacing = padding
        }
    }
}
