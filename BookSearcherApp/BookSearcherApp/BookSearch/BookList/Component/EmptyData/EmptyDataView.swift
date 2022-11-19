//
//  EmptyDataView.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/17.
//

import UIKit

import SnapKit
import Then

class EmptyDataView: UIView {

  private var emptyImageView = UIImageView()
  private var emptyLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configure()
    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    self.backgroundColor = .white
    self.isHidden = true
  }

  private func attribute() {
    self.emptyImageView.do {
      $0.image = UIImage(systemName: "book")
      $0.tintColor = .black
      $0.alpha = 0.1
    }

    self.emptyLabel.do {
      $0.text = "No Data"
      $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
  }

  private func layout() {
    [
      self.emptyImageView,
      self.emptyLabel
    ].forEach {
      self.addSubview($0)
    }

    self.emptyImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(100)
      $0.top.equalToSuperview().inset(350)
      $0.width.height.equalTo(self.snp.width)
    }

    self.emptyLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-100)
    }
  }
}
