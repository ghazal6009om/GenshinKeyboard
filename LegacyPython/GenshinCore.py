import sys
import pyperclip
import arabic_reshaper
from bidi.algorithm import get_display

def process_genshin_text(text, is_enabled):
    """
    إذا كان الوضع مفعلاً، يقوم بعكس وتعديل الحروف العربية لتناسب شات اللعبة.
    إذا كان معطلاً، يعيد النص كما هو بدون أي تغيير.
    """
    if is_enabled and text and text.strip():
        reshaped = arabic_reshaper.reshape(text)
        return get_display(reshaped)
    return text

if __name__ == "__main__":
    # مثال اختباري للتأكد من عمل السكريبت سحابياً ومحلياً
    sample_text = "سلام"
    print("Original:", sample_text)
    print("Processed (Genshin Mode):", process_genshin_text(sample_text, True))