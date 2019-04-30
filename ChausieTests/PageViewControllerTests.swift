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

    private func updateViews() {
        addedViews = pageViewController.view.subviews
            .first(where: { $0 is UIScrollView })?
            .subviews
            .filter { (v: UIView) -> Bool in
                viewControllers.contains(where: { (vc: PageViewController.Child) in vc.view == v })
        }
    }
}
