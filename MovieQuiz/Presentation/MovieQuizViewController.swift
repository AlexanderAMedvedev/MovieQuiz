import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //! Discuss
    // 1) Why we write `UIColor.ypGreen.cgColor` instead of `UIColor.ypGreen`?
    // 2) Почему `showAnswerResult(isCorrect: Bool)` это метод-приложение?
    // 3) Что значит "final class"?
    //! End of `Discuss`
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса
    private var correctAnswers = 0 // переменная с количеством правильных ответов
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var titleNoButton: UIButton!
    @IBOutlet weak var titleYesButton: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        infoLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        titleNoButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        titleYesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        /// вывод первого вопроса на экран в рамках паттерна "Делегат"
        questionFactory?.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    /// Конвертация мокового вопроса во ViewModel экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
              image: UIImage(named: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return questionStep
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
        let userAnswer: Bool = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // insert isEnabled?
        let userAnswer: Bool = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    private func showNextQuestionOrResults() {
        //переход в один из сценариев
        if currentQuestionIndex == questionsAmount - 1 {
            // идём в состояние "Результат квиза"
            // Создание ViewModel типа "QuizResultsViewModel" для состояния "Результат квиза"
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                    buttonText: "Сыграть ещё раз"
                )
              show(quiz: result)
        } else {
            // идём в состояние "Следующий вопрос показан"
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    /// Метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
    // Создание и показ алерта после конца раунда
        // 1) создаём объекты всплывающего окна - алерта
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплывающем окне
            preferredStyle: .alert)       // preferredStyle может быть .alert или .actionSheet
        // 2) создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            // распаковка опционала
            guard let self = self else { return }
            // код, который сбрасывает игру и показывает первый вопрос
            self.correctAnswers =  0
            self.currentQuestionIndex = 0
            self.questionFactory?.requestNextQuestion()
        }
        // 3) добавляем в алерт кнопку
        alert.addAction(action)
        // 4) показываем алерт
        self.present(alert, animated: true, completion: nil)
    }
}
