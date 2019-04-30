import Chausie
import UIKit

final class TabItemButton: UIButton, TabItemCell {
    typealias Model = Category

    static func make(model: Model) -> Self {
        let button = self.init()
        button.setTitle(model.rawValue, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }

    func updateHighlightRatio(_ ratio: CGFloat) {
        let highlightColor = UIColor(red: 43 / 255, green: 87 / 255, blue: 151 / 255, alpha: 1)
        let color = UIColor.lightGray.blend(with: highlightColor, multiplier: ratio)
        setTitleColor(color, for: .normal)

        let scale = ratio * 0.2 + 0.8
        let transfrom = CGAffineTransform(scaleX: scale, y: scale)
        self.transform = transfrom
    }
}

private extension UIColor {
    struct Components {
        let red, green, blue, alpha: CGFloat
    }

    var rgbaComponents: Components {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Components(red: red, green: green, blue: blue, alpha: alpha)
    }

    func blend(with color: UIColor, multiplier: CGFloat) -> UIColor {
        let multiplier = min(max(multiplier, 0), 1)
        let components = rgbaComponents
        let blendComponents = color.rgbaComponents

        let blended: (KeyPath<Components, CGFloat>) -> CGFloat = { keyPath in
            let delta = blendComponents[keyPath: keyPath] - components[keyPath: keyPath]
            return delta * multiplier + components[keyPath: keyPath]
        }

        let red = blended(\.red)
        let green = blended(\.green)
        let blue = blended(\.blue)
        let alpha = blended(\.alpha)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
