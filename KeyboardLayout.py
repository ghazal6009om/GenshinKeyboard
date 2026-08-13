import tkinter as tk
from GenshinCore import process_genshin_text

class FullIOSKeyboard:
    def __init__(self, root):
        self.root = root
        self.root.title("Genshin iOS Keyboard Layout")
        self.root.geometry("600x420")
        self.root.configure(bg="#d1d4d9")

        self.genshin_active = False

        # شاشة عرض النص
        self.display_box = tk.Text(root, height=3, width=60, font=("Arial", 14), bg="#ffffff", fg="#000000")
        self.display_box.pack(pady=10)

        # شريط التحكم العلوي (زر غينشن وزر الإرسال)
        top_bar = tk.Frame(root, bg="#d1d4d9")
        top_bar.pack(pady=5)

        self.toggle_btn = tk.Button(
            top_bar, text="Genshin Mode: OFF", font=("Arial", 11, "bold"), 
            bg="#e0e0e0", fg="#333333", padx=10, pady=5, command=self.toggle_genshin_mode
        )
        self.toggle_btn.pack(side=tk.LEFT, padx=5)

        self.enter_btn = tk.Button(
            top_bar, text="إرسال (Enter)", font=("Arial", 11, "bold"), 
            bg="#007aff", fg="white", padx=10, pady=5, command=self.send_message
        )
        self.enter_btn.pack(side=tk.LEFT, padx=5)

        # إطار لوحة المفاتيح
        keyboard_frame = tk.Frame(root, bg="#d1d4d9")
        keyboard_frame.pack(pady=10)

        # صفوف الحروف العربية والرموز
        rows = [
            ["ض", "ص", "ث", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج", "د"],
            ["ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك", "ط"],
            ["ئ", "ء", "ؤ", "ر", "لا", "ى", "ة", "و", "ز", "ظ"],
            [",", "؟", "!", "مسافة", ".", "—"] # صف الرموز والمسافة
        ]

        for r_index, row in enumerate(rows):
            row_frame = tk.Frame(keyboard_frame, bg="#d1d4d9")
            row_frame.pack(pady=3)
            for key in row:
                w_val = 12 if key == "مسافة" else 4
                btn = tk.Button(row_frame, text=key, font=("Arial", 12), width=w_val, height=1, bg="#ffffff", fg="#000000")
                btn.pack(side=tk.LEFT, padx=2)

    def toggle_genshin_mode(self):
        self.genshin_active = not self.genshin_active
        if self.genshin_active:
            self.toggle_btn.config(text="Genshin Mode: ON", bg="#34c759", fg="white")
        else:
            self.toggle_btn.config(text="Genshin Mode: OFF", bg="#e0e0e0", fg="#333333")

    def send_message(self):
        raw_text = self.display_box.get("1.0", tk.END).strip()
        processed = process_genshin_text(raw_text, self.genshin_active)
        self.display_box.delete("1.0", tk.END)
        self.display_box.insert("1.0", processed)
        print("Output:", processed)

if __name__ == "__main__":
    root = tk.Tk()
    app = FullIOSKeyboard(root)
    root.mainloop()