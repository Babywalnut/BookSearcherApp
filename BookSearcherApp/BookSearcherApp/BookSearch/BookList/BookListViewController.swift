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
  private let emptyDataView = EmptyDataView()

  // MARK: LifeCycles

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let useCase = BookSearchUseCase()
    self.viewModel = BookListViewModel(useCase: useCase)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    self.bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
    self.layout()
  }

  private func configure() {
    self.view.backgroundColor = .white
  }

  private func layout() {
    self.navigationItem.titleView = bookListSearchBar

    [
      self.bookListView,
      self.emptyDataView
    ].forEach {
      self.view.addSubview($0)
    }

    self.bookListView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.emptyDataView.snp.makeConstraints {
      $0.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
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

    self.bookListSearchBar.rx.searchButtonClicked
      .asSignal()
      .emit { [weak self] _ in
        guard let self = self else { return }
        self.bookListView.setContentOffset(.zero, animated: true)
      }
      .disposed(by: self.disposeBag)

    let dataSource = RxTableViewSectionedReloadDataSource<BookListCellSection> { data, tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier, for: indexPath) as? BookListViewCell else {
        return BookListViewCell()
      }
      cell.bind(item: item)
      return cell
    }

    self.viewModel.bookListCellSection
      .skip(1)
      .bind(to: self.bookListView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)

    self.viewModel.showLoadingView
      .asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .drive { [weak self] _ in
        guard let self = self else { return }
        self.showLoadingView()
      }
      .disposed(by: self.disposeBag)

    self.viewModel.dismissLoadingView
      .asDriver(onErrorJustReturn: true)
      .filter { $0 }
      .drive { [weak self] _ in
        guard let self = self else { return }
        self.dismissLoadingView()
      }
      .disposed(by: self.disposeBag)

    self.bookListView.rx.didEndDragging
      .map { [weak self] _ -> Bool in
        guard let self = self else { return false }
        let offsetY = self.bookListView.contentOffset.y
        let contentHeight = self.bookListView.contentSize.height
        let height = self.bookListView.frame.size.height

        if offsetY > contentHeight - height {
          return true
        }
        return false
      }
      .bind(to: viewModel.scrollToRequest)
      .disposed(by: self.disposeBag)

    self.viewModel.emptyState
      .asDriver(onErrorJustReturn: true)
      .drive {
        self.emptyDataView.isHidden = !$0
      }
      .disposed(by: self.disposeBag)


    self.viewModel.bookListCellSection
      .map {
        if $0.isEmpty {
          return "전체항목(0)"
        } else {
          let sectionCount = self.bookListView.numberOfSections
          let lastSectionCount = self.bookListView.numberOfRows(inSection: sectionCount - 1)
          let cellCount = (sectionCount - 1) * 10 + lastSectionCount
          return "전체항목(\(cellCount))"
        }
      }
      .bind(to: self.bookListView.bookListHeaderView.resultLabel.rx.text)
      .disposed(by: self.disposeBag)

    // MARK: Navigation(push)

    self.bookListView.rx.modelSelected(BookListCellSection.Item.self)
      .bind {
        let bookDetailViewModel = BookDetailViewModel(id: $0.id)
        let bookDetailViewController = BookDetailViewController(viewModel: bookDetailViewModel)
        self.navigationController?.pushViewController(bookDetailViewController, animated: false)
      }
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
