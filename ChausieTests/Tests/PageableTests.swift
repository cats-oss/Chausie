import XCTest
@testable import Chausie

private final class PageableTests: XCTestCase {
    var didAppearEvents: [PageIndex]!
    var didDisappearEvents: [PageIndex]!
    var viewControllers: ContiguousArray<PageViewController.Child>!
    var pageViewController: PageViewController!

    override func setUp() {
        didAppearEvents = []
        didDisappearEvents = []
    }

    override func tearDown() {
        didAppearEvents.removeAll()
        didDisappearEvents.removeAll()
    }

    func testIniaialPageableMethodBehavior() {
        let mocks = (0...2).map { [weak self] _ -> MockViewController in
            let controller = MockViewController()
            controller.didAppearAt = { self?.didAppearEvents.append($0) }
            controller.didDisappearAt = { self?.didDisappearEvents.append($0) }
            return controller
        }
        viewControllers = ContiguousArray(mocks)
        pageViewController = PageViewController(
            viewControllers: viewControllers,
            maxChildrenCount: 1,
            initialPageIndex: 0
        )
        pageViewController.view.layoutIfNeeded()

        pageViewController.viewDidAppear(true)
        pageViewController.viewDidDisappear(true)

        XCTAssertEqual(didAppearEvents, [0])
        XCTAssertEqual(didDisappearEvents, [0])
    }

    func testPageableMethodBehaviorAfterScroll() {
        let mocks = (0...2).map { [weak self] _ -> MockViewController in
            let controller = MockViewController()
            controller.didAppearAt = { self?.didAppearEvents.append($0) }
            controller.didDisappearAt = { self?.didDisappearEvents.append($0) }
            return controller
        }
        viewControllers = ContiguousArray(mocks)
        pageViewController = PageViewController(
            viewControllers: viewControllers,
            maxChildrenCount: 1,
            initialPageIndex: 0
        )
        pageViewController.view.layoutIfNeeded()

        pageViewController.viewDidAppear(true)

        pageViewController.scrollToPage(at: 1, animated: false)

        XCTAssertEqual(didAppearEvents, [0, 1])
        XCTAssertEqual(didDisappearEvents, [0])

        pageViewController.scrollToPage(at: 2, animated: false)
        XCTAssertEqual(didAppearEvents, [0, 1, 2])
        XCTAssertEqual(didDisappearEvents, [0, 1])

        pageViewController.viewDidDisappear(true)
        XCTAssertEqual(didAppearEvents, [0, 1, 2])
        XCTAssertEqual(didDisappearEvents, [0, 1, 2])
    }

    func testPageableMethodBehaviorAfterScrollForMaxChildrenCount() {
        let mocks = (0...2).map { [weak self] _ -> MockViewController in
            let controller = MockViewController()
            controller.didAppearAt = { self?.didAppearEvents.append($0) }
            controller.didDisappearAt = { self?.didDisappearEvents.append($0) }
            return controller
        }
        viewControllers = ContiguousArray(mocks)
        pageViewController = PageViewController(
            viewControllers: viewControllers,
            maxChildrenCount: mocks.count,
            initialPageIndex: 0
        )
        pageViewController.view.layoutIfNeeded()

        pageViewController.viewDidAppear(true)

        pageViewController.scrollToPage(at: 1, animated: false)

        XCTAssertEqual(didAppearEvents, [0, 1])
        XCTAssertEqual(didDisappearEvents, [0])

        pageViewController.scrollToPage(at: 2, animated: false)
        XCTAssertEqual(didAppearEvents, [0, 1, 2])
        XCTAssertEqual(didDisappearEvents, [0, 1])

        pageViewController.viewDidDisappear(true)
        XCTAssertEqual(didAppearEvents, [0, 1, 2])
        XCTAssertEqual(didDisappearEvents, [0, 1, 2])
    }
}

private final class MockViewController: UIViewController, Pageable {
    var didAppearAt: ((PageIndex) -> Void)?
    var didDisappearAt: ((PageIndex) -> Void)?

    func pageViewController(_ pageViewController: PageViewController, didAppearAt index: PageIndex) {
        didAppearAt?(index)
    }

    func pageViewController(_ pageViewController: PageViewController, didDisappearAt index: PageIndex) {
        didDisappearAt?(index)
    }
}
