# 💰 flutter-expense-tracker

A **personal finance tracker** app built with **Flutter** that helps users log daily expenses, categorize spending, set budgets, and visualize spending habits using interactive charts. Data is stored **locally using Hive**, ensuring offline access and fast performance.

---

## 📱 Demo

![App Demo](assets/demo.gif)

---

## 📜 Features

- ✅ Add, edit, and delete expenses
- 📂 Categorize spending (e.g., Food, Travel, Bills)
- 📊 Visual charts using `fl_chart`
- 💸 Monthly budget setting
- 📅 Filter expenses by date or category
- 🌗 Light/Dark mode
- 🗃️ Local data storage using Hive (offline support)

---

## 🧠 Project Structure

```bash
lib/
├── core/             # Constants and utilities
├── models/           # Hive data models
├── screens/          # App screens
├── services/         # Business logic (Providers, DB access)
├── widgets/          # Reusable components
└── main.dart         # App entry point
