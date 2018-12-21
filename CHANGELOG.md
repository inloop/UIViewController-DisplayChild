## [2.1.0]
### Added
- `UIStackView` support. You can now use `UIStackView` as a container, and you can insert child's view with animation if you wish. `UIStackView` is a great help, especially if you have multiple childs. You no longer need to set them constraints - `UIStackView` + autolayout will do this for you.

## [2.0.0]
### Changed
- lib uses Swift 4.2 internally
- `InstantiableViewController` protocol renamed to `Instantiable` and improved to be usable in automatic UIViewController extension such as [this one](https://github.com/inloop/UIViewController-DisplayChild/pull/14#discussion_r235397999)

## [1.0.2]
### Fixed
- Xcode 10 build problem
