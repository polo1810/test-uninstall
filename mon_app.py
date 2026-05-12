import tkinter as tk
from tkinter import messagebox


def on_click():
    messagebox.showinfo("Mon App", "Bonjour depuis mon_app.exe !")


root = tk.Tk()
root.title("Mon App")
root.geometry("320x160")

label = tk.Label(root, text="Application de test", font=("Segoe UI", 12))
label.pack(pady=20)

button = tk.Button(root, text="Cliquer ici", command=on_click)
button.pack(pady=10)

root.mainloop()
