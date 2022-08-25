import UIKit

class CountryCell: UITableViewCell {

  static let key = String(describing: CountryCell.self)
  static let nib = UINib(nibName: key, bundle: nil)

  @IBOutlet private var nameValueLabel: UILabel!
  @IBOutlet var capitalValuesLabel: UILabel!
  @IBOutlet var populationValueLabel: UILabel!
  @IBOutlet var flagImage: UIImageView!

  func config(model: Country) {
    setName(model)
    setCapital(model)
    setPoulation(model)
    setFlag(model)
  }

  private func setName(_ model: Country) {
    nameValueLabel.text = model.name.official
  }

  private func setPoulation(_ model: Country) {
    populationValueLabel.text = String(model.population)
  }

  private func setCapital(_ model: Country) {
    guard let capitals = model.capital else {
      capitalValuesLabel.text = "--"
      return
    }

    capitalValuesLabel.text = capitals.joined(separator: ", ")
  }

  private func setFlag(_ model: Country) {
    flagImage.downloaded(from: model.flags.png)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    flagImage.image = nil
  }
}
