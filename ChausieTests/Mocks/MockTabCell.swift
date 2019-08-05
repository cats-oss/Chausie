import Chausie

final class MockTabCell: UIButton, TabItemCell {
    typealias Model = String

    private(set) var ratio: CGFloat?

    static func make(model: Model) -> MockTabCell {
        let cell = MockTabCell()
        cell.setTitle(model, for: .normal)
        return cell
    }

    func updateHighlightRatio(_ ratio: CGFloat) {
        self.ratio = ratio
    }
}
