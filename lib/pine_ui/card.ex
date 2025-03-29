defmodule PineUi.Card do
  @moduledoc false
  use Phoenix.Component

  def basic(assigns) do
    ~H"""
    <div class={"overflow-hidden bg-white shadow rounded-lg #{Map.get(assigns, :class, "")}"}>
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
      <div class={get_body_padding(Map.get(assigns, :padded, true))}>
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

  def interactive(assigns) do
    ~H"""
    <div
      class={"overflow-hidden bg-white shadow rounded-lg transition-all duration-200 ease-in-out #{Map.get(assigns, :class, "")}"}
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
      <div class={get_body_padding(Map.get(assigns, :padded, true))}>
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

  def collapsible(assigns) do
    ~H"""
    <div
      class={"overflow-hidden bg-white shadow rounded-lg #{Map.get(assigns, :class, "")}"}
      x-data="{ open: #{Map.get(assigns, :open, "false")} }"
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
        class={get_body_padding(Map.get(assigns, :padded, true))}
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
