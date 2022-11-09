//
//  BookListViewController.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit
import Then

class BookListViewController: UIViewController {

  // MARK: Properties

  private let viewModel: BookListViewModelLogic
  private let disposeBag = DisposeBag()

  // MARK: Views

  private let bookListSearchBar = BookListSearchBar()
  private let bookListView = BookListView()

  // MARK: LifeCycles

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let network = NetworkManager()
    let useCase = BookSearchUseCase(network: network)
    self.viewModel = BookListViewModel(useCase: useCase)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
    self.layout()
    self.bind()
  }

  private func configure() {
    self.view.backgroundColor = .white
  }

  private func layout() {
    self.navigationItem.titleView = bookListSearchBar
    self.view.addSubview(self.bookListView)

    self.bookListView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  private func bind() {
    self.bookListSearchBar.rx.searchButtonClicked
      .asSignal()
      .emit(to: self.bookListSearchBar.rx.endEditing)
      .disposed(by: self.disposeBag)

    self.bookListSearchBar.rx.searchButtonClicked
      .withLatestFrom(self.bookListSearchBar.rx.text.orEmpty)
      .distinctUntilChanged()
      .bind(to: self.viewModel.inputText)
      .disposed(by: self.disposeBag)

    let dataSource = RxTableViewSectionedReloadDataSource<BookListCellSection> { data, tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier, for: indexPath) as? BookListViewCell else {
        return BookListViewCell()
      }

      cell.setData(item: item)
      return cell
    }

    self.viewModel.bookListCellSection
      .skip(1)
      .bind(to: self.bookListView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: BookListSearchBar {
  var endEditing: Binder<Void> {
    return Binder(base) { base, _ in
      base.endEditing(true)
    }
  }
}
