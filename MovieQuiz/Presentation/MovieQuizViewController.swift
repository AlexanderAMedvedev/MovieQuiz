import UIKit
protocol PresenterUseViewController: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func frameHighlight(_ firstColor: Bool)
    func show(quiz result: QuizResultsViewModel)
    func showLoadingIndicator(parameter: Bool)
    func showNetworkError(message: String)
}
final class MovieQuizViewController: UIViewController, PresenterUseViewController {
    //Any attempt to subclass a final class is reported as a compile-time error.
    //! Discuss
    // 1) Why we write `UIColor.ypGreen.cgColor` instead of `UIColor.ypGreen`?
    // 3) Что значит "final class"?
    //4 Can I leave some commands, needed only for iOS-developer? (like `printSandBox()`)
    //! End of `Discuss`
    private var presenter: MovieQuizPresenter!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private var alertView: AlertPresenterProtocol?
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var titleNoButton: UIButton!
    @IBOutlet private weak var titleYesButton: UIButton!
    @IBOutlet weak var downloadMoviesIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        infoLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.numberOfLines = 2
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        titleNoButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        titleYesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
//вывод первого вопроса на экран в рамках паттерна "Делегат" в случае локальных данных (
       // questionFactory?.requestNextQuestion()
// Only for finding the path to sandBox: statistics?.printSandBox()
    }
    /// Вывод на экран вопроса (принимает  ViewModel вопроса)
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.masksToBounds = true // даём разрешение на рамку
        imageView.layer.borderWidth = 1  // толщина рамки
        imageView.layer.borderColor = UIColor.ypBlack.cgColor // красим рамку
        imageView.layer.cornerRadius = 20 // радиус скругления углов
        textLabel.text = step.question
        // make the buttons ready for user's tap
        titleNoButton.isEnabled = true
        titleYesButton.isEnabled = true
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        presenter.yesButtonClicked()
    }
    func frameHighlight(_ firstColor: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = firstColor ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    /// Метод для показа результатов раунда квиза
    func show(quiz result: QuizResultsViewModel) {
        //0 convert QuizResultsViewModel object to AlertModel object
        var alertModel = AlertViewModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        )
        alertModel.handler = { [weak self] _ in
            guard let self = self else { print("Can't assign proper handler for alertModel"); return}
            // код, который сбрасывает игру и показывает первый вопрос
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.presenter.questionFactory?.requestNextQuestion()
        }
        //1 init alert object
        alertView = AlertPresenter(
                                  delegate: self,
                                  alertSome: alertModel
                                  )
        //2) Показть алерт при помощи паттерна "Делегат"
        alertView?.show()
    }
    func showLoadingIndicator(parameter: Bool) {
        if  parameter == false {
            downloadMoviesIndicator.isHidden = parameter // говорим, что индикатор загрузки не скрыт
            downloadMoviesIndicator.startAnimating() }
        else {
            downloadMoviesIndicator.isHidden = parameter
        }
    }
    func showNetworkError(message: String) {
        showLoadingIndicator(parameter: true)
    
        var alertModel = AlertViewModel(
            title: "Что-то пошло не так",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз"
        )
        alertModel.handler = { _ in }
        alertView = AlertPresenter(
                                  delegate: self,
                                  alertSome: alertModel
                                  )
        alertView?.show()
    }
}
extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController, completion: (() -> Void)?){
        //Показать алерт
        present(alert, animated: true, completion: completion)
    }
}
