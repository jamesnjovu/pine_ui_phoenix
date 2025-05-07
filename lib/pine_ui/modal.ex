defmodule PineUi.Modal do
  @moduledoc """
  Provides modal dialog components for displaying content that requires user attention.

  The Modal module offers different variants:
  - `basic/1` - Standard modal dialog with customizable size
  - `full_screen/1` - Full screen modal that covers the entire viewport
  - `side/1` - Slide-in modal that appears from the side of the screen
  """
  use Phoenix.Component

  @doc """
  Renders a basic modal dialog component.

  This component creates a modal dialog that appears centered on the screen.
  It includes a backdrop overlay, title, optional close button, and content area.

  ## Examples

      <.basic id="confirm-modal" title="Confirm Action">
        <p>Are you sure you want to perform this action?</p>
        <div class="mt-4 flex justify-end space-x-3">
          <button x-on:click="show = false" class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-md">Cancel</button>
          <button x-on:click="show = false" class="px-4 py-2 text-sm text-white bg-indigo-600 rounded-md">Confirm</button>
        </div>
      </.basic>

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
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:show_close_button, fn -> true end)
      |> assign_new(:max_width, fn -> "lg" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:header_class, fn -> "" end)
      |> assign_new(:content_class, fn -> "" end)
      |> assign_new(:overlay_class, fn -> "" end)
      |> assign_new(:focus_element, fn -> nil end)

    ~H"""
    <div
      id={@id}
      x-data="{ show: false }"
      x-show="show"
      x-on:open-modal.window={"if ($event.detail.id === '#{@id}') { show = true; $nextTick(() => { #{if @focus_element, do: "$refs.#{@focus_element}.focus()", else: "focusFirstElement()"} }) }"}
      x-on:close-modal.window={"if ($event.detail.id === '#{@id}') show = false"}
      x-on:keydown.escape.window="show = false"
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0"
      x-transition:enter-end="opacity-100"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      x-cloak
      class="fixed inset-0 z-50 overflow-y-auto"
      x-init={"function focusFirstElement() {
        // Find all focusable elements
        const focusable = $el.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex=#{"-1"}])');
        // Focus the first one
        if (focusable.length > 0) focusable[0].focus();
      }"}
    >
      <!-- Backdrop overlay -->
      <div
        class={"fixed inset-0 bg-black bg-opacity-50 #{@overlay_class}"}
        x-on:click="show = false"
        aria-hidden="true"
      ></div>

      <!-- Modal dialog -->
      <div class="flex items-center justify-center min-h-screen p-4">
        <div
          x-on:click.stop=""
          x-trap.noscroll.inert="show"
          class={"relative bg-white rounded-lg shadow-xl #{get_max_width_class(@max_width)} #{@class}"}
          role="dialog"
          aria-modal="true"
          aria-labelledby={"#{@id}-title"}
        >
          <!-- Header -->
          <%= if Map.has_key?(assigns, :title) or @show_close_button do %>
            <div class={"flex items-center justify-between px-4 py-3 border-b border-gray-200 #{@header_class}"}>
              <%= if Map.has_key?(assigns, :title) do %>
                <h3 id={"#{@id}-title"} class="text-lg font-medium text-gray-900"><%= @title %></h3>
              <% else %>
                <div></div>
              <% end %>
              <%= if @show_close_button do %>
                <button
                  type="button"
                  class="text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                  x-on:click="show = false"
                >
                  <span class="sr-only">Close</span>
                  <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              <% end %>
            </div>
          <% end %>

          <!-- Content -->
          <div class={"p-4 #{@content_class}"}>
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a full screen modal that covers the entire viewport.

  This component creates a modal that takes up the full screen when opened,
  with a header that contains the title and close button.

  ## Examples

      <.full_screen id="settings-modal" title="Application Settings">
        <div class="h-full overflow-y-auto">
          <p>Full screen modal content goes here.</p>
        </div>
      </.full_screen>

      <button x-on:click="$dispatch('open-modal', { id: 'settings-modal' })">Settings</button>

  ## Options

  * `:id` - Unique identifier for the modal (required)
  * `:title` - Modal dialog title (optional)
  * `:show_close_button` - Whether to show the close button (optional, defaults to true)
  * `:class` - Additional CSS classes for the modal container (optional)
  * `:header_class` - CSS classes for the modal header (optional)
  * `:content_class` - CSS classes for the modal content area (optional)
  """
  def full_screen(assigns) do
    assigns =
      assigns
      |> assign_new(:show_close_button, fn -> true end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:header_class, fn -> "" end)
      |> assign_new(:content_class, fn -> "" end)
      |> assign_new(:focus_element, fn -> nil end)

    ~H"""
    <div
      id={@id}
      x-data="{ show: false }"
      x-show="show"
      x-on:open-modal.window={"if ($event.detail.id === '#{@id}') { show = true; $nextTick(() => { #{if @focus_element, do: "$refs.#{@focus_element}.focus()", else: "focusFirstElement()"} }) }"}
      x-on:close-modal.window={"if ($event.detail.id === '#{@id}') show = false"}
      x-on:keydown.escape.window="show = false"
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0"
      x-transition:enter-end="opacity-100"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      x-cloak
      class="fixed inset-0 z-50"
      x-init={"function focusFirstElement() {
        // Find all focusable elements
        const focusable = $el.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex=#{"-1"}])');
        // Focus the first one
        if (focusable.length > 0) focusable[0].focus();
      }"}
    >
      <!-- Full screen modal -->
      <div
        x-trap.noscroll.inert="show"
        class={"flex flex-col w-full h-full bg-white #{@class}"}
        role="dialog"
        aria-modal="true"
        aria-labelledby={"#{@id}-title"}
      >
        <!-- Header -->
        <div class={"flex items-center justify-between px-4 py-3 border-b border-gray-200 #{@header_class}"}>
          <%= if Map.has_key?(assigns, :title) do %>
            <h3 id={"#{@id}-title"} class="text-lg font-medium text-gray-900"><%= @title %></h3>
          <% else %>
            <div></div>
          <% end %>
          <%= if @show_close_button do %>
            <button
              type="button"
              class="text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              x-on:click="show = false"
            >
              <span class="sr-only">Close</span>
              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          <% end %>
        </div>

        <!-- Content -->
        <div class={"flex-1 p-4 #{@content_class}"}>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a slide-over modal that appears from the side of the screen.

  This component creates a modal that slides in from the specified side
  (right by default) and covers a portion of the screen.

  ## Examples

      <.side id="cart-modal" title="Shopping Cart">
        <div class="h-full overflow-y-auto">
          <p>Cart content goes here.</p>
        </div>
      </.side>

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
  def side(assigns) do
    assigns =
      assigns
      |> assign_new(:show_close_button, fn -> true end)
      |> assign_new(:side, fn -> "right" end)
      |> assign_new(:width, fn -> "md" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:header_class, fn -> "" end)
      |> assign_new(:content_class, fn -> "" end)
      |> assign_new(:overlay_class, fn -> "" end)
      |> assign_new(:focus_element, fn -> nil end)

    ~H"""
    <div
      id={@id}
      x-data="{ show: false }"
      x-show="show"
      x-on:open-modal.window={"if ($event.detail.id === '#{@id}') { show = true; $nextTick(() => {#{if @focus_element, do: "$refs.#{@focus_element}.focus()", else: "focusFirstElement()"}}) }"}
      x-on:close-modal.window="if ($event.detail.id === '#{@id}') show = false"
      x-on:keydown.escape.window="show = false"
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0"
      x-transition:enter-end="opacity-100"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      x-cloak
      class="fixed inset-0 z-50 overflow-hidden"
      x-init={"function focusFirstElement() {
        // Find all focusable elements
        const focusable = $el.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex=#{"-1"}])');
        // Focus the first one
        if (focusable.length > 0) focusable[0].focus();
      }"}
    >
      <!-- Backdrop overlay -->
      <div
        class={"fixed inset-0 bg-black bg-opacity-50 #{@overlay_class}"}
        x-on:click="show = false"
        aria-hidden="true"
      ></div>

      <!-- Slide-over panel -->
      <div class={"fixed inset-y-0 #{@side}-0 flex max-w-full"}>
        <div
          x-trap.noscroll.inert="show"
          class={"w-screen #{get_width_class(@width)} #{@class}"}
          x-transition:enter="transform transition ease-in-out duration-300"
          x-transition:enter-start={"#{if @side == "right", do: "translate-x-full", else: "-translate-x-full"}"}
          x-transition:enter-end="translate-x-0"
          x-transition:leave="transform transition ease-in-out duration-300"
          x-transition:leave-start="translate-x-0"
          x-transition:leave-end={"#{if @side == "right", do: "translate-x-full", else: "-translate-x-full"}"}
          role="dialog"
          aria-modal="true"
          aria-labelledby={"#{@id}-title"}
        >
          <div class="flex h-full flex-col bg-white shadow-xl">
            <!-- Header -->
            <div class={"flex items-center justify-between px-4 py-3 border-b border-gray-200 #{@header_class}"}>
              <%= if Map.has_key?(assigns, :title) do %>
                <h3 id={"#{@id}-title"} class="text-lg font-medium text-gray-900"><%= @title %></h3>
              <% else %>
                <div></div>
              <% end %>
              <%= if @show_close_button do %>
                <button
                  type="button"
                  class="text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                  x-on:click="show = false"
                >
                  <span class="sr-only">Close</span>
                  <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              <% end %>
            </div>

            <!-- Content -->
            <div class={"flex-1 overflow-y-auto p-4 #{@content_class}"}>
              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Helper functions for CSS classes

  defp get_max_width_class(size) do
    case size do
      "sm" -> "max-w-sm"
      "md" -> "max-w-md"
      "lg" -> "max-w-lg"
      "xl" -> "max-w-xl"
      "2xl" -> "max-w-2xl"
      "full" -> "max-w-full"
      _ -> "max-w-lg" # Default
    end
  end

  defp get_width_class(size) do
    case size do
      "sm" -> "max-w-sm"
      "md" -> "max-w-md"
      "lg" -> "max-w-lg"
      "xl" -> "max-w-xl"
      "2xl" -> "max-w-2xl"
      "full" -> "w-full"
      _ -> "max-w-md" # Default
    end
  end
end
