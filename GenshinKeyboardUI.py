import tkinter as tk
from GenshinCore import process_genshin_text

class GenshinKeyboardApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Genshin Arabic Keyboard Simulator")
        self.root.geometry("400x300")
        
        # حالة الزر (معطل افتراضياً)
        self.genshin_mode_active = False

        # عنوان أو حالة الزر
        self.status_label = tk.Label(root, text="Genshin Mode: OFF", font=("Arial", 12), fg="red")
        self.status_label.pack(pady=10)

        # زر التفعيل (Toggle Button)
        self.toggle_btn = tk.Button(root, text="تفعيل وضع غينشن (Genshin Mode)", font=("Arial", 11), bg="#ddd", command=self.toggle_genshin_mode)
        self.toggle_btn.pack(pady=5)

        # حقل النص لتجربة الكتابة
        self.text_box = tk.Text(root, height=5, width=40, font=("Arial", 14))
        self.text_box.pack(pady=10)

        # زر الإرسال (Enter Simulator)
        self.send_btn = tk.Button(root, text="إرسال (Enter)", font=("Arial", 11, "bold"), bg="#4CAF50", fg="white", command=self.send_text)
        self.send_btn.pack(pady=5)

    def toggle_genshin_mode(self):
        self.genshin_mode_active = not self.genshin_mode_active
        if self.genshin_mode_active:
            self.status_label.config(text="Genshin Mode: ON (مفعل)", fg="green")
            self.toggle_btn.config(bg="#a8f0a8")
        else:
            self.status_label.config(text="Genshin Mode: OFF (معطل)", fg="red")
            self.toggle_btn.config(bg="#ddd")

    def send_text(self):
        # قراءة النص المكتوب
        raw_text = self.text_box.get("1.0", tk.END).strip()
        
        # معالجة النص بناءً على حالة الزر (إذا كان مفعل يعكسه، إذا معطل يتركه كما هو)
        processed_text = process_genshin_text(raw_text, self.genshin_mode_active)
        
        # مسح الحقل وعرض النص المعالج
        self.text_box.delete("1.0", tk.END)
        self.text_box.insert("1.0", processed_text)
        print("Sent to Game:", processed_text)

if __name__ == "__main__":
    root = tk.Tk()
    app = GenshinKeyboardApp(root)
    root.mainloop()