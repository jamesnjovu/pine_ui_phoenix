defmodule PineUiPhoenix do
  @moduledoc """
  # Pine UI 🌲

  Pine UI is a comprehensive collection of UI components for Phoenix applications,
  built with AlpineJS and TailwindCSS. The library provides interactive, accessible,
  and customizable components to speed up development of modern web interfaces.

  ## Installation

  Add Pine UI to your `mix.exs`:

  ```elixir
  def deps do
    [
      {:pine_ui_phoenix, "~> 0.1.0"}
    ]
  end
  ```

  After running `mix deps.get`, make sure your project includes:

  1. **TailwindCSS** - For component styling
  2. **AlpineJS** - For component interactivity

  ## Component Categories

  Pine UI offers components organized in the following categories:

  ### Text & Animation
  - `typing_effect/1` - Creates a typing animation with multiple text items
  - `text_animation_blow/1` - Letter-by-letter animation that scales in
  - `text_animation_fade/1` - Letter-by-letter fade-in animation

  ### Interactive Elements
  - `tooltip/1` - Interactive tooltip with different positions
  - `button_primary/1`, `button_secondary/1`, `button_danger/1` - Button variants with loading states

  ### Content Organization
  - `card/1` - Basic card component for content organization
  - `card_interactive/1` - Interactive card with hover effects
  - `card_collapsible/1` - Collapsible card for expandable content

  ### Form Elements
  - `text_input/1` - Basic text input component
  - `text_input_with_icon/1` - Text input with icon
  - `textarea/1` - Multiline text input component
  - `select/1` - Basic select dropdown component
  - `select_grouped/1` - Select dropdown with option groups
  - `select_searchable/1` - Searchable select dropdown with filtering

  ### Status Indicators
  - `badge/1` - Simple badge component with various colors
  - `badge_dot/1` - Badge with dot indicator
  - `badge_dismissible/1` - Badge that can be dismissed/removed

  ## Basic Usage

  ```heex
  <div class="p-8 space-y-4">
    <PineUiPhoenix.text_animation_blow text="Welcome to Pine UI" />

    <PineUiPhoenix.card title="Getting Started">
      <p>Pine UI makes it easy to build interactive Phoenix applications.</p>

      <div class="mt-4 flex space-x-2">
        <PineUiPhoenix.button_primary>
          Get Started
        </PineUiPhoenix.button_primary>

        <PineUiPhoenix.button_secondary>
          Documentation
        </PineUiPhoenix.button_secondary>
      </div>
    </PineUiPhoenix.card>

    <PineUiPhoenix.typing_effect
      text_list={Poison.encode!(["Easy to use", "Highly customizable", "Interactive components"])}
      class="flex justify-center"
      text_class="text-xl font-medium text-indigo-600"
    />
  </div>
  ```

  ## Component Design Philosophy

  Pine UI components follow these principles:

  1. **Progressive Enhancement** - Components work without JavaScript but provide enhanced experiences when it's available
  2. **Accessibility Built-in** - ARIA attributes and keyboard navigation included by default
  3. **Tailwind-first** - Styled with TailwindCSS for easy customization and consistency
  4. **Alpine-powered** - Interactive behaviors handled by AlpineJS for minimal overhead
  5. **Phoenix-friendly** - Designed to work seamlessly with Phoenix and LiveView

  ## Customization

  Each component accepts class names that can be used to customize the appearance.
  Common parameters include:

  - `:class` - Additional CSS classes for the main element
  - `:container_class` - CSS classes for the container element
  - `:variant` - For components with multiple style variants (success, warning, etc.)

  ## Accessibility

  Pine UI components are designed with accessibility in mind, following WCAG guidelines.
  Components include appropriate ARIA roles, states, and properties where applicable.
  """

  use Phoenix.Component
  import Phoenix.HTML
  import Phoenix.HTML.Form

  alias PineUiPhoenix.{
    Accordion,
    Badge,
    Button,
    Card,
    DataTable,
    DatePicker,
    Dropdown,
    FileUploader,
    Gallery,
    Modal,
    Pagination,
    Progress,
    Select,
    Switch,
    Tabs,
    Text,
    TextInput,
    Toast,
    Tooltip
    }

  @doc """
  Renders a typing effect component that cycles through a list of texts.

   This component creates a typewriter-like effect where text is typed out,
  deleted, and replaced with the next text in the list.

  ## Examples

      <.typing_effect
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
      assign_new(
        assigns,
        :text_list,
        fn ->
          Poison.encode!(["Alpine JS is Amazing", "It is Truly Awesome!", "You Have to Try It!"])
        end
      )
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:text_class, fn -> "text-2xl font-black leading-tight" end)

    Text.typing_effect(assigns)
  end

  @doc """
  Renders text with a scale animation where letters blow up into place.

   This component animates each letter of the text individually, starting from a
  larger scale and shrinking into place.

  ## Examples

      <.text_animation_blow text="Welcome to Pine UI" />

      <.text_animation_blow text="Amazing Animations" />

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

      <.tooltip
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
      |> assign_new(
           :class,
           fn ->
             "px-3 py-1 text-xs rounded-full cursor-pointer text-neutral-500 bg-neutral-100"
           end
         )

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

      <.text_animation_fade text="Welcome to Pine UI" />

      <.text_animation_fade text="Smooth Animations" />

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

      <.button_primary phx_click="save">
        Save Changes
      </.button_primary>

      <.button_primary loading={@saving} disabled={@form_invalid} class="w-full">
        Submit Form
      </.button_primary>

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

      <.button_secondary phx_click="cancel">
        Cancel
      </.button_secondary>

      <.button_secondary loading={@loading} class="mt-2">
        View Details
      </.button_secondary>

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

      <.button_danger phx_click="delete" phx_value_id={@item.id}>
        Delete Item
      </.button_danger>

      <.button_danger loading={@deleting} class="mt-4">
        Permanently Delete
      </.button_danger>

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

      <.badge variant="success">
        Completed
      </.badge>

      <.badge variant="warning" class="ml-2">
        Pending
      </.badge>

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

      <.badge_dot variant="success">
        Active
      </.badge_dot>

      <.badge_dot variant="danger" class="ml-2">
        Offline
      </.badge_dot>

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

      <.badge_dismissible variant="info">
        New Feature
      </.badge_dismissible>

      <.badge_dismissible variant="purple" class="ml-2">
        Beta
      </.badge_dismissible>

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

      <.card title="User Profile" subtitle="Personal information">
        <p>Card content goes here</p>
      </.card>

      <.card class="mt-4" footer="Last updated: Yesterday">
        <div class="space-y-4">
          <p>Multiple paragraphs can go here</p>
          <p>With any content structure</p>
        </div>
      </.card>

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

      <.card_interactive title="Hover me">
        <p>This card has hover effects</p>
      </.card_interactive>

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

      <.card_collapsible title="Click to expand" open={true}>
        <p>This content can be hidden or shown</p>
      </.card_collapsible>

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

      <.select
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

      <.select_grouped
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

      <.select_searchable
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

      <.text_input
        id="email"
        label="Email Address"
        type="email"
        placeholder="you@example.com"
        required={true}
      />

      <.text_input
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

      <.text_input_with_icon
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

      <.textarea
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

  @doc """
  Renders an accordion item with a toggle to expand/collapse content.

  This component provides a simple way to implement expandable/collapsible content.
  It's particularly useful for FAQs, product details, or any content that needs
  to be organized in a space-efficient manner.

  ## Examples

      <.accordion_item title="How does shipping work?">
        <p>We ship to all 50 states within 3-5 business days.</p>
      </.accordion_item>

      <.accordion_item
        title="Product Specifications"
        subtitle="Technical details about this product"
        open={true}
      >
        <ul class="list-disc pl-5 space-y-2">
          <li>Dimension: 10" x 8" x 2"</li>
          <li>Weight: 1.5 lbs</li>
          <li>Material: Aircraft-grade aluminum</li>
        </ul>
      </.accordion_item>

  ## Options

  * `:title` - The title displayed in the accordion header (required)
  * `:subtitle` - Optional subtitle displayed below the title (optional)
  * `:open` - Whether the accordion is expanded initially (optional, defaults to false)
  * `:class` - Additional CSS classes for the accordion container (optional)
  * `:header_class` - Additional CSS classes for the header section (optional)
  * `:content_class` - Additional CSS classes for the content section (optional)
  """
  def accordion_item(assigns) do
    Accordion.basic(assigns)
  end

  @doc """
  Renders a group of accordion items where only one can be open at a time.

  This component is useful for organizing related content into multiple
  expandable sections, where opening one section automatically closes
  the others.

  ## Examples

      <.accordion_group>
        <:item title="Section 1">
          <p>Content for section 1</p>
        </:item>
        <:item title="Section 2">
          <p>Content for section 2</p>
        </:item>
        <:item title="Section 3" active={true}>
          <p>This section is open by default</p>
        </:item>
      </.accordion_group>

  ## Options

  * `:class` - Additional CSS classes for the accordion group container (optional)
  * `:item_class` - Additional CSS classes applied to each accordion item (optional)
  * `:header_class` - Additional CSS classes for each item header (optional)
  * `:content_class` - Additional CSS classes for each item content (optional)
  * `:item` - Item slots with the following attributes:
    * `:title` - Item header text (required)
    * `:subtitle` - Optional subheading text below the title (optional)
    * `:active` - Whether this item is expanded initially (optional, default to false)
  """
  def accordion_group(assigns) do
    assigns =
      assigns
      |> assign_new(:panel_class, fn -> Map.get(assigns, :item_class, "") end)
      |> update(:panel, fn _panel -> Enum.map(assigns[:item] || [], &Map.put(&1, :__slot__, "panel")) end)

    Accordion.group(assigns)
  end

  @doc """
  Renders a basic tabs component with tab buttons and content panes.

  This component creates a tabbed interface where clicking on a tab button
  displays its associated content pane.

  ## Examples

      <.tabs>
        <:tab title="Account Settings" active={true}>
          <p>Content for the Account Settings tab.</p>
        </:tab>
        <:tab title="Profile">
          <p>Content for the Profile tab.</p>
        </:tab>
        <:tab title="Notifications">
          <p>Content for the Notifications tab.</p>
        </:tab>
      </.tabs>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the tab button list (optional)
  * `:tab_button_class` - Base CSS classes for all tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active tab button (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive tab buttons (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the following attributes:
    * `:title` - Text displayed in the tab button (required)
    * `:active` - Whether this tab is selected initially (optional, defaults to false)
    * `:disabled` - Whether this tab is disabled (optional, defaults to false)
  """
  def tabs(assigns) do
    Tabs.basic(assigns)
  end

  @doc """
  Renders a pill-style tabs component with rounded tab buttons.

  This component creates a tabbed interface with pill-shaped tab buttons.

  ## Examples

      <.tabs_pills>
        <:tab title="Overview" active={true}>
          <p>Overview content goes here.</p>
        </:tab>
        <:tab title="Features">
          <p>Features content goes here.</p>
        </:tab>
        <:tab title="Specifications">
          <p>Specifications content goes here.</p>
        </:tab>
      </.tabs_pills>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the pill tab list (optional)
  * `:tab_button_class` - Base CSS classes for all pill tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active pill tab (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive pill tabs (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the same attributes as in the `tabs/1` component
  """
  def tabs_pills(assigns) do
    Tabs.pills(assigns)
  end

  @doc """
  Renders a boxed tabs component with full-width tab panels and border.

  This component creates a tabbed interface with box-style tabs and
  content panels with a border.

  ## Examples

      <.tabs_boxed>
        <:tab title="Comments" active={true}>
          <p>Comments content goes here.</p>
        </:tab>
        <:tab title="Activity">
          <p>Activity content goes here.</p>
        </:tab>
        <:tab title="Archives">
          <p>Archives content goes here.</p>
        </:tab>
      </.tabs_boxed>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the boxed tab list (optional)
  * `:tab_button_class` - Base CSS classes for all boxed tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active boxed tab (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive boxed tabs (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the same attributes as in the `tabs/1` component
  """
  def tabs_boxed(assigns) do
    Tabs.boxed(assigns)
  end

  @doc """
  Renders a modal dialog component.

  This component creates a modal dialog that appears centered on the screen.
  It includes a backdrop overlay, title, optional close button, and content area.

  ## Examples

      <.modal id="confirm-modal" title="Confirm Action">
        <p>Are you sure you want to perform this action?</p>
        <div class="mt-4 flex justify-end space-x-3">
          <button x-on:click="show = false" class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-md">Cancel</button>
          <button x-on:click="show = false" class="px-4 py-2 text-sm text-white bg-indigo-600 rounded-md">Confirm</button>
        </div>
      </.modal>

      <button x-on:click="$dispatch('open-modal', { id: 'confirm-modal' })">Open Modal</button>

  ## Options

  * `:id` - Unique identifier for the modal (required)
  * `:title` - Modal dialog title (optional)
  * `:show_close_button` - Whether to show the close button (optional, defaults to true)
  * `:max_width` - Maximum width of the modal: "sm", "md", "lg", "xl", "2xl", "full" (optional, defaults to "lg")
  * `:class` - Additional CSS classes for the modal container (optional)
  * `:header_class` - CSS classes for the modal header (optional)
  * `:content_class` - CSS classes for the modal content area (optional)
  * `:overlay_class` - CSS classes for the backdrop overlay (optional)
  * `:focus_element` - ID of element to focus when modal opens (optional, defaults to first focusable element)
  """
  def modal(assigns) do
    Modal.basic(assigns)
  end

  @doc """
  Renders a full screen modal that covers the entire viewport.

  This component creates a modal that takes up the full screen when opened,
  with a header that contains the title and close button.

  ## Examples

      <.modal_full_screen id="settings-modal" title="Application Settings">
        <div class="h-full overflow-y-auto">
          <p>Full screen modal content goes here.</p>
        </div>
      </.modal_full_screen>

      <button x-on:click="$dispatch('open-modal', { id: 'settings-modal' })">Settings</button>

  ## Options

  * `:id` - Unique identifier for the modal (required)
  * `:title` - Modal dialog title (optional)
  * `:show_close_button` - Whether to show the close button (optional, defaults to true)
  * `:class` - Additional CSS classes for the modal container (optional)
  * `:header_class` - CSS classes for the modal header (optional)
  * `:content_class` - CSS classes for the modal content area (optional)
  """
  def modal_full_screen(assigns) do
    Modal.full_screen(assigns)
  end

  @doc """
  Renders a slide-over modal that appears from the side of the screen.

  This component creates a modal that slides in from the specified side
  (right by default) and covers a portion of the screen.

  ## Examples

      <.modal_side id="cart-modal" title="Shopping Cart">
        <div class="h-full overflow-y-auto">
          <p>Cart content goes here.</p>
        </div>
      </.modal_side>

      <button x-on:click="$dispatch('open-modal', { id: 'cart-modal' })">View Cart</button>

  ## Options

  * `:id` - Unique identifier for the modal (required)
  * `:title` - Modal dialog title (optional)
  * `:show_close_button` - Whether to show the close button (optional, defaults to true)
  * `:side` - Which side the modal slides in from: "right" or "left" (optional, defaults to "right")
  * `:width` - Width of the slide-over panel: "sm", "md", "lg", "xl", "2xl", "full" (optional, defaults to "md")
  * `:class` - Additional CSS classes for the modal container (optional)
  * `:header_class` - CSS classes for the modal header (optional)
  * `:content_class` - CSS classes for the modal content area (optional)
  * `:overlay_class` - CSS classes for the backdrop overlay (optional)
  """
  def modal_side(assigns) do
    Modal.side(assigns)
  end

  @doc """
  Renders a toggle switch component.

  This component creates a simple on/off toggle switch for boolean options.

  ## Examples

      <.switch
        id="notifications"
        name="user[notifications]"
        value={@user.notifications}
        label="Enable notifications"
      />

      <.switch
        id="dark_mode"
        value={false}
        label="Dark mode"
        size="sm"
        variant="indigo"
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:label` - Text label for the switch (optional)
  * `:help_text` - Help text displayed below the switch (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:size` - Size of the switch: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the switch container (optional)
  * `:label_class` - CSS classes for the label text (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def switch(assigns) do
    Switch.basic(assigns)
  end

  @doc """
  Renders a labeled toggle switch component with a descriptive label on each side.

  This component creates a switch with labels for both on and off states.

  ## Examples

      <.switch_labeled
        id="status"
        name="project[status]"
        value={@project.status}
        left_label="Draft"
        right_label="Published"
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:left_label` - Text label for the off state (optional, defaults to "Off")
  * `:right_label` - Text label for the on state (optional, defaults to "On")
  * `:help_text` - Help text displayed below the switch (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:size` - Size of the switch: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the switch container (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def switch_labeled(assigns) do
    Switch.labeled_switch(assigns)
  end

  @doc """
  Renders a card-style toggle switch component.

  This component creates an elegant card-style switch with label and icon.

  ## Examples

      <.switch_card
        id="auto_renewal"
        value={true}
        title="Auto-renewal"
        description="Automatically renew your subscription"
        icon={~H"<svg class='h-6 w-6 text-indigo-600' fill='none' viewBox='0 0 24 24' stroke-width='1.5' stroke='currentColor'>
          <path stroke-linecap='round' stroke-linejoin='round' d='M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99' />
        </svg>"}
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:title` - The card title text (optional)
  * `:description` - Descriptive text for the switch (optional)
  * `:icon` - Icon markup to display (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the card container (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def switch_card(assigns) do
    Switch.card_switch(assigns)
  end
  @doc """
  Renders a dropdown menu component.

  This component creates a dropdown menu that appears when a trigger button
  is clicked. The menu can contain links, buttons, or other elements.

  ## Examples

      <.dropdown id="user-menu" label="Options">
        <:item href="/profile">Profile</:item>
        <:item href="/settings">Settings</:item>
        <:divider />
        <:item href="/logout" class="text-red-600">Log out</:item>
      </.dropdown>

      <.dropdown id="actions-menu" icon={~H"<svg>...</svg>"}>
        <:item on_click="edit">Edit</:item>
        <:item on_click="duplicate">Duplicate</:item>
        <:divider />
        <:item on_click="delete" class="text-red-600">Delete</:item>
      </.dropdown>

  ## Options

  * `:id` - Unique identifier for the dropdown (required)
  * `:label` - Text for the trigger button (either this or icon is required)
  * `:icon` - Icon markup for the trigger button (either this or label is required)
  * `:position` - Menu position: "bottom-left", "bottom-right", "top-left", "top-right" (optional, defaults to "bottom-left")
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:button_class` - CSS classes for the trigger button (optional)
  * `:menu_class` - CSS classes for the dropdown menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def dropdown(assigns) do
    Dropdown.basic(assigns)
  end

  @doc """
  Renders a dropdown menu with item icons.

  This component creates a dropdown menu with icon support for menu items.

  ## Examples

      <.dropdown_with_icons id="file-menu" label="File">
        <:item
          href="#"
          icon={~H"<svg class='h-4 w-4' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
            <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 6v6m0 0v6m0-6h6m-6 0H6' />
          </svg>"}
        >
          New Document
        </:item>
        <:divider />
        <:item
          href="#"
          icon={~H"<svg class='h-4 w-4' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
            <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4' />
          </svg>"}
        >
          Save
        </:item>
      </.dropdown_with_icons>

  ## Options

  * `:id` - Unique identifier for the dropdown (required)
  * `:label` - Text for the trigger button (either this or icon is required)
  * `:icon` - Icon markup for the trigger button (either this or label is required)
  * `:position` - Menu position: "bottom-left", "bottom-right", "top-left", "top-right" (optional, defaults to "bottom-left")
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:button_class` - CSS classes for the trigger button (optional)
  * `:menu_class` - CSS classes for the dropdown menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:icon` - Icon markup for the menu item (optional)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def dropdown_with_icons(assigns) do
    Dropdown.with_icons(assigns)
  end

  @doc """
  Renders a contextual menu.

  This component creates a dropdown menu that appears at the cursor position
  when triggered, ideal for context or right-click menus.

  ## Examples

      <.context_menu id="context-menu">
        <:item on_click="edit">Edit</:item>
        <:item on_click="copy">Copy</:item>
        <:item on_click="delete" class="text-red-600">Delete</:item>
      </.context_menu>

      <div x-on:contextmenu="$event.preventDefault(); $dispatch('open-context-menu', { id: 'context-menu', x: $event.clientX, y: $event.clientY })">
        Right-click me
      </div>

  ## Options

  * `:id` - Unique identifier for the context menu (required)
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:menu_class` - CSS classes for the context menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:icon` - Icon markup for the menu item (optional)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def context_menu(assigns) do
    Dropdown.context_menu(assigns)
  end

  @doc """
  Renders a progress bar component.

  This component creates a horizontal progress bar that visually represents
  completion progress.

  ## Examples

      <.progress_bar value={75} />

      <.progress_bar
        value={42}
        max={100}
        label="Uploading..."
        show_percentage={true}
        size="lg"
        variant="indigo"
      />

  ## Options

  * `:value` - Current progress value (required)
  * `:max` - Maximum value representing 100% completion (optional, defaults to 100)
  * `:label` - Text label for the progress bar (optional)
  * `:show_percentage` - Whether to show percentage text (optional, defaults to false)
  * `:size` - Size of the bar: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the progress container (optional)
  * `:bar_class` - CSS classes for the progress bar itself (optional)
  * `:label_class` - CSS classes for the label text (optional)
  """
  def progress_bar(assigns) do
    Progress.bar(assigns)
  end

  @doc """
  Renders a progress bar component.

  This component creates a horizontal progress bar that visually represents
  completion progress.

  ## Examples

      <.progress_bar value={75} />

      <.progress_bar
        value={42}
        max={100}
        label="Uploading..."
        show_percentage={true}
        size="lg"
        variant="indigo"
      />

  ## Options

  * `:value` - Current progress value (required)
  * `:max` - Maximum value representing 100% completion (optional, defaults to 100)
  * `:label` - Text label for the progress bar (optional)
  * `:show_percentage` - Whether to show percentage text (optional, defaults to false)
  * `:size` - Size of the bar: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the progress container (optional)
  * `:bar_class` - CSS classes for the progress bar itself (optional)
  * `:label_class` - CSS classes for the label text (optional)
  """
  def progress_bar(assigns) do
    Progress.bar(assigns)
  end

  @doc """
  Renders a circular progress indicator.

  This component creates a circular progress indicator with customizable appearance.

  ## Examples

      <.progress_circle value={75} />

      <.progress_circle
        value={42}
        max={100}
        label="Uploading..."
        show_percentage={true}
        size="lg"
        variant="indigo"
      />

  ## Options

  * `:value` - Current progress value (required)
  * `:max` - Maximum value representing 100% completion (optional, defaults to 100)
  * `:label` - Text label for the progress circle (optional)
  * `:show_percentage` - Whether to show percentage text inside the circle (optional, defaults to false)
  * `:size` - Size of the circle: "sm", "md", "lg", "xl" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:track_width` - Width of the circle track: "thin", "normal", "thick" (optional, defaults to "normal")
  * `:class` - Additional CSS classes for the progress container (optional)
  * `:circle_class` - CSS classes for the circle itself (optional)
  * `:label_class` - CSS classes for the label text (optional)
  """
  def progress_circle(assigns) do
    Progress.circle(assigns)
  end

  @doc """
  Renders a multi-step progress indicator.

  This component creates a horizontal step indicator for processes or workflows.

  ## Examples

      <.progress_steps
        steps={["Cart", "Shipping", "Payment", "Confirmation"]}
        current_step={2}
      />

      <.progress_steps
        steps={[
          %{title: "Account", description: "Personal information"},
          %{title: "Profile", description: "Additional details"},
          %{title: "Complete", description: "Review submission"}
        ]}
        current_step={1}
        variant="green"
      />

  ## Options

  * `:steps` - List of step titles or maps with title and description (required)
  * `:current_step` - Index of the current active step (0-based, required)
  * `:orientation` - Direction of the steps: "horizontal" or "vertical" (optional, defaults to "horizontal")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the steps container (optional)
  * `:connector_class` - CSS classes for the connecting lines (optional)
  * `:step_class` - CSS classes for the step indicators (optional)
  """
  def progress_steps(assigns) do
    Progress.steps(assigns)
  end
  @doc """
  Renders a pagination component.

  This component creates a pagination interface with page numbers and
  navigation controls.

  ## Examples

      <.pagination
        current_page={5}
        total_pages={10}
        on_page_change="change_page"
      />

      <.pagination
        current_page={3}
        total_pages={20}
        sibling_count={2}
        show_first_last_buttons={true}
        variant="indigo"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:sibling_count` - Number of sibling pages to show on each side of current page (optional, defaults to 1)
  * `:show_first_last_buttons` - Whether to show first/last page buttons (optional, defaults to false)
  * `:show_ellipsis` - Whether to show ellipsis for hidden pages (optional, defaults to true)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:size` - Size of the pagination: "sm", "md", "lg" (optional, defaults to "md")
  * `:class` - Additional CSS classes for the pagination container (optional)
  * `:item_class` - CSS classes for the page items (optional)
  * `:on_page_change` - Event name or function for page change (optional)
  """
  def pagination(assigns) do
    Pagination.basic(assigns)
  end

  @doc """
  Renders a simple pagination component with prev/next buttons.

  This component creates a simpler pagination interface with just the
  essential navigation controls.

  ## Examples

      <.pagination_simple
        current_page={5}
        total_pages={10}
        on_page_change="change_page"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:show_page_info` - Whether to show current/total page info (optional, defaults to true)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:size` - Size of the pagination: "sm", "md", "lg" (optional, defaults to "md")
  * `:class` - Additional CSS classes for the pagination container (optional)
  * `:on_page_change` - Event name or function for page change (optional)
  """
  def pagination_simple(assigns) do
    Pagination.simple(assigns)
  end

  @doc """
  Renders a "load more" pagination component.

  This component creates a button that loads additional content
  rather than using traditional pagination.

  ## Examples

      <.pagination_load_more
        current_page={2}
        total_pages={5}
        label="Load more results"
        on_load_more="load_more"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:label` - Text for the load more button (optional, defaults to "Load more")
  * `:loading_label` - Text shown when loading (optional, defaults to "Loading...")
  * `:show_progress` - Whether to show loading progress (optional, defaults to false)
  * `:show_remaining` - Whether to show count of remaining items (optional, defaults to false)
  * `:items_per_page` - Number of items loaded per page (optional, required if show_remaining is true)
  * `:total_items` - Total number of items (optional, required if show_remaining is true)
  * `:loading` - Whether loading is in progress (optional, defaults to false)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the container (optional)
  * `:button_class` - CSS classes for the button (optional)
  * `:on_load_more` - Event name or function for loading more (optional)
  """
  def pagination_load_more(assigns) do
    Pagination.load_more(assigns)
  end

  @doc """
  Renders a toast notification container.

  This component creates a container for toast notifications. It's designed to be
  placed at the root of your application layout.

  ## Examples

      <.toast_container />

      <.toast_container
        position="bottom-right"
        transition="slide"
      />

  ## Options

  * `:position` - Position of the toasts: "top-right", "top-left", "bottom-right", "bottom-left", "top-center", "bottom-center" (optional, defaults to "top-right")
  * `:transition` - Animation style: "fade", "slide", "zoom" (optional, defaults to "fade")
  * `:max_toasts` - Maximum number of toasts to show at once (optional, defaults to 5)
  * `:class` - Additional CSS classes for the container (optional)
  """
  def toast_container(assigns) do
    Toast.container(assigns)
  end

  @doc """
  Renders a standalone toast notification.

  This component creates a single toast notification that can be shown directly
  in the UI (not via the notification system).

  ## Examples

      <.toast
        type="success"
        title="Success!"
        message="Your changes have been saved."
      />

      <.toast
        type="error"
        message="Failed to save changes."
        dismissable={true}
      />

  ## Options

  * `:type` - Toast type: "default", "success", "error", "warning", "info" (optional, defaults to "default")
  * `:title` - Toast title text (optional)
  * `:message` - Toast message text (required)
  * `:icon` - HTML string for custom icon (optional, for default type only)
  * `:dismissable` - Whether the toast can be dismissed (optional, defaults to false)
  * `:class` - Additional CSS classes for the toast (optional)
  """
  def toast(assigns) do
    Toast.toast(assigns)
  end

  @doc """
  Renders a button that triggers a toast notification.

  This component creates a button that shows a toast notification
  when clicked.

  ## Examples

      <.toast_trigger
        label="Show Success Toast"
        type="success"
        title="Success!"
        message="Operation completed successfully."
      />

  ## Options

  * `:label` - Button text (required)
  * `:type` - Toast type: "default", "success", "error", "warning", "info" (optional, defaults to "default")
  * `:title` - Toast title text (optional)
  * `:message` - Toast message text (required)
  * `:duration` - Duration in milliseconds before auto-dismiss (optional, defaults to 5000, set to 0 to disable)
  * `:position` - Position override for the toast (optional)
  * `:button_class` - CSS classes for the button (optional)
  * `:button_variant` - Button variant: "primary", "secondary", "outline" (optional, defaults to "primary")
  """
  def toast_trigger(assigns) do
    Toast.trigger(assigns)
  end

  @doc """
  Renders a file uploader component with drag-and-drop functionality.

  This component creates a file upload area that allows users to select files
  either by clicking or by dragging and dropping them.

  ## Examples

      <.file_uploader
        id="document-upload"
        name="document"
        label="Upload Document"
        accept=".pdf,.doc,.docx"
      />

      <.file_uploader
        id="profile-image"
        name="profile_image"
        label="Upload Profile Image"
        accept="image/*"
        max_file_size={5 * 1024 * 1024}
        show_preview={true}
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed file types (optional)
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:multiple` - Whether to allow multiple file selection (optional, defaults to false)
  * `:show_preview` - Whether to show file previews (optional, defaults to false for multiple files, true for single files)
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def file_uploader(assigns) do
    FileUploader.basic(assigns)
  end

  @doc """
  Renders an image uploader component with preview and optional cropping.

  This component creates an uploader specifically for images with
  built-in preview and optional cropping functionality.

  ## Examples

      <.image_uploader
        id="avatar-upload"
        name="avatar"
        label="Upload Avatar"
      />

      <.image_uploader
        id="cover-photo"
        name="cover_photo"
        label="Cover Photo"
        aspect_ratio={16/9}
        allow_cropping={true}
        preview_height="10rem"
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed image types (optional, defaults to "image/*")
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:aspect_ratio` - Fixed aspect ratio for the image (optional)
  * `:allow_cropping` - Whether to enable image cropping (optional, defaults to false)
  * `:preview_height` - Height of the preview area (optional, defaults to "12rem")
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def image_uploader(assigns) do
    FileUploader.image(assigns)
  end

  @doc """
  Renders a multi-file uploader component with progress tracking.

  This component creates an uploader that handles multiple files with
  individual progress tracking for each file.

  ## Examples

      <.multi_file_uploader
        id="gallery-upload"
        name="gallery"
        label="Upload Images"
        accept="image/*"
        max_files={5}
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed file types (optional)
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:max_files` - Maximum number of files that can be selected (optional)
  * `:show_preview` - Whether to show file previews (optional, defaults to true)
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def multi_file_uploader(assigns) do
    FileUploader.multi(assigns)
  end

  @doc """
  Renders a grid gallery component.

  This component creates a responsive grid layout for displaying multiple images.

  ## Examples

      <.image_gallery
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1"},
          %{src: "/images/photo2.jpg", alt: "Photo 2"},
          %{src: "/images/photo3.jpg", alt: "Photo 3"}
        ]}
      />

      <.image_gallery
        images={@photos}
        columns={3}
        gap="4"
        enable_lightbox={true}
      />

  ## Options

  * `:images` - List of image maps with src and alt keys (required)
  * `:columns` - Number of columns in the grid: 1, 2, 3, 4, 5, 6 (optional, defaults to 3)
  * `:gap` - Gap size between grid items: "1", "2", "4", "6", "8" (optional, defaults to "4")
  * `:aspect_ratio` - Image aspect ratio: "square", "video", "portrait" (optional, defaults to "square")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:enable_lightbox` - Whether to enable lightbox preview (optional, defaults to false)
  * `:class` - Additional CSS classes for the gallery container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def image_gallery(assigns) do
    Gallery.grid(assigns)
  end

  @doc """
  Renders a masonry gallery component.

  This component creates a masonry layout for displaying images of varying heights.

  ## Examples

      <.image_gallery_masonry
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1", height: "md"},
          %{src: "/images/photo2.jpg", alt: "Photo 2", height: "lg"},
          %{src: "/images/photo3.jpg", alt: "Photo 3", height: "sm"}
        ]}
      />

  ## Options

  * `:images` - List of image maps with src, alt, and optional height keys (required)
  * `:columns` - Number of columns in the layout: 1, 2, 3, 4 (optional, defaults to 3)
  * `:gap` - Gap size between items: "1", "2", "4", "6", "8" (optional, defaults to "4")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:enable_lightbox` - Whether to enable lightbox preview (optional, defaults to false)
  * `:class` - Additional CSS classes for the gallery container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def image_gallery_masonry(assigns) do
    Gallery.masonry(assigns)
  end


  @doc """
  Renders a carousel gallery component.

  This component creates a slideshow carousel for displaying images.

  ## Examples

      <.image_carousel
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1"},
          %{src: "/images/photo2.jpg", alt: "Photo 2"},
          %{src: "/images/photo3.jpg", alt: "Photo 3"}
        ]}
      />

      <.image_carousel
        images={@photos}
        autoplay={true}
        autoplay_speed={3000}
        show_thumbnails={true}
      />

  ## Options

  * `:images` - List of image maps with src and alt keys (required)
  * `:aspect_ratio` - Image aspect ratio: "square", "video", "portrait" (optional, defaults to "video")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:show_indicators` - Whether to show slide indicators (optional, defaults to true)
  * `:show_arrows` - Whether to show navigation arrows (optional, defaults to true)
  * `:show_thumbnails` - Whether to show thumbnail navigation (optional, defaults to false)
  * `:autoplay` - Whether to autoplay the carousel (optional, defaults to false)
  * `:autoplay_speed` - Autoplay speed in milliseconds (optional, defaults to 5000)
  * `:class` - Additional CSS classes for the carousel container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def image_carousel(assigns) do
    Gallery.carousel(assigns)
  end

  @doc """
  Renders a data table component.

  This component creates a table for displaying tabular data with
  optional sorting, filtering, and pagination.

  ## Examples

      <.data_table
        id="users-table"
        columns={[
          %{key: "name", label: "Name", sortable: true},
          %{key: "email", label: "Email"},
          %{key: "role", label: "Role", filterable: true}
        ]}
        data={@users}
      />

      <.data_table
        id="products-table"
        columns={@columns}
        data={@products}
        sortable={true}
        filterable={true}
        paginate={true}
        per_page={10}
      />

  ## Options

  * `:id` - Unique identifier for the table (required)
  * `:columns` - List of column configuration maps (required)
  * `:data` - List of data items to display in the table (required)
  * `:sortable` - Whether sorting is enabled globally (optional, defaults to false)
  * `:filterable` - Whether filtering is enabled globally (optional, defaults to false)
  * `:paginate` - Whether pagination is enabled (optional, defaults to false)
  * `:per_page` - Number of items per page when pagination is enabled (optional, defaults to 10)
  * `:selectable` - Whether rows can be selected with checkboxes (optional, defaults to false)
  * `:class` - Additional CSS classes for the table container (optional)
  * `:table_class` - CSS classes for the table element (optional)
  * `:empty_state` - Content to display when there are no rows to show (optional)
  * `:row_click` - Event name or function to call when a row is clicked (optional)
  * `:on_selection_change` - Event name or function to call when selection changes (optional)
  """
  def data_table(assigns) do
    DataTable.basic(assigns)
  end

  @doc """
  Renders a data table with expandable rows.

  This component creates a table where rows can be expanded to show additional details.

  ## Examples

      <.data_table_expandable
        id="orders-table"
        columns={[
          %{key: "order_id", label: "Order ID"},
          %{key: "customer", label: "Customer"},
          %{key: "date", label: "Date"},
          %{key: "status", label: "Status"}
        ]}
        data={@orders}
      >
        <:expanded_row :let={row}>
          <div class="p-4 bg-gray-50">
            <h3 class="font-medium">Order Details</h3>
            <p>Items: <%= row.items.length %></p>
            <p>Total: $<%= row.total %></p>
          </div>
        </:expanded_row>
      </.data_table_expandable>

  ## Options

  * `:id` - Unique identifier for the table (required)
  * `:columns` - List of column configuration maps (required)
  * `:data` - List of data items to display in the table (required)
  * `:sortable` - Whether sorting is enabled globally (optional, defaults to false)
  * `:filterable` - Whether filtering is enabled globally (optional, defaults to false)
  * `:paginate` - Whether pagination is enabled (optional, defaults to false)
  * `:per_page` - Number of items per page when pagination is enabled (optional, defaults to 10)
  * `:class` - Additional CSS classes for the table container (optional)
  * `:table_class` - CSS classes for the table element (optional)
  * `:empty_state` - Content to display when there are no rows to show (optional)
  * `:expanded_row` - Slot for customizing the expanded row content (required)
  """
  def data_table_expandable(assigns) do
    DataTable.expandable(assigns)
  end

  @doc """
  Renders a date picker component.

  This component creates a date picker for selecting a single date.

  ## Examples

      <.date_picker
        id="event-date"
        name="event[date]"
        label="Event Date"
      />

      <.date_picker
        id="appointment-date"
        name="appointment[date]"
        label="Appointment Date"
        min="2023-01-01"
        max="2023-12-31"
        format="MM/DD/YYYY"
        value="2023-06-15"
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute for the input (optional, defaults to ID)
  * `:label` - Label text for the input (optional)
  * `:value` - Current date value in ISO format (YYYY-MM-DD) (optional)
  * `:min` - Minimum selectable date in ISO format (optional)
  * `:max` - Maximum selectable date in ISO format (optional)
  * `:format` - Date display format: "YYYY-MM-DD", "MM/DD/YYYY", "DD/MM/YYYY" (optional, defaults to "YYYY-MM-DD")
  * `:placeholder` - Placeholder text when no date is selected (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:disabled` - Whether the input is disabled (optional, defaults to false)
  * `:required` - Whether the input is required (optional, defaults to false)
  * `:class` - Additional CSS classes for the container (optional)
  * `:input_class` - CSS classes for the input element (optional)
  * `:calendar_class` - CSS classes for the calendar dropdown (optional)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  """
  def date_picker(assigns) do
    DatePicker.basic(assigns)
  end

  @doc """
  Renders a date range picker component.

  This component creates a date picker for selecting a start and end date range.

  ## Examples

      <.date_range_picker
        id="date-range"
        name_start="start_date"
        name_end="end_date"
        label="Date Range"
      />

      <.date_range_picker
        id="booking"
        name_start="booking[start_date]"
        name_end="booking[end_date]"
        label="Booking Period"
        value_start="2023-06-15"
        value_end="2023-06-30"
        min="2023-01-01"
        max="2023-12-31"
      />

  ## Options

  * `:id` - The ID prefix for the input elements (required)
  * `:name_start` - The name attribute for the start date input (required)
  * `:name_end` - The name attribute for the end date input (required)
  * `:label` - Label text for the input (optional)
  * `:value_start` - Current start date value in ISO format (optional)
  * `:value_end` - Current end date value in ISO format (optional)
  * `:min` - Minimum selectable date in ISO format (optional)
  * `:max` - Maximum selectable date in ISO format (optional)
  * `:format` - Date display format: "YYYY-MM-DD", "MM/DD/YYYY", "DD/MM/YYYY" (optional, defaults to "YYYY-MM-DD")
  * `:placeholder_start` - Placeholder text for start date input (optional)
  * `:placeholder_end` - Placeholder text for end date input (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:disabled` - Whether the inputs are disabled (optional, defaults to false)
  * `:required` - Whether the inputs are required (optional, defaults to false)
  * `:class` - Additional CSS classes for the container (optional)
  * `:input_class` - CSS classes for the input elements (optional)
  * `:calendar_class` - CSS classes for the calendar dropdown (optional)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  """
  def date_range_picker(assigns) do
    DatePicker.range(assigns)
  end
end
