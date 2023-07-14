# Pine UI

[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)]()
[![Phoenix Framework](https://img.shields.io/badge/Phoenix_20Framework-38B2AC?style=for-the-badge&logo=elixir&logoColor=white)]()
[![AlpineJS](https://img.shields.io/badge/AlpineJS-38B2AC?style=for-the-badge&logo=alpinejs&logoColor=white)]()

[Pine UI](https://devdojo.com/pines)

An Alpine & Tailwind UI Library

A **comprehensive** and **user-friendly boilerplate**, designed to expedite the development process of **MERN Stack Dashboards**, providing developers with an extensive range of **components** and **features**.

## Installation

Add Pine UI to your `mix.exs`:

```elixir
def deps do
  [
    {:pine_ui, "~> 0.1.0"}
  ]
end
```

## Usage

The components are provided by the `Pine UI` module. Each element is a Phoenix Component you can use in your HEEx templates.

```eex
 <PineUi.typing_effect
  text_list={Poison.encode!(["I'm here james", "All mightily push"])}
  class="item-center justify-center"
  text_class="text-2xl font-black leading-tight"
/>
```

After that, run `mix deps.get`.

# Features
This innovative project showcases a comprehensive range of powerful and cutting-edge features, seamlessly integrating the following capabilities:

 - Responsive Layout
 - Authentication w/ Forgot Password Recovery
 - Student Management (CRUD)
 - Custom Components based on TailwindCSS
 - Developer experience improved with ESLint, Prettier, and Husky

# Frequently Asked Questions (FAQs)
<details>
  <summary>Why Pine UI?</summary>
  
 It leverages the strength of Vite and Express.js, along with TypeScript, to build an impressive MERN Stack project. It encompasses essential features such as seamless authentication, forgot password retrieval, and CRUD functionality. The project also enhances the developer experience by incorporating ESLint, Prettier, and Husky, ensuring code quality and consistency. Additionally, it boasts customized components based on Tailwind CSS and a responsive layout for a visually appealing and user-friendly interface.
</details>

<details>
  <summary>Why you build it?</summary>
   
   I created this project not only for personal use but also to benefit co-developers by significantly speeding up the development process. By utilizing the power of Vite and Express.js, along with TypeScript, ESLint, Prettier, and Husky, the project aims to enhance collaboration and streamline development, ultimately saving time and effort for everyone involved.
</details>

## Roadmap
An overview of our development plans and upcoming features.

 - [X] Component libraries (Will add more components and variants)
   - [X] Alert
   - [X] Avatar
   - [X] Badge
   - [X] Buttons
   - [X] Cards
   - [X] Select
   - [X] Text Input   