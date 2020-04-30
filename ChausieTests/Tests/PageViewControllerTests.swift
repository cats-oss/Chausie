import XCTest
@testable import Chausie

private final class PageViewControllerTests: XCTestCase {
    var viewControllers: ContiguousArray<PageViewController.Child>!
    var pageViewController: PageViewController!
    var addedViews: [UIView]!

    override func setUp() {
        viewControllers = ContiguousArray((0...4).map { _ in MockPagebableViewController() })
        pageViewController = PageViewController(
            viewControllers: viewControllers,
            maxChildrenCount: 3,
            initialPageIndex: 0
        )
        pageViewController.view.layoutIfNeeded()

        updateViews()
    }

    func testSubviews() {
        XCTAssertEqual(addedViews.count, 3)

        XCTAssertTrue(addedViews.contains(viewControllers[0].view))
        XCTAssertTrue(addedViews.contains(viewControllers[1].view))
        XCTAssertTrue(addedViews.contains(viewControllers[2].view))
        XCTAssertFalse(addedViews.contains(viewControllers[3].view))
        XCTAssertFalse(addedViews.contains(viewControllers[4].view))
    }

    func testSubviewsWhenScrollToSecondIndex() {
        pageViewController.scrollToPage(at: 2, animated: false)
        updateViews()

        XCTAssertFalse(addedViews.contains(viewControllers[0].view))
        XCTAssertTrue(addedViews.contains(viewControllers[1].view))
        XCTAssertTrue(addedViews.contains(viewControllers[2].view))
        XCTAssertTrue(addedViews.contains(viewControllers[3].view))
        XCTAssertFalse(addedViews.contains(viewControllers[4].view))
    }

    func testSubviewsWhenScrollToLastIndex() {
        pageViewController.scrollToPage(at: 4, animated: false)
        updateViews()

        XCTAssertFalse(addedViews.contains(viewControllers[0].view))
        XCTAssertFalse(addedViews.contains(viewControllers[1].view))
        XCTAssertTrue(addedViews.contains(viewControllers[2].view))
        XCTAssertTrue(addedViews.contains(viewControllers[3].view))
        XCTAssertTrue(addedViews.contains(viewControllers[4].view))
    }

    func testViewFrame() {
        let size = pageViewController.view.bounds.size
        XCTAssertEqual(
            pageViewController.viewControllers[0].view.frame,
            CGRect(
                origin: CGPoint(x: size.width * 0, y: 0),
                size: size
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[1].view.frame,
            CGRect(
                origin: CGPoint(x: size.width * 1, y: 0),
                size: size
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[2].view.frame,
            CGRect(
                origin: CGPoint(x: size.width * 2, y: 0),
                size: size
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[3].view.frame.size,
            size
        )
    }

    func testViewFrameAfterRotation() {
        let window = UIWindow()
        window.addSubview(pageViewController.view)
        let currentSize = pageViewController.view.bounds.size
        let newSize = CGSize(width: currentSize.height, height: currentSize.width)

        pageViewController.view.bounds.size = newSize
        pageViewController.view.layoutIfNeeded()

        pageViewController.viewWillTransition(to: newSize, with: MockTransitionCoordinator())

        XCTAssertEqual(
            pageViewController.viewControllers[0].view.frame,
            CGRect(
                origin: CGPoint(x: newSize.width * 0, y: 0),
                size: newSize
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[1].view.frame,
            CGRect(
                origin: CGPoint(x: newSize.width * 1, y: 0),
                size: newSize
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[2].view.frame,
            CGRect(
                origin: CGPoint(x: newSize.width * 2, y: 0),
                size: newSize
            )
        )
        XCTAssertEqual(
            pageViewController.viewControllers[3].view.frame.size,
            newSize
        )
    }

    private func updateViews() {
        addedViews = pageViewController.view.subviews
            .first(where: { $0 is UIScrollView })?
            .subviews
            .filter { (v: UIView) -> Bool in
                viewControllers.contains(where: { (vc: PageViewController.Child) in vc.view == v })
        }
    }
}

private final class MockTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
    var isAnimated: Bool = false
    var presentationStyle: UIModalPresentationStyle = .none
    var initiallyInteractive: Bool = false
    var isInterruptible: Bool = false
    var isInteractive: Bool = false
    var isCancelled: Bool = false
    var transitionDuration: TimeInterval = 0
    var percentComplete: CGFloat = 1
    var completionVelocity: CGFloat = 0
    var completionCurve: UIView.AnimationCurve = .linear
    var containerView: UIView = UIView()
    var targetTransform: CGAffineTransform = .identity

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return nil
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }

    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        animation?(self)
        completion?(self)
        return false
    }

    func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        animation?(self)
        completion?(self)
        return false
    }

    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}

    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {}
}
