import XCTest
@testable import Chausie

private final class TabViewTests: XCTestCase {
    var tabView: TabView!
    let models = ["a", "b", "c"]

    override func setUp() {
        tabView = TabView()
        tabView.renderCells(with: models, cellGenerator: { MockTabCell.make(model: $0) })
        tabView.frame.size = CGSize(width: 200, height: 100)
        tabView.layoutIfNeeded()
    }

    func testCellCount() {
        let cells = tabView.cells.filter { $0 is MockTabCell }
        XCTAssertEqual(cells.count, models.count)
    }

    func testCellModel() {
        let cells = tabView.cells.compactMap { $0 as? MockTabCell }
        XCTAssertEqual(cells[0].titleLabel?.text, models[0])
        XCTAssertEqual(cells[1].titleLabel?.text, models[1])
        XCTAssertEqual(cells[2].titleLabel?.text, models[2])
    }

    func testCellHighlightRatio() {
        let cells = tabView.cells.compactMap { $0 as? MockTabCell }

        tabView.highlightCells(withRatio: 0)
        XCTAssertEqual(cells[0].ratio, 1)
        XCTAssertEqual(cells[1].ratio, 0)
        XCTAssertEqual(cells[2].ratio, 0)

        tabView.highlightCells(withRatio: 1 / CGFloat(models.count))
        XCTAssertEqual(cells[0].ratio, 0)
        XCTAssertEqual(cells[1].ratio, 1)
        XCTAssertEqual(cells[2].ratio, 0)

        tabView.highlightCells(withRatio: 2 / CGFloat(models.count))
        XCTAssertEqual(cells[0].ratio, 0)
        XCTAssertEqual(cells[1].ratio, 0)
        XCTAssertEqual(cells[2].ratio, 1)
    }
}
