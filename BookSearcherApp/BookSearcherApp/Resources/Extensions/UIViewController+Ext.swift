//
//  UIViewController+Ext.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/14.
//
import UIKit

import SnapKit
import Then

fileprivate var containerView: UIView!

extension UIViewController {

  func showLoadingView() {
    containerView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    view.addSubview(containerView)
    containerView.addSubview(activityIndicator)

    self.configureContainerView()

    UIView.animate(withDuration: 0.25) {
      containerView.alpha = 0.8
    }

    activityIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    activityIndicator.startAnimating()
  }

  fileprivate func configureContainerView() {
    containerView.do {
      $0.frame = self.view.bounds
      $0.backgroundColor = .white
      $0.alpha = 0
    }
  }

  func dismissLoadingView() {
    DispatchQueue.main.async {
      containerView.removeFromSuperview()
      containerView = nil
    }
  }
}
