# UIViewController-DisplayChild

[![CI Status](https://img.shields.io/travis/inloop/UIViewController-DisplayInDrawer.svg?style=flat)](https://travis-ci.org/inloop/UIViewController-DisplayChild)
[![License](https://img.shields.io/cocoapods/l/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayChild)
[![Version](https://img.shields.io/cocoapods/v/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayInDrawer)
[![Platform](https://img.shields.io/cocoapods/p/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayChild)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

**The problem:** sometimes you need to embed a controller, but it might be embedded already. E.g. you have an empty view, and you do refresh only to get empty view again. If you do not check for its existence, you might end up creating a new instance unneccessarily. This can also have bad side effects when there is some heavier work in viewDidLoad for example.

**The solution:** transition to type, instead of an instance. If the instance does not exist, it is created for you and you have a possibility to configure it after initialization via `configuration` closure. If the instance does exist, only the configuration closure is performed so that you can display a new content. You do not have to worry anymore whether the controller you intent to embed is already presented.

Example:

```swift
displayChild(
  ofType: ErrorViewController.self,
  in: containerView,
  animated: false,
  configuration: { controller in
      controller.model = model
  }
)
```
