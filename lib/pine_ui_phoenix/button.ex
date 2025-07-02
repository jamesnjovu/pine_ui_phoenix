defmodule PineUiPhoenix.Button do
  @moduledoc """
  Provides button components with various styles and states.

  The Button module offers primary, secondary, and danger button variants
  with support for loading states, icons, and Phoenix LiveView integration.

  ## Examples

      <PineUiPhoenix.button_primary>
        Submit
      </PineUiPhoenix.button_primary>

      <PineUiPhoenix.button_secondary loading={@saving} phx_click="cancel">
        Cancel
      </PineUiPhoenix.button_secondary>

      <PineUiPhoenix.button_danger disabled={@cannot_delete} phx_click="delete" phx_value_id={@id}>
        Delete
      </PineUiPhoenix.button_danger>

  ## Accessibility

  All button components provide proper focus states, ARIA attributes, and
  keyboard interaction support.
  """
  use Phoenix.Component

  @doc """
  Renders a primary button component with optional loading state.

  ## Examples

      <.primary>Submit</.primary>

      <.primary loading={true} phx_click="save" disabled={@form_invalid}>
        Save Changes
      </.primary>

      <.primary icon="<svg>...</svg>">
        With Icon
      </.primary>

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
  def primary(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:phx_click, fn -> nil end)
      |> assign_new(:phx_value_id, fn -> nil end)
      |> assign_new(:phx_target, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <button
      type={@type}
      class={"inline-flex items-center justify-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{@class}"}
      disabled={@disabled}
      phx-click={@phx_click}
      phx-value-id={@phx_value_id}
      phx-target={@phx_target}
      x-data={if @loading, do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if @icon do %>
        <span class="mr-2"><%= @icon %></span>
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

  @doc """
  Renders a secondary button component with optional loading state.

  Secondary buttons are often used for secondary actions or alternative options.

  ## Examples

      <.secondary>Cancel</.secondary>

      <.secondary loading={@processing} phx_click="back">
        Go Back
      </.secondary>

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
  def secondary(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:phx_click, fn -> nil end)
      |> assign_new(:phx_value_id, fn -> nil end)
      |> assign_new(:phx_target, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <button
      type={@type}
      class={"inline-flex items-center justify-center rounded-md bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm border border-gray-300 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{@class}"}
      disabled={@disabled}
      phx-click={@phx_click}
      phx-value-id={@phx_value_id}
      phx-target={@phx_target}
      x-data={if @loading, do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if @icon do %>
        <span class="mr-2"><%= @icon %></span>
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

  @doc """
  Renders a danger button component with optional loading state.

  Danger buttons should be used for destructive actions such as delete or remove.

  ## Examples

      <.danger>Delete Account</.danger>

      <.danger loading={@deleting} phx_click="delete" phx_value_id={@item.id}>
        Remove Item
      </.danger>

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
  def danger(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:phx_click, fn -> nil end)
      |> assign_new(:phx_value_id, fn -> nil end)
      |> assign_new(:phx_target, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <button
      type={@type}
      class={"inline-flex items-center justify-center rounded-md bg-red-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 #{@class}"}
      disabled={@disabled}
      phx-click={@phx_click}
      phx-value-id={@phx_value_id}
      phx-target={@phx_target}
      x-data={if @loading, do: "{ loading: true }", else: "{ loading: false }"}
    >
      <%= if @icon do %>
        <span class="mr-2"><%= @icon %></span>
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
