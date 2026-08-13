import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = InstructionsViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

final class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let title = UILabel()
        title.text = "Genshin Keyboard"
        title.font = .systemFont(ofSize: 26, weight: .bold)
        title.textAlignment = .center

        let steps = UILabel()
        steps.numberOfLines = 0
        steps.font = .systemFont(ofSize: 16)
        steps.textAlignment = .center
        steps.text = """
        لتفعيل الكيبورد:
        1. افتح الإعدادات ← عام ← لوحة المفاتيح
        2. اضغط «لوحات المفاتيح» ثم «إضافة لوحة مفاتيح جديدة»
        3. اختر «Genshin Keyboard»
        4. ارجع للكيبورد واضغط 🌐 للتبديل إليها

        داخل الكيبورد:
        • فعّل «Genshin Mode» ليتم تشكيل العربية وربط الحروف
        • اكتب ثم اضغط «إرسال» لوضع النص في الحقل
        """

        let stack = UIStackView(arrangedSubviews: [title, steps])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
        ])
    }
}
