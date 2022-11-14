# 럭스로보 iOS 개발과제

## Cocoapod을 사용했어요
PODS:
  - Alamofire (5.6.2)
  - Differentiator (5.0.0)
  - RxCocoa (6.5.0):
    - RxRelay (= 6.5.0)
    - RxSwift (= 6.5.0)
  - RxDataSources (5.0.0):
    - Differentiator (~> 5.0)
    - RxCocoa (~> 6.0)
    - RxSwift (~> 6.0)
  - RxRelay (6.5.0):
    - RxSwift (= 6.5.0)
  - RxSwift (6.5.0)
  - SnapKit (5.6.0)
  - Then (3.0.0)
  
## 개발 환경
  - Deployment Target: iOS 14.1
  - Xcode Version: 13.2.1
  
## 구조

`View(Viewcontroller) - ViewModel - UseCase - Repository(NetworkManager, CacheManager)`
의 형태로 구현했어요.

Repository(NetworkManager, CacheManager)를 통해 원천데이터를 entity형태로 가져와요
UseCase에서 비즈니스 로직으 수행해요
ViewModel에서 화면에 보여질 형태로 가공해요
View(Viewcontroller)에서 화면에 보여지 데이터르 UI에 바인드시켜줘요
  
## 리뷰노트
- 기능 요구서에 있느 기능을 모두 구현했어요
- 실제 사용자 입장에서 List에서 상세화면을 들어갈 때 서버데이터가 변경될 수도 있기에 개별API로 다시 호출을해서 화면을 꾸렸지만 원인으 알 수 없게 같은 endpoint들에서 각각 다른 entity 타입의 데이터들이 들어와 최소한의
공통 데이터만 사용하여 구현했어요 
- 상세화면을 넘어갈 때 이미지 캐싱처리를 했지만 API에서 매번 다른 주소의 데이터가 들어와서 캐시에서 다시 불러오지 않고 있어요(tableView에서느 정상적으로 캐싱처리가 되어있어요)
