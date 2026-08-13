import sys
import pyperclip
import arabic_reshaper
from bidi.algorithm import get_display

def fix_arabic_text():
    text = pyperclip.paste()
    if text and text.strip():
        reshaped = arabic_reshaper.reshape(text)
        final_text = get_display(reshaped)
        pyperclip.copy(final_text)

if __name__ == "__main__":
    fix_arabic_text()