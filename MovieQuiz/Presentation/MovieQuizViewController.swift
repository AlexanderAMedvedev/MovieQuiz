import UIKit

final class MovieQuizViewController: UIViewController {
    //! Discuss
    // 1) Why we write `UIColor.ypGreen.cgColor` instead of `UIColor.ypGreen`?
    // 2) Почему `showAnswerResult(isCorrect: Bool)` это метод-приложение?
    //! End of `Discuss`
    // MARK: - Lifecycle
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса
    private var correctAnswers = 0 // переменная с количеством правильных ответов
    private struct QuizQuestion {
      let image: String // строка с названием фильма, совпадает с названием картинки афиши фильма в Assets
      let text: String // строка с вопросом о рейтинге фильма
      let correctAnswer: Bool // булевое значение (true, false), правильный ответ на вопрос
    }
    private struct QuizStepViewModel { // вью модель для состояния "Вопрос показан"
      let image: UIImage   // картинка с афишей фильма с типом UIImage
      let question: String // вопрос о рейтинге квиза
      let questionNumber: String // строка с порядковым номером этого вопроса (ex. "1/10")
    }
    // для состояния "Результат квиза"
    private struct QuizResultsViewModel {
      // строка с заголовком алерта
      let title: String
      // строка с текстом о количестве набранных очков
      let text: String
      // текст для кнопки алерта
      let buttonText: String
    }
    private let questions: [QuizQuestion] = [
     QuizQuestion(
      image: "The Godfather",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9,2
      correctAnswer: true),
     QuizQuestion(
      image: "The Dark Knight",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9
      correctAnswer: true),
     QuizQuestion(
      image: "Kill Bill",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8,1
      correctAnswer: true),
     QuizQuestion(
      image: "The Avengers",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8
      correctAnswer: true),
    QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 8
     correctAnswer: true),
    QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 6,6
     correctAnswer: true),
    QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,8
     correctAnswer: false),
    QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 4,3
     correctAnswer: false),
    QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,1
     correctAnswer: false),
    QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,8
     correctAnswer: false)
]// конец массива вопросов
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var titleNoButton: UIButton!
    @IBOutlet weak var titleYesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        titleNoButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        titleYesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    /// Конвертация мокового вопроса во ViewModel экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
              image: UIImage(named: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex+1)/\(questions.count)")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let userAnswer: Bool = false
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let userAnswer: Bool = true
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    private func showNextQuestionOrResults() {
        //переход в один из сценариев
        if currentQuestionIndex == questions.count - 1 {
            // идём в состояние "Результат квиза"
            // Создание ViewModel типа "QuizResultsViewModel" для состояния "Результат квиза"
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                    buttonText: "Сыграть ещё раз"
                )
              show(quiz: result)
        } else {
            // идём в состояние "Следующий вопрос показан"
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
    }
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
    // Создание и показ алерта после конца раунда
        // 1) создаём объекты всплывающего окна - алерта
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплывающем окне
            preferredStyle: .alert)       // preferredStyle может быть .alert или .actionSheet
        // 2) создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            // код, который сбрасывает игру и показывает первый вопрос
            self.correctAnswers =  0
            self.currentQuestionIndex = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
        }
        // 3) добавляем в алерт кнопку
        alert.addAction(action)
        // 4) показываем алерт
        self.present(alert, animated: true, completion: nil)
    }
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
