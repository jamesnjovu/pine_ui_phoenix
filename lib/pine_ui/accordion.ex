defmodule PineUi.Accordion do
  @moduledoc """
  Provides accordion components for expandable/collapsible content sections.

  The Accordion module offers two main variants:
  - `basic/1` - Standard accordion component with single panel
  - `group/1` - Group of related accordion panels where only one can be open at a time
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic accordion component.

  This component creates a collapsible section that can be toggled open/closed.
  It uses AlpineJS for the toggle functionality.

  ## Examples

      <.basic title="Frequently Asked Questions">
        <p>This content can be expanded or collapsed.</p>
      </.basic>

      <.basic title="Section Title" subtitle="Additional details" open={true}>
        <div class="space-y-4">
          <p>Initially expanded content.</p>
          <p>Multiple paragraphs can be included.</p>
        </div>
      </.basic>

  ## Options

  * `:title` - Accordion panel header text (required)
  * `:subtitle` - Optional subheading text below the title (optional)
  * `:open` - Whether the accordion is expanded initially (optional, defaults to false)
  * `:class` - Additional CSS classes for the accordion container (optional)
  * `:header_class` - Additional CSS classes for the header section (optional)
  * `:content_class` - Additional CSS classes for the content section (optional)
  * `:icon` - Custom icon element to replace default chevron (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:header_class, fn -> "" end)
      |> assign_new(:content_class, fn -> "" end)
      |> assign_new(:open, fn -> false end)
      |> assign_new(:subtitle, fn -> nil end)

    ~H"""
    <div
      class={"border border-gray-200 rounded-md overflow-hidden #{@class}"}
      x-data={"{ open: #{@open} }"}
    >
      <div
        class={"flex justify-between items-center p-4 cursor-pointer bg-white hover:bg-gray-50 transition-colors #{@header_class}"}
        x-on:click="open = !open"
        aria-expanded="x-bind:aria-expanded='open'"
        aria-controls="accordion-content"
      >
        <div>
          <h3 class="text-base font-medium text-gray-900"><%= @title %></h3>
          <%= if @subtitle do %>
            <p class="mt-1 text-sm text-gray-500"><%= @subtitle %></p>
          <% end %>
        </div>
        <div>
          <%= if Map.get(assigns, :icon, nil) do %>
            <div x-bind:class="{ 'transform rotate-180': open }">
              <%= @icon %>
            </div>
          <% else %>
            <svg
              x-bind:class="{ 'transform rotate-180': open }"
              class="h-5 w-5 text-gray-500 transition-transform duration-200"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          <% end %>
        </div>
      </div>
      <div
        id="accordion-content"
        x-show="open"
        x-collapse
        x-cloak
        class={"p-4 bg-white border-t border-gray-200 #{@content_class}"}
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Renders an accordion group with multiple accordion panels.

  This component creates a group of related accordion panels where only
  one panel can be expanded at a time.

  ## Examples

      <.group>
        <:panel title="Section 1">
          <p>Content for section 1</p>
        </:panel>
        <:panel title="Section 2">
          <p>Content for section 2</p>
        </:panel>
        <:panel title="Section 3" active={true}>
          <p>This section is open by default</p>
        </:panel>
      </.group>

  ## Options

  * `:class` - Additional CSS classes for the accordion group container (optional)
  * `:panel_class` - Additional CSS classes applied to each panel (optional)
  * `:header_class` - Additional CSS classes for each panel header (optional)
  * `:content_class` - Additional CSS classes for each panel content (optional)
  * `:panel` - Panel slots with the following attributes:
    * `:title` - Panel header text (required)
    * `:subtitle` - Optional subheading text below the title (optional)
    * `:active` - Whether this panel is expanded initially (optional, default to false)
    * `:icon` - Custom icon element to replace default chevron (optional)
  """
  def group(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:panel_class, fn -> "" end)
      |> assign_new(:header_class, fn -> "" end)
      |> assign_new(:content_class, fn -> "" end)

    ~H"""
    <div
      class={"space-y-2 #{@class}"}
      x-data={"{ activePanel: #{get_active_panel(assigns)} }"}
    >
      <%= for {panel, index} <- Enum.with_index(@panel) do %>
        <div
          class={"border border-gray-200 rounded-md overflow-hidden #{@panel_class}"}
        >
          <div
            class={"flex justify-between items-center p-4 cursor-pointer bg-white hover:bg-gray-50 transition-colors #{@header_class}"}
            x-on:click={"activePanel = activePanel === #{index} ? null : #{index}"}
            aria-expanded={"x-bind:aria-expanded='activePanel === #{index}'"}
            aria-controls={"panel-content-#{index}"}
          >
            <div>
              <h3 class="text-base font-medium text-gray-900"><%= panel.title %></h3>
              <%= if Map.get(panel, :subtitle, nil) do %>
                <p class="mt-1 text-sm text-gray-500"><%= panel.subtitle %></p>
              <% end %>
            </div>
            <div>
              <%= if Map.get(panel, :icon, nil) do %>
                <div x-bind:class={"{ 'transform rotate-180': activePanel === #{index}}"}>
                  <%= panel.icon %>
                </div>
              <% else %>
                <svg
                  x-bind:class={"{ 'transform rotate-180': activePanel === #{index}}"}
                  class="h-5 w-5 text-gray-500 transition-transform duration-200"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              <% end %>
            </div>
          </div>
          <div
            id={"panel-content-#{index}"}
            x-show={"activePanel === #{index}"}
            x-collapse
            x-cloak
            class={"p-4 bg-white border-t border-gray-200 #{@content_class}"}
          >
            <%= render_slot(panel) %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_active_panel(assigns) do
    case Enum.find_index(assigns.panel, &Map.get(&1, :active, false)) do
      nil -> "null"
      index -> index
    end
  end
end
