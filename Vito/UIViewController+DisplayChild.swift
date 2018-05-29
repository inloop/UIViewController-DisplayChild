//  Copyright © 2018 Inloop, s.r.o. All rights reserved.

import UIKit

public protocol InstantiableViewController where Self: UIViewController {
    static func makeInstance() -> Self
}

public extension UIViewController {
    public typealias VoidClosure = () -> Void

    private static let embedTransitionAnimationDuration = 0.25

    /**
     Detects if a child view controller of specified type is already embedded.
     If it is, configuration and completion closures are called on existing and this one is returned.
     If it does not exist yet, it is instantiated, configured and embedded in specified container view.
     - Parameter toType: a view controller type to embed
     - Parameter in: a view to embed child to. The child is embedded to the `self.view` if this is nil. Nil is the default value.
     - Parameter animated: if there is already embedded child in `containerView` the transition is animated if `true`
     - Parameter configuration: a closure which is called after the controller is initialized.
     This is where you can configure the controller before presenting.
     - Parameter completion: a closure which is called after the child view controller presentation is finished.
     - Returns: Newly created and embedded or already existing controller of specified type.
     */
    @discardableResult func displayChild<T: InstantiableViewController>(ofType viewControllerType: T.Type,
                                                                        in optionalContainerView: UIView? = nil,
                                                                        animated: Bool = true,
                                                                        configuration: ((T) -> Void)? = nil,
                                                                        completion: ((T) -> Void)? = nil) -> T {
        let result: T
        let containerView = optionalContainerView ?? view!
        if let existingController: T = childViewController(in: containerView) {
            configuration?(existingController)
            completion?(existingController)
            result = existingController
        } else {
            let newController = viewControllerType.makeInstance()
            configuration?(newController)
            transition(to: presentedController(with: newController), containerView: containerView, animated: animated) {
                completion?(newController)
            }
            result = newController
        }
        return result
    }

    private func presentedController(with newController: UIViewController) -> UIViewController {
        return newController.navigationController ?? newController
    }

    /**
     Embeds a child view controller.
     - Parameter to: a view controller to embed
     - Parameter containerView: a view to embed child to. The child is embedded to the `self.view` if containerView is nil. Nil is the default value.
     - Parameter animated: if there is already embedded child in `containerView` the transition is animated if `true`
     - Parameter completion: a closure which is called after embed is finished.
     */
    private func transition(to newChild: UIViewController,
                            containerView optionalContainerView: UIView? = nil,
                            animated: Bool = true,
                            completion: VoidClosure? = nil) {
        let containerView = optionalContainerView ?? view!
        addChildViewController(newChild)
        /*
         We set the frame in advance, before autolayout does the same again in swichViews().
         This is a workaround for users who embed UICollectionView somewhere in the child and experience the
         dreaded "the item height must be less than the height of the UICollectionView" warning. (even if they
         properly react to viewDidLayoutSubviews and change the item size the warning is always present otherwise)
         */
        newChild.view.frame = containerView.bounds
        if let existingChild = childViewController(at: containerView) {
            existingChild.willMove(toParentViewController: nil)
            if animated {
                UIView.transition(with: containerView,
                                  duration: UIViewController.embedTransitionAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: {
                                    self.switchViews(in: containerView, new: newChild.view!, old: existingChild.view!)
                },
                                  completion: { _ in
                                    self.switchControllers(new: newChild, old: existingChild)
                                    completion?()
                })
            } else {
                switchViews(in: containerView, new: newChild.view!, old: existingChild.view!)
                switchControllers(new: newChild, old: existingChild)
                completion?()
            }
        } else {
            embed(newChild, in: containerView)
            completion?()
        }
    }

    func removeChildViewController(from containerView: UIView) {
        let child = childViewController(at: containerView)
        child?.willMove(toParentViewController: nil)
        child?.view.removeFromSuperview()
        child?.removeFromParentViewController()
    }

    func childViewController<T>(in optionalContainerView: UIView? = nil) -> T? {
        let containerView = optionalContainerView ?? view!
        return childViewController(at: containerView) as? T
    }

    func hasChild<T>(ofType controllerType: T.Type, in optionalContainerView: UIView? = nil) -> Bool {
        let exists: T? = childViewController(in: optionalContainerView)
        return exists != nil
    }

    ///returns `Any` UIViewController which happens to be in the container, regardless of type
    private func childViewController(at containerView: UIView) -> UIViewController? {
        return childViewControllers.first(where: { containerView.subviews.contains($0.view) })
    }

    private func switchViews(in container: UIView, new: UIView, old: UIView) {
        old.removeFromSuperview()
        container.pinSubview(new)
    }

    private func switchControllers(new: UIViewController, old: UIViewController) {
        old.removeFromParentViewController()
        new.didMove(toParentViewController: self)
    }

    private func embed(_ child: UIViewController, in containerView: UIView) {
        containerView.pinSubview(child.view!)
        child.didMove(toParentViewController: self)
    }
}

private extension UIView {
    func pinSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        let views = ["v": subview]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", metrics: nil, views: views)
        NSLayoutConstraint.activate(vertical + horizontal)
    }
}
