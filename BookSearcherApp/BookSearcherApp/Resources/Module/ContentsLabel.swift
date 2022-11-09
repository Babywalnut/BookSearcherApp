//
//  ContentsLabel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

class ContentsLabel: UILabel {

  // MARK: LifeCycles

  init(textColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight) {
    super.init(frame: .zero)

    self.configure(
      textColor: textColor,
      fontSize: fontSize,
      weight: weight
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(textColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight ) {
    self.textColor = textColor
    self.numberOfLines = 1
    self.lineBreakMode = .byTruncatingTail
    self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
  }
}
