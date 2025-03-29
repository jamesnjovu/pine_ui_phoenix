# Pine UI

[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)]()
[![Phoenix Framework](https://img.shields.io/badge/Phoenix_Framework-FD4F00?style=for-the-badge&logo=elixir&logoColor=white)]()
[![AlpineJS](https://img.shields.io/badge/AlpineJS-8BC0D0?style=for-the-badge&logo=alpinejs&logoColor=white)]()

A comprehensive library of interactive UI components for Phoenix applications built with AlpineJS and TailwindCSS.

## Installation

Add Pine UI to your `mix.exs`:

```elixir
def deps do
  [
    {:pine_ui_phoenix, "~> 0.1.1"}
  ]
end
```

After running `mix deps.get`, make sure your project includes:

1. **TailwindCSS** - For component styling
2. **AlpineJS** - For component interactivity

## Usage

Pine UI provides a collection of Phoenix Components that can be used in your HEEx templates. Each component is designed to be customizable and works well with Phoenix LiveView.

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

## Available Components

### Text & Animation

- `typing_effect/1` - Creates a typing animation with multiple text items
- `text_animation_blow/1` - Letter-by-letter animation that scales in
- `text_animation_fade/1` - Letter-by-letter fade-in animation

### Interactive Elements

- `tooltip/1` - Interactive tooltip with different positions (top, left, right)
- `button_primary/1` - Primary action button with loading state
- `button_secondary/1` - Secondary action button with loading state
- `button_danger/1` - Danger action button with loading state

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

## Component Examples

### Text Animation

```heex
<PineUi.typing_effect
  text_list={Poison.encode!(["First message", "Second message"])}
  class="flex justify-center py-8"
  text_class="text-2xl font-black text-blue-600"
/>

<PineUi.text_animation_blow text="Scale In Animation" />

<PineUi.text_animation_fade text="Fade In Animation" />
```

### Buttons

```heex
<PineUi.button_primary phx_click="save">
  Save Changes
</PineUi.button_primary>

<PineUi.button_secondary loading={@loading}>
  Loading Example
</PineUi.button_secondary>

<PineUi.button_danger phx_click="delete" phx_value_id={@item.id}>
  Delete
</PineUi.button_danger>
```

### Cards

```heex
<PineUi.card title="Basic Card" subtitle="Card description">
  <p>Content goes here</p>
</PineUi.card>

<PineUi.card_interactive title="Interactive Card">
  <p>This card has hover effects</p>
</PineUi.card_interactive>

<PineUi.card_collapsible title="Collapsible Card" open={true}>
  <p>This content can be collapsed</p>
</PineUi.card_collapsible>
```

### Form Inputs

```heex
<PineUi.text_input
  id="email"
  label="Email Address"
  type="email"
  placeholder="you@example.com"
/>

<PineUi.text_input_with_icon
  id="search"
  placeholder="Search..."
  icon={~H"<svg class='h-5 w-5 text-gray-400' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'><path fill-rule='evenodd' d='M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z' clip-rule='evenodd'/></svg>"}
/>

<PineUi.textarea
  id="description"
  label="Description"
  rows={6}
  placeholder="Enter details..."
/>
```

### Select Inputs

```heex
<PineUi.select
  id="country"
  label="Country"
  options={[{"us", "United States"}, {"ca", "Canada"}, {"mx", "Mexico"}]}
  selected="us"
/>

<PineUi.select_grouped
  id="continent"
  label="Country"
  option_groups={[
    {"North America", [{"us", "United States"}, {"ca", "Canada"}]},
    {"Europe", [{"fr", "France"}, {"de", "Germany"}]}
  ]}
/>

<PineUi.select_searchable
  id="country"
  label="Country"
  options={[{"us", "United States"}, {"ca", "Canada"}, {"mx", "Mexico"}]}
  placeholder="Search countries..."
/>
```

### Badges

```heex
<PineUi.badge variant="success">
  Completed
</PineUi.badge>

<PineUi.badge_dot variant="warning">
  Pending
</PineUi.badge_dot>

<PineUi.badge_dismissible variant="info">
  New Feature
</PineUi.badge_dismissible>
```

## Roadmap

Future components and enhancements:

- [ ] Alert component variants
- [ ] Avatar with status indicators
- [ ] Toggle/switch component
- [ ] Tabs component
- [ ] Dropdown menu
- [ ] Table component with sorting and pagination
- [ ] Accordion component
- [ ] Progress bar
- [ ] Modal dialog
- [ ] Date picker

## License

This project is licensed under the MIT License - see the LICENSE file for details.
