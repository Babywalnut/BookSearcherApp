//
//  BookListView.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

import RxDataSources
import RxSwift

class BookListView: UITableView {

  // MARK: Views

  let bookListHeaderView = BookListHeaderView()
  private let disposeBag = DisposeBag()

  // MARK: LifeCycles

  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)

    self.configure()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    self.register(BookListViewCell.self, forCellReuseIdentifier: BookListViewCell.identifier)
    self.separatorStyle = .singleLine
  }

  private func layout() {
    self.tableHeaderView = self.bookListHeaderView
    

    self.bookListHeaderView.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(17)
    }
  }

  func bind(viewModel: BookListViewModelLogic) {
    let dataSource = RxTableViewSectionedReloadDataSource<BookListCellSection> { data, tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier, for: indexPath) as? BookListViewCell else {
        return BookListViewCell()
      }
      cell.bind(item: item)
      return cell
    }

    viewModel.bookListCellSection
      .skip(1)
      .bind(to: self.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)

    self.rx.didEndDragging
      .map { [weak self] _ -> Bool in
        guard let self = self else { return false }
        let offsetY = self.contentOffset.y
        let contentHeight = self.contentSize.height
        let height = self.frame.size.height

        if offsetY > contentHeight - height {
          return true
        }
        return false
      }
      .bind(to: viewModel.scrollToRequest)
      .disposed(by: self.disposeBag)

    viewModel.bookListCellSection
      .map {
        if $0.isEmpty {
          return "전체항목(0)"
        } else {
          let sectionCount = self.numberOfSections
          let lastSectionCount = self.numberOfRows(inSection: sectionCount - 1)
          let cellCount = (sectionCount - 1) * 10 + lastSectionCount
          return "전체항목(\(cellCount))"
        }
      }
      .bind(to: self.bookListHeaderView.resultLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
