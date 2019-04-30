import Chausie
import UIKit

final class TableViewController: UITableViewController, Pageable, HasCategory {

    private let cellIdentifier = String(describing: ImageTableViewCell.self)

    var category = Category.cats

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellReuseIdentifier: cellIdentifier
        )

        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ImageTableViewCell
        let url = URLBuilder.build(category: category, width: tableView.bounds.width, height: 200)
        cell.render(with: url)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
}
