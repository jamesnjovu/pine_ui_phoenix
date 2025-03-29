defmodule PineUi.Types do
  @moduledoc """
  Type specifications for Pine UI components.

  This module contains type specifications used throughout the library
  to provide better documentation and IDE support.
  """

  @typedoc """
  Component default assigns.

  Common assigns accepted by most components:
  - `:class` - Additional CSS classes
  - `:id` - DOM element ID
  - `:phx_*` - Phoenix LiveView specific attributes
  """
  @type assigns :: Phoenix.LiveView.Socket.assigns()

  @typedoc """
  Button component assigns.

  Additional assigns:
  - `:loading` - Boolean to show loading state
  - `:disabled` - Boolean to disable the button
  - `:icon` - Optional icon markup
  """
  @type button_assigns :: assigns()

  @typedoc """
  Card component assigns.

  Additional assigns:
  - `:title` - Optional card title
  - `:subtitle` - Optional card subtitle
  - `:footer` - Optional footer content
  - `:padded` - Boolean to add padding to content area
  """
  @type card_assigns :: assigns()

  @typedoc """
  Text input component assigns.

  Additional assigns:
  - `:label` - Optional input label
  - `:value` - Current input value
  - `:placeholder` - Placeholder text
  - `:required` - Boolean for required input
  - `:disabled` - Boolean to disable the input
  - `:hint` - Optional help text
  - `:error` - Optional error message
  """
  @type text_input_assigns :: assigns()

  @typedoc """
  Select component assigns.

  Additional assigns:
  - `:options` - List of {value, label} tuples
  - `:selected` - Currently selected value
  - `:placeholder` - Placeholder text
  """
  @type select_assigns :: assigns()

  @typedoc """
  Badge component assigns.

  Additional assigns:
  - `:variant` - Color variant (success, warning, etc.)
  """
  @type badge_assigns :: assigns()
end
