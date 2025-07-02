defmodule PineUiPhoenix.Card do
  @moduledoc """
  Provides card components for organizing content with various behaviors.

  The Card module offers three main variants:

  - `basic/1` - Simple card with title, subtitle, content area, and optional footer
  - `interactive/1` - Card with hover animation effects
  - `collapsible/1` - Expandable/collapsible card with toggle functionality

  ## Examples

      <PineUi.card title="User Profile" subtitle="Personal information">
        <p>Card content here</p>
      </PineUi.card>

      <PineUi.card_interactive>
        <p>This card has hover effects</p>
      </PineUi.card_interactive>

      <PineUi.card_collapsible title="Click to expand" open={false}>
        <p>This content can be hidden</p>
      </PineUi.card_collapsible>

  ## Styling

  Cards use TailwindCSS for styling and can be customized using the `class` parameter.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic card component.

  ## Examples

      <.basic title="Card Title">
        <p>Content goes here</p>
      </.basic>

      <.basic title="Card with Footer" subtitle="With explanation" footer="Last updated: Yesterday">
        <p>Content goes here</p>
      </.basic>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:padded, fn -> true end)

    ~H"""
    <div class={"overflow-hidden bg-white shadow rounded-lg #{@class}"}>
      <%= if Map.get(assigns, :title, nil) || Map.get(assigns, :subtitle, nil) do %>
        <div class="px-4 py-5 sm:px-6">
          <%= if Map.get(assigns, :title, nil) do %>
            <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
          <% end %>
          <%= if Map.get(assigns, :subtitle, nil) do %>
            <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @subtitle %></p>
          <% end %>
        </div>
      <% end %>
      <div class={get_body_padding(@padded)}>
        <%= render_slot(@inner_block) %>
      </div>
      <%= if Map.get(assigns, :footer, nil) do %>
        <div class="bg-gray-50 px-4 py-4 sm:px-6">
          <%= @footer %>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_body_padding(true), do: "px-4 py-5 sm:p-6"
  defp get_body_padding(false), do: ""

  @doc """
  Renders an interactive card component with hover effects.

  This card variant adds subtle animation effects when hovered,
  making it ideal for clickable cards or emphasizing important content.

  ## Examples

      <.interactive>
        <p>Hover over me to see effects</p>
      </.interactive>

      <.interactive title="Interactive Card" subtitle="With animations">
        <p>Content with hover effects</p>
      </.interactive>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def interactive(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:padded, fn -> true end)

    ~H"""
    <div
      class={"overflow-hidden bg-white shadow rounded-lg transition-all duration-200 ease-in-out #{@class}"}
      x-data="{ hovered: false }"
      x-on:mouseenter="hovered = true"
      x-on:mouseleave="hovered = false"
      x-bind:class="{ 'transform shadow-md -translate-y-1': hovered }"
    >
      <%= if Map.get(assigns, :title, nil) || Map.get(assigns, :subtitle, nil) do %>
        <div class="px-4 py-5 sm:px-6">
          <%= if Map.get(assigns, :title, nil) do %>
            <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
          <% end %>
          <%= if Map.get(assigns, :subtitle, nil) do %>
            <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @subtitle %></p>
          <% end %>
        </div>
      <% end %>
      <div class={get_body_padding(@padded)}>
        <%= render_slot(@inner_block) %>
      </div>
      <%= if Map.get(assigns, :footer, nil) do %>
        <div class="bg-gray-50 px-4 py-4 sm:px-6">
          <%= @footer %>
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a collapsible card component with expand/collapse functionality.

  This card can be toggled between expanded and collapsed states by clicking
  on the header. Uses AlpineJS for the toggle functionality.

  ## Examples

      <.collapsible title="Click to toggle">
        <p>This content can be hidden</p>
      </.collapsible>

      <.collapsible title="Initially expanded" open={true}>
        <p>This content is visible by default</p>
      </.collapsible>

  ## Options

  * `:title` - Card title text (optional)
  * `:subtitle` - Card subtitle text (optional)
  * `:footer` - Footer content (optional)
  * `:padded` - Whether to add padding to the body (optional, defaults to true)
  * `:open` - Whether the card is expanded on initial render (optional, defaults to false)
  * `:class` - Additional CSS classes for the card container (optional)
  """
  def collapsible(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:padded, fn -> true end)
      |> assign_new(:open, fn -> false end)

    ~H"""
    <div
      class={"overflow-hidden bg-white shadow rounded-lg #{@class}"}
      x-data="{ open: #{@open} }"
    >
      <div
        class="px-4 py-5 sm:px-6 flex justify-between items-center cursor-pointer"
        x-on:click="open = !open"
      >
        <div>
          <%= if Map.get(assigns, :title, nil) do %>
            <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
          <% end %>
          <%= if Map.get(assigns, :subtitle, nil) do %>
            <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @subtitle %></p>
          <% end %>
        </div>
        <div>
          <svg
            x-bind:class="{ 'transform rotate-180': open }"
            class="h-5 w-5 text-gray-500 transition-transform duration-200"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </div>
      </div>
      <div
        x-show="open"
        x-collapse
        x-cloak
        class={get_body_padding(@padded)}
      >
        <%= render_slot(@inner_block) %>
      </div>
      <%= if Map.get(assigns, :footer, nil) do %>
        <div class="bg-gray-50 px-4 py-4 sm:px-6" x-show="open" x-collapse x-cloak>
          <%= @footer %>
        </div>
      <% end %>
    </div>
    """
  end
end
