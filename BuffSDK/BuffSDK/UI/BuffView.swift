//
//  BuffView.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 10/06/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import UIKit

public class BuffView: UIViewNibLoadable {
    @IBOutlet var questionaryContainer: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var circularTimer: CircularTimer!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionView: UIView!
    @IBOutlet var buffQuestionnaireStack: UIStackView!
    @IBOutlet var questionsStack: UIStackView!
    @IBOutlet var answersStack: UIStackView!
    private let xShift: CGFloat = 400
    private let twoSeconds = DispatchTimeInterval.seconds(2)

    var viewModel: BuffViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
                self.showBuff()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        setViewToInitialPosition()
    }

    private func showBuff() {
        showBuffWithAnimation()
    }

    private func updateUI() {
        guard let viewModel = viewModel else {
            return
        }
        setViewToInitialPosition()
        configAuthorStack(viewModel: viewModel)
        configQuestions(viewModel: viewModel)
        fillStackWith(answers: viewModel.answers)
        hideBuffAfterTimeOver(time: viewModel.timeToShow)
    }

    private func setViewToInitialPosition() {
        circularTimer.isHidden = false
        questionaryContainer.frame.origin.x = -xShift
    }

    private func hideBuffAfterTimeOver(time: TimeInterval) {
        perform(#selector(hideBuffWithAnimation), with: nil, afterDelay: time)
    }

    private func fillStackWith(answers: [String]) {
        answersStack.removeAllArrangedSubviews()

        var tagIndex = 0

        for answer in answers {
            let answerLabel = contentLabel(text: answer)
            let button = contentButton(tag: tagIndex)
            tagIndex += 1
            let anwerRowStack = contentStackView()

            anwerRowStack.addArrangedSubview(button)
            anwerRowStack.addArrangedSubview(answerLabel)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTapped(_:)))
            anwerRowStack.addGestureRecognizer(tapGestureRecognizer)
            answersStack.addArrangedSubview(anwerRowStack)
        }
    }

    private func contentLabel(text: String) -> PaddingLabel {
        let label = PaddingLabel()
        label.text = text
        label.font = UIFont(name: "Gibson-SemiBold", size: 12)!
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1

        return label
    }

    private func contentButton(tag: Int) -> HighlightedButton {
        let answerButton = HighlightedButton()
        let cornerRadius: CGFloat = 10
        answerButton.tag = tag
        answerButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Generic.Answer_ico",
                            in: Bundle(for: type(of: self)),
                            compatibleWith: nil)
        answerButton.setImage(image, for: .normal)
        answerButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        answerButton.setContentHuggingPriority(.required, for: .horizontal)
        answerButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        answerButton.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)
        answerButton.layer.cornerRadius = cornerRadius
        answerButton.layer.masksToBounds = true

        return answerButton
    }

    private func contentStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        let backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1)
        stackView.addBackground(color: backgroundColor)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)

        return stackView
    }

    @objc private func buttonTapped(_: UIButton) {
        gettedAnswer()
    }

    @objc private func gestureTapped(_ sender: UIGestureRecognizer) {
        if let stackView = sender.view as? UIStackView, let view = stackView.subviews.first {
            view.backgroundColor = .green
        }

        gettedAnswer()
    }

    private func gettedAnswer() {
        disableQuestionaryButtons()
        stopAndHideCircleTimer()
    }

    private func stopAndHideCircleTimer() {
        circularTimer.stopTimer()

        UIView.animate(withDuration: 0.45, animations: {
            self.circularTimer.isHidden = true
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + twoSeconds) {
            self.hideBuffWithAnimation()
        }
    }

    private func disableQuestionaryButtons() {
        for case let stack as UIStackView in answersStack.arrangedSubviews {
            for case let button as UIButton in stack.arrangedSubviews {
                button.isEnabled = false
            }
        }
    }

    private func configQuestions(viewModel: BuffViewModel) {
        circularTimer.startTimer(viewModel.timeToShow)
        questionView.layer.cornerRadius = 10
        questionView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.16).cgColor
        questionView.layer.shadowOpacity = 1
        questionView.layer.shadowOffset = .zero
        questionView.layer.shadowRadius = 10

        questionLabel.font = UIFont(name: "Gibson-SemiBold", size: 17)!
        questionLabel.text = viewModel.question
    }

    private func configAuthorStack(viewModel: BuffViewModel) {
        authorImage.layer.masksToBounds = true
        authorImage.layer.borderWidth = 1.0
        authorImage.layer.borderColor = UIColor.white.cgColor
        authorImage.layer.cornerRadius = authorImage.bounds.width / 2

        closeButton.setContentHuggingPriority(.required, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        authorLabel.font = UIFont(name: "Gibson-SemiBold", size: 12)!
        authorLabel.text = viewModel.author

        viewModel.getAuthorIcon { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.authorImage.image = image
                }
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    func showBuffWithAnimation() {
        animateContainer(with: xShift)
    }

    @objc func hideBuffWithAnimation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        animateContainer(with: -xShift)
    }

    func animateContainer(with shift: CGFloat) {
        let initialXpos = questionaryContainer.layer.position.x
        let finalXpos = questionaryContainer.layer.position.x + shift
        questionaryContainer.layer.position.x = finalXpos
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = initialXpos
        animation.toValue = finalXpos
        animation.duration = 0.45
        questionaryContainer.layer.add(animation, forKey: "basic")
    }

    @IBAction func closeButtonTapped(_: Any) {
        disableQuestionaryButtons()

        circularTimer.stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + twoSeconds) {
            self.hideBuffWithAnimation()
        }
    }
}
