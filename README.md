<img align="left" width="60" height="60" src="https://github.com/zooorkin/TinkoffChat/blob/master/TinkoffChat/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png?raw=true">

# TinkoffChat

Приложение TinkoffChat реализует следующие возможности:
* Сообщает о смене состояний приложения
* Сообщает о смене состояния Views, принадлежащих ViewController

## Состояния приложения
* Not Running
* Inactive
* Active
* Background
* Suspended
            
Методы протокола UIApplicationDelegate:
```
application(_:willFinishLaunchingWithOptions:)
application(_:didFinishLaunchingWithOptions:)

applicationWillResignActive(_:)
applicationDidBecomeActive(_:)

applicationDidEnterBackground(_:)
applicationWillEnterForeground(_:)

applicationWillTerminate(_:)
```
<p align="left">
  <img width="300" src="https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Art/high_level_flow_2x.png">
</p>

## Состояния Views
* Appearing
* Appeared
* Disappearing
* Disappeared

Состояние Appearing (Disappearing) – уточнённое состояние Appeared (Disappeared).
Таким образом, когда View находится в состоянии Appearing (Disappearing), то он
находится в состоянии Appeared (Disappeared), что соответствует [1].

Методы класса UIViewController:
```
loadView()
viewDidLoad()

viewWillAppear(_:)
viewDidAppear(_:)
viewWillDisappear(_:)
viewWillDisappear(_:)

viewWillLayoutSubviews()
viewDidLayoutSubviews()
```
<p align="left">
  <img width="400" src="https://docs-assets.developer.apple.com/published/f06f30fa63/UIViewController_Class_Reference_2x_ddcaa00c-87d8-4c85-961e-ccfb9fa4aac2.png">
</p>

## Авторы
* **Зорькин Андрей**

## Ссылки
[1] Apple: UIViewController
    https://developer.apple.com/documentation/uikit/uiviewcontroller
