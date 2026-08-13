import UIKit

class KeyboardViewController: UIInputViewController {

    private var isGenshinMode = false
    private var buffer = ""
    private var composerLabel: UILabel!
    private var modeButton: UIButton!

    private var isPad: Bool {
        traitCollection.userInterfaceIdiom == .pad
    }

    private var keyHeight: CGFloat { isPad ? 62 : 44 }
    private var spacing: CGFloat { isPad ? 10 : 6 }
    private var rowSpacing: CGFloat { isPad ? 7 : 4 }
    private var margin: CGFloat { isPad ? 12 : 8 }
    private var cornerRadius: CGFloat { isPad ? 10 : 6 }
    private var keyFontSize: CGFloat { isPad ? 26 : 18 }
    private var composerHeight: CGFloat { isPad ? 110 : 72 }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    private func setupKeyboard() {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = spacing
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
        ])

        container.addArrangedSubview(makeTopBar())
        container.addArrangedSubview(makeComposer())
        container.addArrangedSubview(makeKeyboardRows())
        container.addArrangedSubview(makeBottomBar())
    }

    private func makeTopBar() -> UIStackView {
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.spacing = spacing

        modeButton = UIButton(type: .system)
        modeButton.setTitle("Genshin Mode: OFF", for: .normal)
        modeButton.titleLabel?.font = .systemFont(ofSize: isPad ? 18 : 13, weight: .bold)
        modeButton.backgroundColor = .lightGray
        modeButton.layer.cornerRadius = cornerRadius
        modeButton.heightAnchor.constraint(equalToConstant: isPad ? 48 : 36).isActive = true
        modeButton.addTarget(self, action: #selector(toggleMode), for: .touchUpInside)
        modeButton.setContentHuggingPriority(.required, for: .horizontal)

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("🌐", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: isPad ? 28 : 20)
        nextButton.backgroundColor = .lightGray
        nextButton.layer.cornerRadius = cornerRadius
        nextButton.widthAnchor.constraint(equalToConstant: isPad ? 60 : 44).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: isPad ? 48 : 36).isActive = true
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)

        bar.addArrangedSubview(modeButton)
        bar.addArrangedSubview(UIView())
        bar.addArrangedSubview(nextButton)
        return bar
    }

    private func makeComposer() -> UIView {
        let wrap = UIView()
        composerLabel = UILabel()
        composerLabel.numberOfLines = 3
        composerLabel.font = .systemFont(ofSize: isPad ? 24 : 17)
        composerLabel.backgroundColor = .white
        composerLabel.layer.cornerRadius = cornerRadius
        composerLabel.layer.masksToBounds = true
        composerLabel.text = ""
        composerLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(composerLabel)
        NSLayoutConstraint.activate([
            composerLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor),
            composerLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor),
            composerLabel.topAnchor.constraint(equalTo: wrap.topAnchor),
            composerLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
            composerLabel.heightAnchor.constraint(equalToConstant: composerHeight),
        ])
        return wrap
    }

    private func makeKeyboardRows() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = spacing

        let rows: [[String]] = [
            ["ض", "ص", "ث", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج", "د"],
            ["ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك", "ط"],
            ["ئ", "ء", "ؤ", "ر", "لا", "ى", "ة", "و", "ز", "ظ"],
            ["؟", "!", ",", ".", "—", "،"],
        ]

        for row in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = rowSpacing
            for key in row {
                let button = makeKey(title: key)
                rowStack.addArrangedSubview(button)
            }
            stack.addArrangedSubview(rowStack)
        }
        return stack
    }

    private func makeBottomBar() -> UIStackView {
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.spacing = rowSpacing

        let backspace = makeKey(title: "⌫", action: #selector(handleBackspace))
        backspace.widthAnchor.constraint(equalToConstant: isPad ? 90 : 60).isActive = true

        let space = makeKey(title: "مسافة", action: #selector(handleSpace))

        let clear = makeKey(title: "C", action: #selector(handleClear))
        clear.widthAnchor.constraint(equalToConstant: isPad ? 70 : 48).isActive = true

        let send = makeKey(title: "إرسال", action: #selector(handleSend))
        send.backgroundColor = UIColor.systemBlue
        send.setTitleColor(.white, for: .normal)
        send.widthAnchor.constraint(equalToConstant: isPad ? 110 : 70).isActive = true

        bar.addArrangedSubview(backspace)
        bar.addArrangedSubview(space)
        bar.addArrangedSubview(clear)
        bar.addArrangedSubview(send)
        return bar
    }

    private func makeKey(title: String, action: Selector? = #selector(handleKey)) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: keyFontSize, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.heightAnchor.constraint(equalToConstant: keyHeight).isActive = true
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        return button
    }

    @objc private func handleKey(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        buffer += title
        refreshComposer()
    }

    @objc private func handleSpace() {
        buffer += " "
        refreshComposer()
    }

    @objc private func handleBackspace() {
        if !buffer.isEmpty {
            buffer.removeLast()
            refreshComposer()
        }
    }

    @objc private func handleClear() {
        buffer = ""
        refreshComposer()
    }

    @objc private func handleSend() {
        guard !buffer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let finalText = isGenshinMode ? ArabicShaping.processPlain(buffer) : buffer
        textDocumentProxy.insertText(finalText)
        buffer = ""
        refreshComposer()
    }

    @objc private func toggleMode() {
        isGenshinMode.toggle()
        if isGenshinMode {
            modeButton.setTitle("Genshin Mode: ON", for: .normal)
            modeButton.backgroundColor = .systemGreen
            modeButton.setTitleColor(.white, for: .normal)
        } else {
            modeButton.setTitle("Genshin Mode: OFF", for: .normal)
            modeButton.backgroundColor = .lightGray
            modeButton.setTitleColor(.systemBlue, for: .normal)
        }
    }

    @objc private func handleNext() {
        advanceToNextInputMode()
    }

    private func refreshComposer() {
        composerLabel.text = buffer
    }
}
