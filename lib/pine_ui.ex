defmodule PineUi do
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
   <PineUi.text_animation_blow text="Welcome to Pine UI" />

   <PineUi.card title="Getting Started">
     <p>Pine UI makes it easy to build interactive Phoenix applications.</p>

     <div class="mt-4 flex space-x-2">
       <PineUi.button_primary>
         Get Started
       </PineUi.button_primary>

       <PineUi.button_secondary>
         Documentation
       </PineUi.button_secondary>
     </div>
   </PineUi.card>

   <PineUi.typing_effect
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
end
