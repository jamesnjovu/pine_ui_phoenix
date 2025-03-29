defmodule PineUi.Badge do
  @moduledoc false
  use Phoenix.Component

  def base(assigns) do
    ~H"""
    <span class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{Map.get(assigns, :class, "")}"}>
      <%= if Map.get(assigns, :icon, nil) do %>
        <span class="mr-1.5 -ml-0.5 flex-shrink-0"><%= Map.get(assigns, :icon) %></span>
      <% end %>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp get_color_classes(variant) do
    case variant do
      "success" -> "bg-green-100 text-green-800"
      "warning" -> "bg-yellow-100 text-yellow-800"
      "danger" -> "bg-red-100 text-red-800"
      "info" -> "bg-blue-100 text-blue-800"
      "purple" -> "bg-purple-100 text-purple-800"
      "pink" -> "bg-pink-100 text-pink-800"
      "indigo" -> "bg-indigo-100 text-indigo-800"
      _ -> "bg-gray-100 text-gray-800" # default
    end
  end

  def dot(assigns) do
    ~H"""
    <span class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{Map.get(assigns, :class, "")}"}>
      <svg class={"mr-1.5 h-2 w-2 flex-shrink-0 #{get_dot_color(@variant)}"} fill="currentColor" viewBox="0 0 8 8">
        <circle cx="4" cy="4" r="3" />
      </svg>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp get_dot_color(variant) do
    case variant do
      "success" -> "text-green-500"
      "warning" -> "text-yellow-500"
      "danger" -> "text-red-500"
      "info" -> "text-blue-500"
      "purple" -> "text-purple-500"
      "pink" -> "text-pink-500"
      "indigo" -> "text-indigo-500"
      _ -> "text-gray-500" # default
    end
  end

  def dismissible(assigns) do
    ~H"""
    <span
      x-data="{ show: true }"
      x-show="show"
      x-transition:leave="transition ease-in duration-100"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{Map.get(assigns, :class, "")}"}>
      <%= render_slot(@inner_block) %>
      <button
        type="button"
        x-on:click="show = false"
        class="ml-0.5 -mr-0.5 inline-flex h-4 w-4 flex-shrink-0 items-center justify-center rounded-full focus:outline-none focus:text-gray-500">
        <span class="sr-only">Remove</span>
        <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
          <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
        </svg>
      </button>
    </span>
    """
  end
end
