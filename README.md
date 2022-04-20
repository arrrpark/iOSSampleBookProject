# iOSSampleBookProject

This project is a sample project that shows my coding style.

This proejct uses MVVM architecture. ViewModel is injected and used in all ViewControllers, seperating business logic and presentation logic.

Instead of using a storyboard, I made UI programmatically using SnapKit.

RxSwift's Single is used for network. Also, since BookmarkCollectionView needs to repond to user interactions received from various screens, BehaviorRelay is used for the data source.

FMDB is used to store user's bookmark permanently. All oprations related with local data storage are processed via BookmarkDAO.

Use need to pod install first to run this project.
