import UIKit

final class ConverterViewController: UIViewController, UITextViewDelegate {

    private let inputText = UITextView()
    private let modeControl = UISegmentedControl(items: ["عادي", "Genshin", "عكس"])
    private let preview = UILabel()
    private let copyButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "المحول"
        setupUI()
        refreshPreview()
    }

    private func setupUI() {
        inputText.delegate = self
        inputText.font = .systemFont(ofSize: 24)
        inputText.layer.borderWidth = 1
        inputText.layer.borderColor = UIColor.separator.cgColor
        inputText.layer.cornerRadius = 10
        inputText.textAlignment = .right
        inputText.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        inputText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        modeControl.selectedSegmentIndex = 1
        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)

        preview.numberOfLines = 0
        preview.font = .systemFont(ofSize: 24)
        preview.textAlignment = .right
        preview.textColor = .label

        let hint = UILabel()
        hint.text = "بعد النسخ: افتح شات قنشن، اضغط مطولاً على حقل الكتابة ثم اختر لصق."
        hint.font = .systemFont(ofSize: 14)
        hint.textColor = .secondaryLabel
        hint.numberOfLines = 0
        hint.textAlignment = .center

        copyButton.setTitle("تحويل ونسخ", for: .normal)
        copyButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        copyButton.backgroundColor = .systemGreen
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.layer.cornerRadius = 12
        copyButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [inputText, modeControl, preview, copyButton, hint])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func processedText() -> String {
        switch modeControl.selectedSegmentIndex {
        case 1: return ArabicShaping.process(inputText.text)
        case 2: return ArabicShaping.processPlain(inputText.text)
        default: return inputText.text
        }
    }

    @objc private func modeChanged() {
        refreshPreview()
    }

    @objc private func copyTapped() {
        let text = processedText()
        UIPasteboard.general.string = text
        copyButton.setTitle("تم النسخ", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.copyButton.setTitle("تحويل ونسخ", for: .normal)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        refreshPreview()
    }

    private func refreshPreview() {
        preview.text = processedText()
    }
}
