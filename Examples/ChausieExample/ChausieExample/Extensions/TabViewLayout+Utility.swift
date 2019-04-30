import Chausie

extension TabViewLayout {
    static var `default`: TabViewLayout {
        return TabViewLayout(
            top: Position(origin: .safeArea, distance: 0),
            trailing: Position(origin: .view, distance: 16),
            leading: Position(origin: .view, distance: 16),
            height: 44
        )
    }
}
