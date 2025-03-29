defmodule PineUi do
  @moduledoc """
  Pine UI is a collection of Phoenix components built with AlpineJS and TailwindCSS.

  This library provides a set of interactive UI components that can be used in Phoenix LiveView
  applications. The components leverage the simplicity of AlpineJS for interactivity and
  TailwindCSS for styling.

  ## Installation

  Add Pine UI to your `mix.exs`:

  ```elixir
  def deps do
    [
      {:pine_ui_phoenix, "~> 0.1.0"}
    ]
  end
  ```

  After running `mix deps.get`, make sure your application includes:

  1. TailwindCSS - For styling components
  2. AlpineJS - For component interactivity

  ## Usage Example

  ```heex
  <PineUi.typing_effect
    text_list={Poison.encode!(["Welcome to my site", "Built with Phoenix", "And Pine UI"])}
    class="flex justify-center"
    text_class="text-2xl font-bold text-indigo-600"
  />

  <PineUi.tooltip
    title="Need help?"
    description="Click for assistance"
    type="top"
    class="px-3 py-2 text-sm rounded-md bg-indigo-100 text-indigo-700 hover:bg-indigo-200"
  />
  ```

  ## Available Components

  - `typing_effect/1` - Creates a typing animation with multiple text items
  - `text_animation_blow/1` - Letter-by-letter animation that scales in
  - `text_animation_fade/1` - Letter-by-letter fade-in animation
  - `tooltip/1` - Interactive tooltip with different positions (top, left, right)
  - `button_primary/1` - Primary action button with loading state
  - `button_secondary/1` - Secondary action button with loading state
  - `button_danger/1` - Danger action button with loading state
  - `badge/1` - Simple badge component with various colors
  - `badge_dot/1` - Badge with dot indicator
  - `badge_dismissible/1` - Badge that can be dismissed/removed
  - `card/1` - Basic card component for content organization
  - `card_interactive/1` - Interactive card with hover effects
  - `card_collapsible/1` - Collapsible card for expandable content
  - `select/1` - Basic select dropdown component
  - `select_grouped/1` - Select dropdown with option groups
  - `select_searchable/1` - Searchable select dropdown with filtering
  - `text_input/1` - Basic text input component
  - `text_input_with_icon/1` - Text input with icon
  - `textarea/1` - Multiline text input component

  ## Component Options

  Each component accepts specific options as assigns. See the documentation for
  individual functions for details.
  """

  use Phoenix.Component

  alias PineUi.{
    Badge,
    Button,
    Card,
    Select,
    Text,
    TextInput,
    Tooltip
  }

  @doc """
  Renders a typing effect component that cycles through a list of texts.

  This component creates a typewriter-like effect where text is typed out,
  deleted, and replaced with the next text in the list.

  ## Examples

      <PineUi.typing_effect
        text_list={Poison.encode!(["First message", "Second message"])}
        class="flex justify-center py-8"
        text_class="text-2xl font-black text-blue-600"
      />

  ## Options

  * `:text_list` - A JSON string array of texts to cycle through (required, will use defaults if not provided)
  * `:class` - CSS classes to apply to the container element (optional)
  * `:text_class` - CSS classes to apply to the text element (optional)
  """
  def typing_effect(assigns) do
    assigns =
      assign_new(assigns, :text_list, fn ->
        Poison.encode!(["Alpine JS is Amazing", "It is Truly Awesome!", "You Have to Try It!"])
      end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:text_class, fn -> "text-2xl font-black leading-tight" end)

    Text.typing_effect(assigns)
  end

  @doc """
  Renders text with a scale animation where letters blow up into place.

  This component animates each letter of the text individually, starting from a
  larger scale and shrinking into place.

  ## Examples

      <PineUi.text_animation_blow text="Welcome to Pine UI" />

      <PineUi.text_animation_blow text="Amazing Animations" />

  ## Options

  * `:text` - The text to animate (required, uses "Pines UI Library" if not provided)
  """
  def text_animation_blow(assigns) do
    assigns = assign_new(assigns, :text, fn -> "Pines UI Library" end)

    Text.animation_blow(assigns)
  end

  @doc """
  Renders a customizable tooltip component.

  This component shows a tooltip when hovering over text. The tooltip can
  be positioned at the top, left, or right of the trigger element.

  ## Examples

      <PineUi.tooltip
        title="Click me"
        description="This will do something cool"
        type="top"
        class="px-3 py-1 text-sm rounded-lg bg-blue-100 text-blue-700 hover:bg-blue-200"
      />

  ## Options

  * `:title` - The text to display as the trigger (required, uses "hover me" if not provided)
  * `:description` - The tooltip text (required, uses "Tooltip text" if not provided)
  * `:type` - The tooltip position: "top" (default), "left", or "right"
  * `:class` - CSS classes to apply to the trigger element (optional)
  """
  def tooltip(assigns) do
    assigns =
      assign_new(assigns, :title, fn -> "hover me" end)
      |> assign_new(:description, fn -> "Tooltip text" end)
      |> assign_new(:type, fn -> nil end)
      |> assign_new(:class, fn ->
        "px-3 py-1 text-xs rounded-full cursor-pointer text-neutral-500 bg-neutral-100"
      end)

    case assigns.type do
      "left" -> Tooltip.left(assigns)
      "right" -> Tooltip.right(assigns)
      _ -> Tooltip.top(assigns)
    end
  end

  @doc """
  Renders text with a fade-in animation for each letter.

  This component animates each letter of the text individually with a fade-in effect,
  creating a smooth appearance animation.

  ## Examples

      <PineUi.text_animation_fade text="Welcome to Pine UI" />

      <PineUi.text_animation_fade text="Smooth Animations" />

  ## Options

  * `:text` - The text to animate (required, uses "Pines UI Library" if not provided)
  """
  def text_animation_fade(assigns) do
    assigns = assign_new(assigns, :text, fn -> "Pines UI Library" end)

    Text.animation_fade(assigns)
  end

  @doc """
  Renders a primary button component with optional loading state.

  This component creates a primary action button that can display a loading spinner
  and supports LiveView click events.

  ## Examples

      <PineUi.button_primary phx_click="save">
        Save Changes
      </PineUi.button_primary>

      <PineUi.button_primary loading={@saving} disabled={@form_invalid} class="w-full">
        Submit Form
      </PineUi.button_primary>

  ## Options

  * `:type` - Button type attribute (optional, defaults to "button")
  * `:class` - Additional CSS classes (optional)
  * `:disabled` - Whether the button is disabled (optional, defaults to false)
  * `:loading` - Whether to show loading state (optional, defaults to false)
  * `:icon` - HTML string for an icon to display before text (optional)
  * `:phx_click` - The LiveView click event to trigger (optional)
  * `:phx_value_id` - The id value to pass with the event (optional)
  * `:phx_target` - The LiveView target for the event (optional)
  """
  def button_primary(assigns) do
    Button.primary(assigns)
  end

  @doc """
  Renders a secondary button component with optional loading state.

  This component creates a secondary action button that can display a loading spinner
  and supports LiveView click events.

  ## Examples

      <PineUi.button_secondary phx_click="cancel">
        Cancel
      </PineUi.button_secondary>

      <PineUi.button_secondary loading={@loading} class="mt-2">
        View Details
      </PineUi.button_secondary>

  ## Options

  * `:type` - Button type attribute (optional, defaults to "button")
  * `:class` - Additional CSS classes (optional)
  * `:disabled` - Whether the button is disabled (optional, defaults to false)
  * `:loading` - Whether to show loading state (optional, defaults to false)
  * `:icon` - HTML string for an icon to display before text (optional)
  * `:phx_click` - The LiveView click event to trigger (optional)
  * `:phx_value_id` - The id value to pass with the event (optional)
  * `:phx_target` - The LiveView target for the event (optional)
  """
  def button_secondary(assigns) do
    Button.secondary(assigns)
  end

  @doc """
  Renders a danger button component with optional loading state.

  This component creates a danger/warning action button that can display a loading spinner
  and supports LiveView click events.

  ## Examples

      <PineUi.button_danger phx_click="delete" phx_value_id={@item.id}>
        Delete Item
      </PineUi.button_danger>

      <PineUi.button_danger loading={@deleting} class="mt-4">
        Permanently Delete
      </PineUi.button_danger>

  ## Options

  * `:type` - Button type attribute (optional, defaults to "button")
  * `:class` - Additional CSS classes (optional)
  * `:disabled` - Whether the button is disabled (optional, defaults to false)
  * `:loading` - Whether to show loading state (optional, defaults to false)
  * `:icon` - HTML string for an icon to display before text (optional)
  * `:phx_click` - The LiveView click event to trigger (optional)
  * `:phx_value_id` - The id value to pass with the event (optional)
  * `:phx_target` - The LiveView target for the event (optional)
  """
  def button_danger(assigns) do
    Button.danger(assigns)
  end

  @doc """
  Renders a badge component.

  This component creates a simple badge with customizable colors.

  ## Examples

      <PineUi.badge variant="success">
        Completed
      </PineUi.badge>

      <PineUi.badge variant="warning" class="ml-2">
        Pending
      </PineUi.badge>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  * `:icon` - HTML string for an icon to display before text (optional)
  """
  def badge(assigns) do
    assigns = assign_new(assigns, :variant, fn -> "default" end)
    Badge.base(assigns)
  end

  @doc """
  Renders a badge with a status dot.

  This component creates a badge with a colored status dot at the beginning.

  ## Examples

      <PineUi.badge_dot variant="success">
        Active
      </PineUi.badge_dot>

      <PineUi.badge_dot variant="danger" class="ml-2">
        Offline
      </PineUi.badge_dot>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  """
  def badge_dot(assigns) do
    assigns = assign_new(assigns, :variant, fn -> "default" end)
    Badge.dot(assigns)
  end

  @doc """
  Renders a dismissible badge.

  This component creates a badge that can be removed/dismissed with a click.
  Uses AlpineJS for the dismissal functionality.

  ## Examples

      <PineUi.badge_dismissible variant="info">
        New Feature
      </PineUi.badge_dismissible>

      <PineUi.badge_dismissible variant="purple" class="ml-2">
        Beta
      </PineUi.badge_dismissible>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  """
  def badge_dismissible(assigns) do
    assigns = assign_new(assigns, :variant, fn -> "default" end)
    Badge.dismissible(assigns)
  end

  @doc """
  Renders a basic card component.

  This component creates a simple card container with optional title, subtitle, and footer.

  ## Examples

      <PineUi.card title="User Profile" subtitle="Personal information">
        <p>Card content goes here</p>
      </PineUi.card>

      <PineUi.card class="mt-4" footer="Last updated: Yesterday">
        <div class="space-y-4">
          <p>Multiple paragraphs can go here</p>
          <p>With any content structure</p>
        </div>
      </PineUi.card>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def card(assigns) do
    Card.basic(assigns)
  end

  @doc """
  Renders an interactive card component with hover effects.

  This component creates a card that responds to hover with subtle animation.

  ## Examples

      <PineUi.card_interactive title="Hover me">
        <p>This card has hover effects</p>
      </PineUi.card_interactive>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def card_interactive(assigns) do
    Card.interactive(assigns)
  end

  @doc """
  Renders a collapsible card component.

  This component creates a card that can be expanded/collapsed when clicked.

  ## Examples

      <PineUi.card_collapsible title="Click to expand" open={true}>
        <p>This content can be hidden or shown</p>
      </PineUi.card_collapsible>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:open` - Whether the card is expanded on initial render (optional, defaults to false)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def card_collapsible(assigns) do
    Card.collapsible(assigns)
  end

  @doc """
  Renders a basic select dropdown component.

  ## Examples

      <PineUi.select
        id="country"
        label="Country"
        options={[{"us", "United States"}, {"ca", "Canada"}, {"mx", "Mexico"}]}
        selected="us"
        placeholder="Select a country"
        hint="Choose your country of residence"
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:options` - List of {value, label} tuples for the options (required)
  * `:selected` - The currently selected value (optional)
  * `:placeholder` - Placeholder text for empty selection (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def select(assigns) do
    Select.basic(assigns)
  end

  @doc """
  Renders a select dropdown with option groups.

  ## Examples

      <PineUi.select_grouped
        id="continent"
        label="Country"
        option_groups={[
          {"North America", [{"us", "United States"}, {"ca", "Canada"}]},
          {"Europe", [{"fr", "France"}, {"de", "Germany"}]}
        ]}
        selected="fr"
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:option_groups` - List of {group_label, options} tuples where options is a list of {value, label} tuples (required)
  * `:selected` - The currently selected value (optional)
  * `:placeholder` - Placeholder text for empty selection (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def select_grouped(assigns) do
    Select.grouped(assigns)
  end

  @doc """
  Renders a searchable select dropdown with filtering.

  ## Examples

      <PineUi.select_searchable
        id="country"
        label="Country"
        options={[{"us", "United States"}, {"ca", "Canada"}, {"mx", "Mexico"}]}
        selected="us"
        selected_label="United States"
        placeholder="Search countries..."
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:options` - List of {value, label} tuples for the options (required)
  * `:selected` - The currently selected value (optional)
  * `:selected_label` - The label for the currently selected value (optional, should match the label in options)
  * `:placeholder` - Placeholder text for the search input (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def select_searchable(assigns) do
    Select.searchable(assigns)
  end

  @doc """
  Renders a basic text input component.

  ## Examples

      <PineUi.text_input
        id="email"
        label="Email Address"
        type="email"
        placeholder="you@example.com"
        required={true}
      />

      <PineUi.text_input
        id="price"
        label="Price"
        type="number"
        prefix="$"
        suffix="USD"
        hint="Enter amount in dollars"
        error={@form_errors[:price]}
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:type` - Input type (optional, defaults to "text")
  * `:value` - Current input value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:prefix` - Text to display before the input (optional)
  * `:suffix` - Text to display after the input (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_focus` - Phoenix focus event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the input element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def text_input(assigns) do
    TextInput.basic(assigns)
  end

  @doc """
  Renders a text input with an icon on the left.

  ## Examples

      <PineUi.text_input_with_icon
        id="search"
        placeholder="Search..."
        icon={~H"<svg class='h-5 w-5 text-gray-400' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'><path fill-rule='evenodd' d='M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z' clip-rule='evenodd'/></svg>"}
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:type` - Input type (optional, defaults to "text")
  * `:value` - Current input value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:icon` - SVG or HTML for the icon (required)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_focus` - Phoenix focus event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the input element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def text_input_with_icon(assigns) do
    TextInput.with_icon(assigns)
  end

  @doc """
  Renders a textarea component for multiline text input.

  ## Examples

      <PineUi.textarea
        id="description"
        label="Description"
        rows={6}
        placeholder="Enter a detailed description..."
        hint="Markdown formatting is supported"
      />

  ## Options

  * `:id` - The ID for the textarea element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:value` - Current textarea value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:rows` - Number of visible rows (optional, defaults to 4)
  * `:hint` - Help text displayed below the textarea (optional)
  * `:error` - Error message displayed below the textarea (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the textarea element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def textarea(assigns) do
    TextInput.textarea(assigns)
  end
end
