defmodule PineUiPhoenix.MixProject do
  use Mix.Project

  @version "0.1.3"
  @source_url "https://github.com/jamesnjovu/pine_ui_phoenix"

  def project do
    [
      app: :pine_ui_phoenix,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      name: "Pine UI",
      source_url: @source_url,
      homepage_url: @source_url,
      description: "Phoenix components for Pine UI - AlpineJS and TailwindCSS based UI library",
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PineUiPhoenix.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.18.0", optional: true},
      {:poison, "~> 3.1.0", optional: true},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:jason, "~> 1.2", optional: true}
    ]
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "pine_ui_phoenix",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md"
      },
      maintainers: ["James Njovu"]
    ]
  end

  defp docs do
    [
      main: "PineUiPhoenix",
#      logo: "assets/logo.png",
      extras: [
        "README.md": [title: "Overview"],
        "LICENSE": [title: "License"],
      ],
      groups_for_modules: [
        "Text Components": [
          PineUiPhoenix.Text
        ],
        "Interactive Components": [
          PineUiPhoenix.Accordion,
          PineUiPhoenix.Button,
          PineUiPhoenix.Dropdown,
          PineUiPhoenix.Modal,
          PineUiPhoenix.Pagination,
          PineUiPhoenix.Progress,
          PineUiPhoenix.Switch,
          PineUiPhoenix.Tabs,
          PineUiPhoenix.Toast,
          PineUiPhoenix.Tooltip
        ],
        "Layout Components": [
          PineUiPhoenix.Card,
          PineUiPhoenix.DataTable,
          PineUiPhoenix.Gallery
        ],
        "Form Components": [
          PineUiPhoenix.DatePicker,
          PineUiPhoenix.FileUploader,
          PineUiPhoenix.TextInput,
          PineUiPhoenix.Select
        ],
        "Status Components": [
          PineUiPhoenix.Badge
        ]
      ],
      groups_for_functions: [

        "Text & Animation": &(&1[:type] == :text),
        "Buttons": &(&1[:type] == :button),
        "Cards": &(&1[:type] == :card),
        "Form Elements": &(&1[:type] == :form),
        "Status Elements": &(&1[:type] == :status),
        "Accordion Components": &(&1[:type] == :accordion),
        "Modal Components": &(&1[:type] == :modal),
        "Dropdown Components": &(&1[:type] == :dropdown),
        "Tab Components": &(&1[:type] == :tabs),
        "Switch Components": &(&1[:type] == :switch),
        "Progress Components": &(&1[:type] == :progress),
        "Pagination Components": &(&1[:type] == :pagination),
        "Toast Components": &(&1[:type] == :toast),
        "File Uploader Components": &(&1[:type] == :file_uploader),
        "Gallery Components": &(&1[:type] == :gallery),
        "Data Table Components": &(&1[:type] == :data_table),
        "Date Picker Components": &(&1[:type] == :date_picker)
      ],
      source_ref: "v#{@version}",
      source_url: @source_url,
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end
end
