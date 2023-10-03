//
//  PokemonDetailView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

protocol PokemonDetailViewType: UIView {
    var tableView: UITableView { get }
    var viewModel: PokemonDetailViewModelType? { get }

    func updateData(viewModel: PokemonDetailViewModelType)
    func viewWillLayoutUpdate()
    func showLoadingView(isVisible: Bool)
    func showErrorView()
}

class PokemonDetailView: UIView {
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    internal var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    internal var errorView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "empty_state") {
            view.setEmptyImage(image)
        }
        view.setEmptyLabelText(Constants.AppState.error)
        return view
    }()

    var viewModel: PokemonDetailViewModelType?

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(tableView)
        addSubview(loadingView)
        addSubview(errorView)

        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Register custom cells
        tableView.register(HeroImageTableViewCell.self, forCellReuseIdentifier: "HeroImageTableViewCell")
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: "StatsTableViewCell")
        tableView.register(AbilitiesTableViewCell.self, forCellReuseIdentifier: "AbilitiesTableViewCell")

        showLoadingView(isVisible: false)
        // to move past the navigation bar
        tableView.contentInsetAdjustmentBehavior = .never

        // disable cell selection
        tableView.allowsSelection = false
    }
}
