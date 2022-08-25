import UIKit

class CountriesViewController: UIViewController {
  let viewModel = CountriesModule().viewModel

  @IBOutlet var tableView: UITableView!
  @IBOutlet var tryAgainButton: UIButton!
  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBAction func tryAgainTap(_ sender: UIButton) {
    viewModel.tryAagain()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpViewModel()
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.enterScreen()
  }
  
  private func setUpViewModel() {
    viewModel.view = self
  }

  private func setupTableView() {
    tableView.dataSource = self
    registerNibs()
  }

  private func registerNibs() {
    tableView.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.key)
  }
}

extension CountriesViewController: CountriesView {
  func notifyUpdateRequired() {
    if let state = viewModel.state {
      DispatchQueue.main.async { [weak self] in
        self?.updateView(with: state)
      }
    }
  }

  private func updateView(with state: CountriesState) {
    updateSpinner(with: state)
    upadateTableView(with: state)
    updateTryAgain(with: state)
  }

  private func upadateTableView(with state: CountriesState) {
    tableView.isHidden = state.error != nil
    tableView.reloadData()
  }

  private func updateTryAgain(with state: CountriesState) {
    tryAgainButton.isHidden = state.error == nil
  }

  private func updateSpinner(with state: CountriesState) {
    if state.isLoading {
      spinner.startAnimating()
    } else {
      spinner.stopAnimating()
    }
  }
}

extension CountriesViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    viewModel.state?.countries?.count ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CountryCell.key,
        for: indexPath
      ) as? CountryCell,
      let countries = viewModel.state?.countries
    else {
      return UITableViewCell()
    }

    cell.config(model: countries[indexPath.row])

    return cell
  }
}
