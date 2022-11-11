//
//  BasicInformationContentView.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/11.
//

import UIKit

import SnapKit
import Then

class BasicInformationContentView: UIView {

  private let titleLabel = ContentsLabel(
    textColor: .black,
    fontSize: 20,
    weight: .bold
  )

  private let bookInfoStackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func attribute() {
    self.bookInfoStackView.do {
      $0.axis = .vertical
      $0.alignment = .trailing
      $0.distribution = .fillEqually
      $0.spacing = 10
    }
  }

  private func layout() {
    [
      self.titleLabel,
      self.bookInfoStackView
    ].forEach {
      self.addSubview($0)
    }

    self.titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalToSuperview().dividedBy(10)
    }

    self.bookInfoStackView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(self.titleLabel)
    }
  }

  func setData(data: DetailVolumeModel) {
    self.titleLabel.text = data.title

    DetailViewContentType.allCases.forEach { type in

      let contentLabel = ContentsLabel(textColor: .gray, fontSize: 15, weight: .regular)

      var applyValue: String?

      switch type {
      case .publisher:
        applyValue = (data.publisher ?? "No Information") + "  " + type.rawValue
      case .publishedDate:
        applyValue = (data.publishedDate ?? "No Information") + "  " + type.rawValue
      case .language:
        applyValue = (data.language ?? "No Information") + "  " + type.rawValue  
      }

      contentLabel.text = applyValue

      self.bookInfoStackView.addArrangedSubview(contentLabel)
    }
  }
}
