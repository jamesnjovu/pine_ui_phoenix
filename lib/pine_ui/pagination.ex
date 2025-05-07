defmodule PineUi.Pagination do
  @moduledoc """
  Provides pagination components for navigating through pages of content.

  The Pagination module offers components for creating pagination interfaces
  that help users navigate through multi-page content in a user-friendly way.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic pagination component.

  This component creates a pagination interface with page numbers and
  navigation controls.

  ## Examples

      <.basic
        current_page={5}
        total_pages={10}
        on_page_change="change_page"
      />

      <.basic
        current_page={3}
        total_pages={20}
        sibling_count={2}
        show_first_last_buttons={true}
        variant="indigo"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:sibling_count` - Number of sibling pages to show on each side of current page (optional, defaults to 1)
  * `:show_first_last_buttons` - Whether to show first/last page buttons (optional, defaults to false)
  * `:show_ellipsis` - Whether to show ellipsis for hidden pages (optional, defaults to true)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:size` - Size of the pagination: "sm", "md", "lg" (optional, defaults to "md")
  * `:class` - Additional CSS classes for the pagination container (optional)
  * `:item_class` - CSS classes for the page items (optional)
  * `:on_page_change` - Event name or function for page change (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:sibling_count, fn -> 1 end)
      |> assign_new(:show_first_last_buttons, fn -> false end)
      |> assign_new(:show_ellipsis, fn -> true end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:item_class, fn -> "" end)
      |> assign_new(:on_page_change, fn -> nil end)
      |> assign(
           :pages,
           generate_page_numbers(
             assigns.current_page,
             assigns.total_pages,
             assigns.sibling_count,
             assigns.show_ellipsis
           )
         )

    ~H"""
    <nav class={"flex items-center justify-center #{@class}"} aria-label="Pagination">
      <ul class="flex items-center -space-x-px">
        <!-- Previous button -->
        <li>
          <button
            type="button"
            phx-click={if @on_page_change && @current_page > 1, do: @on_page_change}
            phx-value-page={if @current_page > 1, do: @current_page - 1}
            disabled={@current_page <= 1}
            class={
              "#{get_button_base_class(@size)} #{get_button_previous_class(@size)} " <>
              if(@current_page <= 1, do: "text-gray-300 cursor-not-allowed", else: "text-gray-500 hover:bg-gray-100")
            }
            aria-label="Previous page"
          >
            <span class="sr-only">Previous</span>
            <svg class={get_icon_size_class(@size)} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
          </button>
        </li>

        <!-- First page button -->
        <%= if @show_first_last_buttons && @current_page > @sibling_count + 2 do %>
          <li>
            <button
              type="button"
              phx-click={@on_page_change}
              phx-value-page={1}
              class={
                "#{get_button_base_class(@size)} #{get_button_item_class(@size)} " <>
                "text-gray-500 hover:bg-gray-100"
              }
              aria-label="Page 1"
            >
              1
            </button>
          </li>
        <% end %>

        <!-- Page numbers -->
        <%= for page <- @pages do %>
          <%= if page == :ellipsis do %>
            <li>
              <span class={
                "#{get_button_base_class(@size)} #{get_button_item_class(@size)} " <>
                "text-gray-500 bg-white cursor-default"
              }>
                ...
              </span>
            </li>
          <% else %>
            <li>
              <button
                type="button"
                phx-click={if @on_page_change && page != @current_page, do: @on_page_change}
                phx-value-page={page}
                class={
                  "#{get_button_base_class(@size)} #{get_button_item_class(@size)} #{@item_class} " <>
                  if(page == @current_page,
                    do: "#{get_active_button_class(@variant)} text-white",
                    else: "text-gray-500 hover:bg-gray-100"
                  )
                }
                aria-label={"Page #{page}"}
                aria-current={if page == @current_page, do: "page", else: nil}
              >
                <%= page %>
              </button>
            </li>
          <% end %>
        <% end %>

        <!-- Last page button -->
        <%= if @show_first_last_buttons && @current_page < @total_pages - @sibling_count - 1 do %>
          <li>
            <button
              type="button"
              phx-click={@on_page_change}
              phx-value-page={@total_pages}
              class={
                "#{get_button_base_class(@size)} #{get_button_item_class(@size)} " <>
                "text-gray-500 hover:bg-gray-100"
              }
              aria-label={"Page #{@total_pages}"}
            >
              <%= @total_pages %>
            </button>
          </li>
        <% end %>

        <!-- Next button -->
        <li>
          <button
            type="button"
            phx-click={if @on_page_change && @current_page < @total_pages, do: @on_page_change}
            phx-value-page={if @current_page < @total_pages, do: @current_page + 1}
            disabled={@current_page >= @total_pages}
            class={
              "#{get_button_base_class(@size)} #{get_button_next_class(@size)} " <>
              if(@current_page >= @total_pages, do: "text-gray-300 cursor-not-allowed", else: "text-gray-500 hover:bg-gray-100")
            }
            aria-label="Next page"
          >
            <span class="sr-only">Next</span>
            <svg class={get_icon_size_class(@size)} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
            </svg>
          </button>
        </li>
      </ul>
    </nav>
    """
  end

  @doc """
  Renders a simple pagination component with prev/next buttons.

  This component creates a simpler pagination interface with just the
  essential navigation controls.

  ## Examples

      <.simple
        current_page={5}
        total_pages={10}
        on_page_change="change_page"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:show_page_info` - Whether to show current/total page info (optional, defaults to true)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:size` - Size of the pagination: "sm", "md", "lg" (optional, defaults to "md")
  * `:class` - Additional CSS classes for the pagination container (optional)
  * `:on_page_change` - Event name or function for page change (optional)
  """
  def simple(assigns) do
    assigns =
      assigns
      |> assign_new(:show_page_info, fn -> true end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:on_page_change, fn -> nil end)

    ~H"""
    <div class={"flex items-center justify-between #{@class}"}>
      <div>
        <button
          type="button"
          phx-click={if @on_page_change && @current_page > 1, do: @on_page_change}
          phx-value-page={if @current_page > 1, do: @current_page - 1}
          disabled={@current_page <= 1}
          class={
            "#{get_simple_button_class(@size)} " <>
            if(@current_page <= 1, do: "opacity-50 cursor-not-allowed", else: "hover:bg-gray-50")
          }
          aria-label="Previous page"
        >
          <svg class={get_icon_size_class(@size)} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
          <span>Previous</span>
        </button>
      </div>

      <%= if @show_page_info do %>
        <div class="text-sm text-gray-700">
          Page <span class="font-medium"><%= @current_page %></span> of <span class="font-medium"><%= @total_pages %></span>
        </div>
      <% end %>

      <div>
        <button
          type="button"
          phx-click={if @on_page_change && @current_page < @total_pages, do: @on_page_change}
          phx-value-page={if @current_page < @total_pages, do: @current_page + 1}
          disabled={@current_page >= @total_pages}
          class={
            "#{get_simple_button_class(@size)} " <>
            if(@current_page >= @total_pages, do: "opacity-50 cursor-not-allowed", else: "hover:bg-gray-50")
          }
          aria-label="Next page"
        >
          <span>Next</span>
          <svg class={get_icon_size_class(@size)} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Renders a "load more" pagination component.

  This component creates a button that loads additional content
  rather than using traditional pagination.

  ## Examples

      <.load_more
        current_page={2}
        total_pages={5}
        label="Load more results"
        on_load_more="load_more"
      />

  ## Options

  * `:current_page` - Current active page (required, 1-based index)
  * `:total_pages` - Total number of pages (required)
  * `:label` - Text for the load more button (optional, defaults to "Load more")
  * `:loading_label` - Text shown when loading (optional, defaults to "Loading...")
  * `:show_progress` - Whether to show loading progress (optional, defaults to false)
  * `:show_remaining` - Whether to show count of remaining items (optional, defaults to false)
  * `:items_per_page` - Number of items loaded per page (optional, required if show_remaining is true)
  * `:total_items` - Total number of items (optional, required if show_remaining is true)
  * `:loading` - Whether loading is in progress (optional, defaults to false)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the container (optional)
  * `:button_class` - CSS classes for the button (optional)
  * `:on_load_more` - Event name or function for loading more (optional)
  """
  def load_more(assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> "Load more" end)
      |> assign_new(:loading_label, fn -> "Loading..." end)
      |> assign_new(:show_progress, fn -> false end)
      |> assign_new(:show_remaining, fn -> false end)
      |> assign_new(:loading, fn -> false end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:button_class, fn -> "" end)
      |> assign_new(:on_load_more, fn -> nil end)

    ~H"""
    <div class={"flex flex-col items-center space-y-4 #{@class}"}>
      <%= if @show_progress do %>
        <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
          <div
            class={
              "h-2.5 rounded-full " <> get_progress_color_class(@variant)
            }
            style={"width: #{@current_page * 100 / @total_pages}%"}
          ></div>
        </div>
      <% end %>

      <%= if @current_page < @total_pages do %>
        <button
          type="button"
          phx-click={@on_load_more}
          phx-value-page={@current_page + 1}
          disabled={@loading || @current_page >= @total_pages}
          class={
            "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white " <>
            get_button_color_class(@variant) <> " " <>
            if(@loading, do: "opacity-75 cursor-not-allowed", else: "hover:bg-opacity-90") <> " " <>
            @button_class
          }
        >
          <%= if @loading do %>
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <%= @loading_label %>
          <% else %>
            <%= @label %>
          <% end %>
        </button>

        <%= if @show_remaining && Map.has_key?(assigns, :items_per_page) && Map.has_key?(assigns, :total_items) do %>
          <% remaining_items = @total_items - (@current_page * @items_per_page) %>
          <p class="text-sm text-gray-500">
            Showing <%= min(@current_page * @items_per_page, @total_items) %> of <%= @total_items %> items
            <%= if remaining_items > 0 do %>
              (<%= remaining_items %> remaining)
            <% end %>
          </p>
        <% end %>
      <% else %>
        <p class="text-sm text-gray-500">All items loaded</p>
      <% end %>
    </div>
    """
  end

  # Helper functions

  defp generate_page_numbers(current_page, total_pages, sibling_count, show_ellipsis) do
    # Calculate the start and end of the visible page range
    siblings_start = max(current_page - sibling_count, 1)
    siblings_end = min(current_page + sibling_count, total_pages)

    # Include ellipsis for hidden pages at the start
    start_range =
      if siblings_start > 2 && show_ellipsis do
        [1, :ellipsis]
      else
        Enum.to_list(1..siblings_start - 1)
      end

    # Include ellipsis for hidden pages at the end
    end_range =
      if siblings_end < total_pages - 1 && show_ellipsis do
        [:ellipsis, total_pages]
      else
        Enum.to_list(siblings_end + 1..total_pages)
      end

    # Combine all parts of the page range
    start_range ++ Enum.to_list(siblings_start..siblings_end) ++ end_range
  end

  # CSS class helpers

  defp get_button_base_class(size) do
    case size do
      "sm" -> "inline-flex items-center justify-center border border-gray-300 bg-white"
      "md" -> "inline-flex items-center justify-center border border-gray-300 bg-white"
      "lg" -> "inline-flex items-center justify-center border border-gray-300 bg-white"
      _ -> "inline-flex items-center justify-center border border-gray-300 bg-white"
    end
  end

  defp get_button_item_class(size) do
    case size do
      "sm" -> "w-8 h-8 text-xs"
      "md" -> "w-10 h-10 text-sm"
      "lg" -> "w-12 h-12 text-base"
      _ -> "w-10 h-10 text-sm"
    end
  end

  defp get_button_previous_class(size) do
    case size do
      "sm" -> "rounded-l-md w-8 h-8"
      "md" -> "rounded-l-md w-10 h-10"
      "lg" -> "rounded-l-md w-12 h-12"
      _ -> "rounded-l-md w-10 h-10"
    end
  end

  defp get_button_next_class(size) do
    case size do
      "sm" -> "rounded-r-md w-8 h-8"
      "md" -> "rounded-r-md w-10 h-10"
      "lg" -> "rounded-r-md w-12 h-12"
      _ -> "rounded-r-md w-10 h-10"
    end
  end

  defp get_icon_size_class(size) do
    case size do
      "sm" -> "h-4 w-4"
      "md" -> "h-5 w-5"
      "lg" -> "h-6 w-6"
      _ -> "h-5 w-5"
    end
  end

  defp get_active_button_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-600 border-indigo-600"
      "blue" -> "bg-blue-600 border-blue-600"
      "green" -> "bg-green-600 border-green-600"
      "red" -> "bg-red-600 border-red-600"
      "amber" -> "bg-amber-600 border-amber-600"
      _ -> "bg-indigo-600 border-indigo-600"
    end
  end

  defp get_simple_button_class(size) do
    case size do
      "sm" ->
        "inline-flex items-center space-x-1 px-2.5 py-1.5 border border-gray-300 text-xs font-medium rounded text-gray-700 bg-white"
      "md" ->
        "inline-flex items-center space-x-2 px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white"
      "lg" ->
        "inline-flex items-center space-x-3 px-6 py-3 border border-gray-300 text-base font-medium rounded-md text-gray-700 bg-white"
      _ ->
        "inline-flex items-center space-x-2 px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white"
    end
  end

  defp get_progress_color_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-600"
      "blue" -> "bg-blue-600"
      "green" -> "bg-green-600"
      "red" -> "bg-red-600"
      "amber" -> "bg-amber-600"
      _ -> "bg-indigo-600"
    end
  end

  defp get_button_color_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-600 hover:bg-indigo-700"
      "blue" -> "bg-blue-600 hover:bg-blue-700"
      "green" -> "bg-green-600 hover:bg-green-700"
      "red" -> "bg-red-600 hover:bg-red-700"
      "amber" -> "bg-amber-600 hover:bg-amber-700"
      _ -> "bg-indigo-600 hover:bg-indigo-700"
    end
  end
end
