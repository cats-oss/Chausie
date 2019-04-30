import UIKit

/// An object that manages tab items.
open class TabView: UIView {
    private struct Component {
        var cell: UIControl
        var updateHighlightRatio: (CGFloat) -> Void
    }

    /// This closure is called when a touch-up event occurs in the item where the finger is
    /// inside the bounds of the control.
    public var selectedCell: ((UIControl, Int) -> Void)?

    /// An array of item in tab view.
    public var cells: [UIControl] {
        return components.map { $0.cell }
    }

    /// An array of component.
    private var components: [Component] = []

    /// Changes highlight state of tab items.
    ///
    /// - Parameters:
    ///     - ratio: The ratio of scroll view's offset position in the range 0.0 to 1.0.
    open func highlightCells(withRatio ratio: CGFloat) {
        let cellsRatio = 1 / CGFloat(components.count)
        zip(components, components.indices).forEach { component, index in
            let highlightRatio = 1 - (abs(CGFloat(index) * cellsRatio - ratio) / cellsRatio)
            component.updateHighlightRatio(max(0, highlightRatio))
        }
    }

    /// Makes and adds items to the end of the receiver’s list of subviews.
    /// Generic type-`C` is must conform to `TabItemCell` and be a subclass of `UIControl`.
    ///
    /// - Parameters:
    ///     - cellModels: An array of model used to make items.
    ///     - cellGenerator: A factory closure that make a customized `C`-type object.
    open func renderCells<C: TabItemCell & UIControl>(
        with cellModels: [C.Model],
        cellGenerator: ((C.Model) -> C)
        ) {

        components.forEach { $0.cell.removeFromSuperview() }
        components.removeAll()

        var constraints: [NSLayoutConstraint] = []
        var leading = leadingAnchor
        cellModels.forEach { model in
            let cell = cellGenerator(model)

            components.append(
                Component(
                    cell: cell,
                    updateHighlightRatio: { ratio in
                        cell.updateHighlightRatio(ratio)
                    }
                )
            )

            addSubview(cell)
            cell.translatesAutoresizingMaskIntoConstraints = false
            constraints += [
                cell.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(cellModels.count)),
                cell.heightAnchor.constraint(equalTo: heightAnchor),
                cell.topAnchor.constraint(equalTo: topAnchor),
                cell.leadingAnchor.constraint(equalTo: leading)
            ]
            leading = cell.trailingAnchor

            cell.addTarget(self, action: #selector(selectedCell(_:)), for: .touchUpInside)
        }

        NSLayoutConstraint.activate(constraints)
    }

    @objc func selectedCell(_ sender: UIControl) {
        components.firstIndex(where: { $0.cell == sender }).map { selectedCell?(sender, $0) }
    }
}
