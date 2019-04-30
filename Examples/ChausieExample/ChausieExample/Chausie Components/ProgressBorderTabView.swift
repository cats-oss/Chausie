import Chausie
import UIKit

final class ProgressBorderTabView: TabView {
    private let progressBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 43 / 255, green: 87 / 255, blue: 151 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var boraderLeading: NSLayoutConstraint?

    override func highlightCells(withRatio ratio: CGFloat) {
        super.highlightCells(withRatio: ratio)

        boraderLeading?.constant = bounds.width * ratio
    }

    override func renderCells<C: TabItemCell & UIControl>(
        with cellModels: [C.Model],
        cellGenerator: (C.Model) -> C
        ) {
        super.renderCells(with: cellModels, cellGenerator: cellGenerator)

        addSubview(progressBorderView)

        let constraints = [
            progressBorderView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(cellModels.count)),
            progressBorderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBorderView.heightAnchor.constraint(equalToConstant: 3)
        ]

        let leading = progressBorderView.leadingAnchor.constraint(equalTo: leadingAnchor)
        boraderLeading = leading

        NSLayoutConstraint.activate(constraints + [leading])
    }
}
