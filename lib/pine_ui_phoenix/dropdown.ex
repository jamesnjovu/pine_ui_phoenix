defmodule PineUiPhoenix.Dropdown do
  @moduledoc """
  Provides dropdown menu components for displaying lists of actions or options.

  The Dropdown module offers components for creating dropdown menus that can
  contain links, buttons, and other interactive elements. Includes variants for
  different trigger styles and positioning.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic dropdown menu component.

  This component creates a dropdown menu that appears when a trigger button
  is clicked. The menu can contain links, buttons, or other elements.

  ## Examples

      <.basic id="user-menu" label="Options">
        <:item href="/profile">Profile</:item>
        <:item href="/settings">Settings</:item>
        <:divider />
        <:item href="/logout" class="text-red-600">Log out</:item>
      </.basic>

      <.basic id="actions-menu" icon={~H"<svg>...</svg>"}>
        <:item on_click="edit">Edit</:item>
        <:item on_click="duplicate">Duplicate</:item>
        <:divider />
        <:item on_click="delete" class="text-red-600">Delete</:item>
      </.basic>

  ## Options

  * `:id` - Unique identifier for the dropdown (required)
  * `:label` - Text for the trigger button (either this or icon is required)
  * `:icon` - Icon markup for the trigger button (either this or label is required)
  * `:position` - Menu position: "bottom-left", "bottom-right", "top-left", "top-right" (optional, defaults to "bottom-left")
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:button_class` - CSS classes for the trigger button (optional)
  * `:menu_class` - CSS classes for the dropdown menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:position, fn -> "bottom-left" end)
      |> assign_new(:width, fn -> "auto" end)
      |> assign_new(:button_class, fn -> "" end)
      |> assign_new(:menu_class, fn -> "" end)
      |> assign_new(:divider, fn -> [] end)

    ~H"""
    <div
      id={@id}
      x-data="{ open: false }"
      x-on:keydown.escape.window="open = false"
      x-on:click.away="open = false"
      class="relative inline-block text-left"
    >
      <!-- Trigger Button -->
      <button
        type="button"
        x-on:click="open = !open"
        class={"inline-flex items-center justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{@button_class}"}
        id={"#{@id}-button"}
        aria-expanded="x-bind:aria-expanded='open'"
        aria-haspopup="true"
      >
        <%= if Map.has_key?(assigns, :label) do %>
          <span><%= @label %></span>
        <% end %>

        <%= if Map.has_key?(assigns, :icon) do %>
          <%= if Map.has_key?(assigns, :label) do %>
            <span class="ml-2"><%= @icon %></span>
          <% else %>
            <%= @icon %>
          <% end %>
        <% else %>
          <!-- Default dropdown icon if no icon is provided -->
          <svg class={"#{ if Map.has_key?(assigns, :label), do: "ml-2", else: "" } -mr-1 h-5 w-5"} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        <% end %>
      </button>

      <!-- Dropdown Menu -->
      <div
        x-show="open"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        class={"absolute #{get_position_class(@position)} z-10 mt-2 #{get_width_class(@width)} rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none py-1 #{@menu_class}"}
        role="menu"
        aria-orientation="vertical"
        aria-labelledby={"#{@id}-button"}
        x-cloak
      >
        <%= for item <- @item do %>
          <div role="menuitem">
            <%= if Map.has_key?(item, :href) do %>
              <a
              href={item.href}
              class={"block px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
              {if Map.get(item, :disabled, false), do: [aria_disabled: "true", tabindex: "-1"], else: []}
            >
              <%= render_slot(item) %>
            </a>
            <% else %>
              <button
                type="button"
                phx-click={Map.get(item, :on_click, nil)}
                class={"block w-full text-left px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
                {if Map.get(item, :disabled, false), do: [disabled: true], else: []}
              >
                <%= render_slot(item) %>
              </button>
            <% end %>
          </div>
        <% end %>

        <%= for _divider <- @divider do %>
          <div class="py-1">
            <div class="border-t border-gray-100"></div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a dropdown menu with item icons.

  This component creates a dropdown menu with icon support for menu items.

  ## Examples

      <.with_icons id="file-menu" label="File">
        <:item
          href="#"
          icon={~H"<svg class='h-4 w-4' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
            <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 6v6m0 0v6m0-6h6m-6 0H6' />
          </svg>"}
        >
          New Document
        </:item>
        <:item
          href="#"
          icon={~H"<svg class='h-4 w-4' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
            <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12' />
          </svg>"}
        >
          Open
        </:item>
        <:divider />
        <:item
          href="#"
          icon={~H"<svg class='h-4 w-4' xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'>
            <path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4' />
          </svg>"}
        >
          Save
        </:item>
      </.with_icons>

  ## Options

  * `:id` - Unique identifier for the dropdown (required)
  * `:label` - Text for the trigger button (either this or icon is required)
  * `:icon` - Icon markup for the trigger button (either this or label is required)
  * `:position` - Menu position: "bottom-left", "bottom-right", "top-left", "top-right" (optional, defaults to "bottom-left")
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:button_class` - CSS classes for the trigger button (optional)
  * `:menu_class` - CSS classes for the dropdown menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:icon` - Icon markup for the menu item (optional)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def with_icons(assigns) do
    assigns =
      assigns
      |> assign_new(:position, fn -> "bottom-left" end)
      |> assign_new(:width, fn -> "auto" end)
      |> assign_new(:button_class, fn -> "" end)
      |> assign_new(:menu_class, fn -> "" end)
      |> assign_new(:divider, fn -> [] end)

    ~H"""
    <div
      id={@id}
      x-data="{ open: false }"
      x-on:keydown.escape.window="open = false"
      x-on:click.away="open = false"
      class="relative inline-block text-left"
    >
      <!-- Trigger Button -->
      <button
        type="button"
        x-on:click="open = !open"
        class={"inline-flex items-center justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 #{@button_class}"}
        id={"#{@id}-button"}
        aria-expanded="x-bind:aria-expanded='open'"
        aria-haspopup="true"
      >
        <%= if Map.has_key?(assigns, :label) do %>
          <span><%= @label %></span>
        <% end %>

        <%= if Map.has_key?(assigns, :icon) do %>
          <%= if Map.has_key?(assigns, :label) do %>
            <span class="ml-2"><%= @icon %></span>
          <% else %>
            <%= @icon %>
          <% end %>
        <% else %>
          <!-- Default dropdown icon if no icon is provided -->
          <svg class={"#{ if Map.has_key?(assigns, :label), do: "ml-2", else: "" } -mr-1 h-5 w-5"} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        <% end %>
      </button>

      <!-- Dropdown Menu -->
      <div
        x-show="open"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        class={"absolute #{get_position_class(@position)} z-10 mt-2 #{get_width_class(@width)} rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none py-1 #{@menu_class}"}
        role="menu"
        aria-orientation="vertical"
        aria-labelledby={"#{@id}-button"}
        x-cloak
      >
        <%= for item <- @item do %>
          <div role="menuitem">
            <%= if Map.has_key?(item, :href) do %>
              <a
                href={item.href}
                class={"flex items-center px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
                {if Map.get(item, :disabled, false), do: [aria_disabled: "true", tabindex: "-1"], else: []}
              >
                <%= if Map.has_key?(item, :icon) do %>
                  <span class="mr-3 text-gray-500"><%= item.icon %></span>
                <% end %>
                <%= render_slot(item) %>
              </a>
            <% else %>
              <button
                type="button"
                phx-click={Map.get(item, :on_click, nil)}
                class={"flex items-center w-full text-left px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
                {if Map.get(item, :disabled, false), do: [disable: "true"], else: []}
              >
                <%= if Map.has_key?(item, :icon) do %>
                  <span class="mr-3 text-gray-500"><%= item.icon %></span>
                <% end %>
                <%= render_slot(item) %>
              </button>
            <% end %>
          </div>
        <% end %>

        <%= for _divider <- @divider do %>
          <div class="py-1">
            <div class="border-t border-gray-100"></div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a contextual menu.

  This component creates a dropdown menu that appears at the cursor position
  when triggered, ideal for context or right-click menus.

  ## Examples

      <.context_menu id="context-menu">
        <:item on_click="edit">Edit</:item>
        <:item on_click="copy">Copy</:item>
        <:item on_click="delete" class="text-red-600">Delete</:item>
      </.context_menu>

      <div x-on:contextmenu="$event.preventDefault(); $dispatch('open-context-menu', { id: 'context-menu', x: $event.clientX, y: $event.clientY })">
        Right-click me
      </div>

  ## Options

  * `:id` - Unique identifier for the context menu (required)
  * `:width` - Menu width: "auto", "sm", "md", "lg" (optional, defaults to "auto")
  * `:menu_class` - CSS classes for the context menu (optional)
  * `:item` - Menu item slots with the following attributes:
    * `:href` - URL for link items (either this or on_click is typically provided)
    * `:on_click` - Click event name for button items (either this or href is typically provided)
    * `:icon` - Icon markup for the menu item (optional)
    * `:class` - CSS classes for the item (optional)
    * `:disabled` - Whether the item is disabled (optional, defaults to false)
  * `:divider` - Slot for menu divider lines (no attributes required)
  """
  def context_menu(assigns) do
    assigns =
      assigns
      |> assign_new(:width, fn -> "auto" end)
      |> assign_new(:menu_class, fn -> "" end)
      |> assign_new(:divider, fn -> [] end)

    ~H"""
    <div
      id={@id}
      x-data="{ open: false, x: 0, y: 0 }"
      x-on:open-context-menu.window="if ($event.detail.id === '#{@id}') {
        open = true;
        x = $event.detail.x;
        y = $event.detail.y;
        $nextTick(() => {
          const menu = $refs.menu;
          // Adjust position if menu would go off-screen
          const menuRect = menu.getBoundingClientRect();
          const windowWidth = window.innerWidth;
          const windowHeight = window.innerHeight;

          if (x + menuRect.width > windowWidth) {
            x = windowWidth - menuRect.width - 10;
          }

          if (y + menuRect.height > windowHeight) {
            y = windowHeight - menuRect.height - 10;
          }

          menu.style.left = x + 'px';
          menu.style.top = y + 'px';
        });
      }"
      x-on:keydown.escape.window="open = false"
      x-on:click.away="open = false"
      class="absolute"
      style="pointer-events: none;"
    >
      <!-- Context Menu -->
      <div
        x-show="open"
        x-ref="menu"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        class={"fixed z-50 #{get_width_class(@width)} rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none py-1 #{@menu_class}"}
        role="menu"
        aria-orientation="vertical"
        style="pointer-events: auto;"
        x-cloak
      >
        <%= for item <- @item do %>
          <div role="menuitem">
            <%= if Map.has_key?(item, :href) do %>
              <a
                href={item.href}
                class={"flex items-center px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
                {if Map.get(item, :disabled, false), do: [aria_disabled: "true", tabindex: "-1"], else: []}
              >
                <%= if Map.has_key?(item, :icon) do %>
                  <span class="mr-3 text-gray-500"><%= item.icon %></span>
                <% end %>
                <%= render_slot(item) %>
              </a>
            <% else %>
              <button
                type="button"
                phx-click={Map.get(item, :on_click, nil)}
                x-on:click="open = false"
                class={"flex items-center w-full text-left px-4 py-2 text-sm #{if Map.get(item, :disabled, false), do: "text-gray-400 cursor-not-allowed", else: "text-gray-700 hover:bg-gray-100 hover:text-gray-900"} #{Map.get(item, :class, "")}"}
                {if Map.get(item, :disabled, false), do: [disable: "true"], else: []}
              >
                <%= if Map.has_key?(item, :icon) do %>
                  <span class="mr-3 text-gray-500"><%= item.icon %></span>
                <% end %>
                <%= render_slot(item) %>
              </button>
            <% end %>
          </div>
        <% end %>

        <%= for _divider <- @divider do %>
          <div class="py-1">
            <div class="border-t border-gray-100"></div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # Helper functions for CSS classes

  defp get_position_class(position) do
    case position do
      "bottom-left" -> "left-0 origin-top-left"
      "bottom-right" -> "right-0 origin-top-right"
      "top-left" -> "left-0 bottom-full mb-2 origin-bottom-left"
      "top-right" -> "right-0 bottom-full mb-2 origin-bottom-right"
      _ -> "left-0 origin-top-left" # Default
    end
  end

  defp get_width_class(width) do
    case width do
      "auto" -> "w-auto"
      "sm" -> "w-48"
      "md" -> "w-56"
      "lg" -> "w-64"
      _ -> "w-auto" # Default
    end
  end
end
