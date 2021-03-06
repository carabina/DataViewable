import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var tableView: DataTableView!
	@IBOutlet weak var headerView: UIView!
	@IBOutlet var emptyView: UIView!

	let data = (0..<15).map { "Row  \($0)" }

	var isEmpty = false {
		didSet {
			tableView.reloadData()
		}
	}

	var useCustomEmptyView: Bool = true {
		didSet {
			tableView.reloadEmptyDataSet()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.reloadData()
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()

		tableView.emptyDataSetSource = self

		tableView.shouldDisplayDataViewableOverHeader = true

		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "Data", style: .plain, target: self, action: #selector(loadData)),
			UIBarButtonItem(title: "Empty", style: .plain, target: self, action: #selector(hideData))
		]
	}

	@objc func loadData() {
		tableView.isLoading = true

		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
			self?.isEmpty = false
			self?.tableView.isLoading = false
		}
	}

	@objc func hideData() {
		isEmpty = true
	}

	@IBAction func toggleSwitch(_ sender: UISwitch) {
		switch sender.tag {
		case 0:
			tableView.shouldDisplayDataViewableOverHeader = sender.isOn
		case 1:
			useCustomEmptyView = sender.isOn
		default:
			break
		}
		tableView.reloadEmptyDataSet()
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isEmpty ? 0 : data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = data[indexPath.row]
		return cell
	}
}

extension ViewController: DataViewSource {

	func emptyViewForDataView(_ dataView: DataViewable) -> UIView? {
		return useCustomEmptyView ? emptyView : EmptyDataViewFactory.makeEmptyDataView(for: self)
	}
}

extension ViewController: EmptyDataViewDelegate {
	func emptyDataViewWasPressed(_ emptyDataView: EmptyDataView) {
		print("tap")
	}

	func emptyDataViewDidPressButton(_ emptyDataView: EmptyDataView) {
		loadData()
	}

	func emptyDataViewDidPressImage(_ emptyDataView: EmptyDataView) {
		print("image")
	}
}
