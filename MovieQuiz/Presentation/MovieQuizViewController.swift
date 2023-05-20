import UIKit

final class MovieQuizViewController: UIViewController {
    //Any attempt to subclass a final class is reported as a compile-time error.
    //! Discuss
    // 1) Why we write `UIColor.ypGreen.cgColor` instead of `UIColor.ypGreen`?
    // 2) Почему `showAnswerResult(isCorrect: Bool)` это метод-приложение?
    // 3) Что значит "final class"?
    //4 Can I leave some commands, needed only for iOS-developer? (like `printSandBox()`)
    //! End of `Discuss`
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса
    private var correctAnswers = 0 // переменная с количеством правильных ответов
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertView: AlertPresenterProtocol?
    private var statistics: StatisticsService?
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var titleNoButton: UIButton!
    @IBOutlet private weak var titleYesButton: UIButton!
    @IBOutlet private weak var downloadMoviesIndicator: UIActivityIndicatorView!
    /// Конвертация мокового вопроса во ViewModel экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
              image: UIImage(data: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return questionStep
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        showLoadingIndicator()
        questionFactory?.loadData()
        infoLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.numberOfLines = 2
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        titleNoButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        titleYesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        statistics = StatisticsServiceImplementation()
//вывод первого вопроса на экран в рамках паттерна "Делегат" в случае локальных данных
       // questionFactory?.requestNextQuestion()
// Only for finding the path to sandBox: statistics?.printSandBox()
    }
    /// Вывод на экран вопроса (принимает  ViewModel вопроса)
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.masksToBounds = true // даём разрешение на рамку
        imageView.layer.borderWidth = 1  // толщина рамки
        imageView.layer.borderColor = UIColor.ypBlack.cgColor // красим рамку
        imageView.layer.cornerRadius = 20 // радиус скругления углов
        textLabel.text = step.question
    }
    private func showAnswerResult(isCorrect: Bool) {
    // метод красит рамку
        imageView.layer.borderWidth = 8  // толщина рамки
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        } // красим рамку
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        let userAnswer: Bool = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        sender.isEnabled = true
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        let userAnswer: Bool = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        sender.isEnabled = true
    }
    private func showNextQuestionOrResults() {
        //переход в один из сценариев
        if currentQuestionIndex == questionsAmount - 1 {
// состояние "Результат квиза"
//1 Предварительная подготовка параметров модели "QuizResultsViewModel"
            //распаковка опционала, чтобы далее код был проще
            guard let statistics = statistics else { print("statistics object error"); return}
         // 1 рекорд
          // 1 сохранение лучшей игры
              // 1 запись текущей игры
            let currentGame = GameRecord(correct: correctAnswers, total: questionsAmount, date: Date())
              // 2 запись лучшей игры на устройство
            statistics.setBestGame(currentGame)
          // 2 сам рекорд - запись о лучшей игре
            let record: String = """
                                 \(statistics.bestGame.correct)/\(statistics.bestGame.total) \
                                 (\(statistics.bestGame.date.dateTimeString))
                                 """
        //2 средняя точность
            //1 учесть в статистике по всем играм кол-во всех ответов, кол-во только правильных ответов, которые даны в последней игре
            statistics.store(totalCurrent: questionsAmount, correctCurrent: correctAnswers)
            //2 получить значение в виде, требуемом макетом
            let averageAccuracy = String(format: "%.2f", statistics.totalAccuracy)
//2 Создание объекта "QuizResultsViewModel"
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: """
                          Ваш результат: \(correctAnswers)/\(questionsAmount)
                          Количество сыгранных квизов: \(statistics.gamesCount)
                          Рекорд: \(record)
                          Средняя точность: \(averageAccuracy)%
                          """,
                          buttonText: "Сыграть ещё раз"
                )
//3 Показ объекта "QuizResultsViewModel" на экране
                show(quiz: result)
        } else {
            //состояние "Следующий вопрос показан"
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    /// Метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        //0 convert QuizResultsViewModel object to AlertModel object
        var alertModel = AlertViewModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        )
        alertModel.handler = { [weak self] _ in
            guard let self = self else { print("Can't assign proper handler for alertModel"); return}
            // код, который сбрасывает игру и показывает первый вопрос
            self.currentQuestionIndex = 0
            self.questionFactory?.requestNextQuestion()
            self.correctAnswers =  0
        }
        //1 init alert object
        alertView = AlertPresenter(
                                  delegate: self,
                                  alertSome: alertModel
                                  )
        //2) Показть алерт при помощи паттерна "Делегат"
        alertView?.show()
    }
    private func showLoadingIndicator() {
        downloadMoviesIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        downloadMoviesIndicator.startAnimating() // включаем анимацию
    }
    private func showNetworkError(message: String) {
        downloadMoviesIndicator.isHidden = true
    
        var alertModel = AlertViewModel(
            title: "Что-то пошло не так",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз"
        )
        alertModel.handler = { [weak self] _ in
            guard let self = self else { print("Can't assign proper handler for alertModel"); return}
        }
        alertView = AlertPresenter(
                                  delegate: self,
                                  alertSome: alertModel
                                  )
        alertView?.show()
    }
}
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        downloadMoviesIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        //localizedDescription - Retrieve(Извлекать) the localized description for this error.
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
}
extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController, completion: (() -> Void)?){
        //Показать алерт
        present(alert, animated: true, completion: completion)
    }
}
