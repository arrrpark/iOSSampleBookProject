# iOSSampleBookProject

This project is a sample project that shows my coding style.

This proejct uses MVVM architecture. ViewModel is injected and used in all ViewControllers, seperating business logic from presentation logic.

Instead of using storyboards, I made UI programmatically using SnapKit.

RxSwift's Single is used for network. Also, since BookmarkCollectionView needs to repond to user interactions received from various screens, BehaviorRelay is used for the data source.

FMDB is used to store user's bookmark permanently. All oprations related with local data storage are processed via BookmarkDAO.

Use need to pod install first to run this project

![iOS MVVM](https://user-images.githubusercontent.com/69378425/164171073-f5219a28-5415-4ea8-8cec-331ca5e5f5e6.JPG)
