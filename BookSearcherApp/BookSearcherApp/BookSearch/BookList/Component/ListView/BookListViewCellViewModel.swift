//
//  BookListViewCellViewModel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import RxCocoa
import RxSwift

protocol BookListViewCellViewModelLogic {
  var cellImageURL: PublishRelay<String?> { get }
  var cellImageData: PublishRelay<UIImage> { get set }
}

class BookListViewCellViewModel: BookListViewCellViewModelLogic {

  var cellImageURL: PublishRelay<String?>
  var cellImageData: PublishRelay<UIImage>
  private let disposeBag = DisposeBag()

  init(useCase: ThumbnailUseCase = ThumbnailUseCase()) {
    self.cellImageURL = PublishRelay<String?>()
    self.cellImageData = PublishRelay<UIImage>()

    self.cellImageURL
      .map { link -> UIImage in
        guard let imageLink = link else {
          return UIImage(systemName: "book")!
        }
        let cacheKey = NSString(string: imageLink)
        guard let image = CacheManager.shared.cache.object(forKey: cacheKey) else {
          return useCase.fetchURLImage(link: imageLink)
        }
        return image
      }
      .bind(to: self.cellImageData)
      .disposed(by: self.disposeBag)
  }
}
