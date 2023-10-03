//
//  PokemonDetailViewController.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit
import Combine

protocol PokemonDetailViewDelegate: AnyObject {
    func viewDidLoad(in viewController: PokemonDetailViewController)
    func viewWillAppear(in viewController: PokemonDetailViewController)
}

class PokemonDetailViewController: UIViewController {
    var viewModel: PokemonDetailViewModelType
    let input: PassthroughSubject<PokemonDetailViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    internal lazy var mainView: PokemonDetailViewType = {
        let view = PokemonDetailView()
        return view
    }()

    weak var delegate: PokemonDetailViewDelegate?

    private var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)

        let chevronBackwardImage = UIImage(named: "backWhite")
        let coloredImage = chevronBackwardImage?.withRenderingMode(.alwaysTemplate)

        button.setImage(coloredImage, for: .normal)
        button.tintColor = UIColor.white

        return button
    }()

    init(viewModel: PokemonDetailViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        title = "Pokemon Details"

        // to hide top area
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        bind()
        delegate?.viewDidLoad(in: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewDidAppear)
        delegate?.viewWillAppear(in: self)

        // Hide the navigation bar.
        navigationController?.isNavigationBarHidden = true

        // Add the custom back button to the view hierarchy.
        view.addSubview(backButton)

        // Set the button's constraints.
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // reset status bar
        self.navigationController?.changeStatusBarColor(backgroundColor: .white)
        // Show the navigation bar.
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                case .fetchDetailDidSucceed:
                    self.mainView.updateData(viewModel: viewModel)

                case .fetchDetailDidFail(let error):
                    logApp(error.localizedDescription)
                    self.mainView.showErrorView()

                case .showLoadingView(let isVisible):
                    self.mainView.showLoadingView(isVisible: isVisible)
                }
            }
            .store(in: &cancellables)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
