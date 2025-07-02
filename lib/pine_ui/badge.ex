defmodule PineUiPhoenix.Badge do
  @moduledoc """
  Provides badge components for status indicators.

  The Badge module offers several variants for indicating status:
  - `base/1` - Simple colored badge
  - `dot/1` - Badge with a status dot
  - `dismissible/1` - Badge that can be dismissed
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic badge component.

  ## Examples

      <.base variant="success">Completed</.base>

      <.base variant="warning" class="ml-2">Pending</.base>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  * `:icon` - HTML string for an icon to display before text (optional)
  """
  def base(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <span class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{@class}"}>
      <%= if Map.get(assigns, :icon, nil) do %>
        <span class="mr-1.5 -ml-0.5 flex-shrink-0"><%= @icon %></span>
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

  @doc """
  Renders a badge with a status dot.

  ## Examples

      <.dot variant="success">Active</.dot>

      <.dot variant="danger" class="ml-2">Offline</.dot>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  """
  def dot(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <span class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{@class}"}>
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

  @doc """
  Renders a dismissible badge.

  ## Examples

      <.dismissible variant="info">New Feature</.dismissible>

      <.dismissible variant="purple" class="ml-2">Beta</.dismissible>

  ## Options

  * `:variant` - Color variant: "success", "warning", "danger", "info", "purple", "pink", "indigo", or "default" (gray)
  * `:class` - Additional CSS classes (optional)
  """
  def dismissible(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <span
      x-data="{ show: true }"
      x-show="show"
      x-transition:leave="transition ease-in duration-100"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      class={"inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{get_color_classes(@variant)} #{@class}"}>
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
