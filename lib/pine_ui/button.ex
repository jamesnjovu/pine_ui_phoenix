defmodule PineUi.Button do
  @moduledoc false
  use Phoenix.Component

  def primary(assigns) do
    ~H"""
    <button
      type={Map.get(assigns, :type, "button")}
      class={"inline-flex items-center justify-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{Map.get(assigns, :class, "")}"}
      disabled={Map.get(assigns, :disabled, false)}
      phx-click={Map.get(assigns, :phx_click, nil)}
      phx-value-id={Map.get(assigns, :phx_value_id, nil)}
      phx-target={Map.get(assigns, :phx_target, nil)}
      x-data={if Map.get(assigns, :loading, false), do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if Map.get(assigns, :icon, nil) do %>
        <span class="mr-2"><%= Map.get(assigns, :icon) %></span>
      <% end %>

      <span x-show="!loading">
        <%= render_slot(@inner_block) %>
      </span>

      <span x-show="loading" x-cloak class="flex items-center">
        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Loading...
      </span>
    </button>
    """
  end

  def secondary(assigns) do
    ~H"""
    <button
      type={Map.get(assigns, :type, "button")}
      class={"inline-flex items-center justify-center rounded-md bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm border border-gray-300 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{Map.get(assigns, :class, "")}"}
      disabled={Map.get(assigns, :disabled, false)}
      phx-click={Map.get(assigns, :phx_click, nil)}
      phx-value-id={Map.get(assigns, :phx_value_id, nil)}
      phx-target={Map.get(assigns, :phx_target, nil)}
      x-data={if Map.get(assigns, :loading, false), do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if Map.get(assigns, :icon, nil) do %>
        <span class="mr-2"><%= Map.get(assigns, :icon) %></span>
      <% end %>

      <span x-show="!loading">
        <%= render_slot(@inner_block) %>
      </span>

      <span x-show="loading" x-cloak class="flex items-center">
        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-gray-700" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Loading...
      </span>
    </button>
    """
  end

  def danger(assigns) do
    ~H"""
    <button
      type={Map.get(assigns, :type, "button")}
      class={"inline-flex items-center justify-center rounded-md bg-red-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 #{Map.get(assigns, :class, "")}"}
      disabled={Map.get(assigns, :disabled, false)}
      phx-click={Map.get(assigns, :phx_click, nil)}
      phx-value-id={Map.get(assigns, :phx_value_id, nil)}
      phx-target={Map.get(assigns, :phx_target, nil)}
      x-data={if Map.get(assigns, :loading, false), do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if Map.get(assigns, :icon, nil) do %>
        <span class="mr-2"><%= Map.get(assigns, :icon) %></span>
      <% end %>

      <span x-show="!loading">
        <%= render_slot(@inner_block) %>
      </span>

      <span x-show="loading" x-cloak class="flex items-center">
        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Loading...
      </span>
    </button>
    """
  end
end
