defmodule PineUi.Select do
  @moduledoc """
  Provides select components for dropdown selections.

  The Select module offers three main variants:
  - `basic/1` - Standard select dropdown
  - `grouped/1` - Select with option groups
  - `searchable/1` - Enhanced select with search functionality
  """
  use Phoenix.Component

  @doc """
  Renders a basic select dropdown component.

  ## Examples

      <.basic
        id="country"
        label="Country"
        options={[{"us", "United States"}, {"ca", "Canada"}]}
        selected="us"
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:options` - List of {value, label} tuples for the options (required)
  * `:selected` - The currently selected value (optional)
  * `:placeholder` - Placeholder text for empty selection (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:container_class, fn -> "" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:phx_change, fn -> nil end)
      |> assign_new(:selected, fn -> nil end)

    ~H"""
    <div class={@container_class}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <select
        id={@id}
        name={@name}
        class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{@class}"}
        phx-change={@phx_change}
        required={@required}
        disabled={@disabled}
      >
        <%= if Map.get(assigns, :placeholder, nil) do %>
          <option value=""><%= @placeholder %></option>
        <% end %>
        <%= for {value, label} <- @options do %>
          <option value={value} selected={value == @selected}><%= label %></option>
        <% end %>
      </select>
      <%= if Map.get(assigns, :hint, nil) do %>
        <p class="mt-1 text-sm text-gray-500"><%= @hint %></p>
      <% end %>
      <%= if Map.get(assigns, :error, nil) do %>
        <p class="mt-1 text-sm text-red-600"><%= @error %></p>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a select dropdown with option groups.

  ## Examples

      <.grouped
        id="continent"
        label="Country"
        option_groups={[
          {"North America", [{"us", "United States"}, {"ca", "Canada"}]},
          {"Europe", [{"fr", "France"}, {"de", "Germany"}]}
        ]}
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:option_groups` - List of {group_label, options} tuples (required)
  * `:selected` - The currently selected value (optional)
  * `:placeholder` - Placeholder text for empty selection (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def grouped(assigns) do
    assigns =
      assigns
      |> assign_new(:container_class, fn -> "" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:phx_change, fn -> nil end)
      |> assign_new(:selected, fn -> nil end)

    ~H"""
    <div class={@container_class}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <select
        id={@id}
        name={@name}
        class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{@class}"}
        phx-change={@phx_change}
        required={@required}
        disabled={@disabled}
      >
        <%= if Map.get(assigns, :placeholder, nil) do %>
          <option value=""><%= @placeholder %></option>
        <% end %>
        <%= for {group_label, options} <- @option_groups do %>
          <optgroup label={group_label}>
            <%= for {value, label} <- options do %>
              <option value={value} selected={value == @selected}><%= label %></option>
            <% end %>
          </optgroup>
        <% end %>
      </select>
      <%= if Map.get(assigns, :hint, nil) do %>
        <p class="mt-1 text-sm text-gray-500"><%= @hint %></p>
      <% end %>
      <%= if Map.get(assigns, :error, nil) do %>
        <p class="mt-1 text-sm text-red-600"><%= @error %></p>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a searchable select dropdown with filtering.

  ## Examples

      <.searchable
        id="country"
        label="Country"
        options={[{"us", "United States"}, {"ca", "Canada"}]}
        placeholder="Search..."
      />

  ## Options

  * `:id` - The ID for the select element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:options` - List of {value, label} tuples for the options (required)
  * `:selected` - The currently selected value (optional)
  * `:selected_label` - The label for the selected value (optional)
  * `:placeholder` - Placeholder text for the search (optional)
  * `:hint` - Help text displayed below the select (optional)
  * `:error` - Error message displayed below the select (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:class` - Additional CSS classes for the select element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def searchable(assigns) do
    assigns =
      assigns
      |> assign_new(:container_class, fn -> "" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:placeholder, fn -> "Select an option" end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:phx_change, fn -> nil end)
      |> assign_new(:selected, fn -> nil end)
      |> assign_new(:selected_label, fn -> nil end)

    options_json = Jason.encode!(Enum.map(assigns.options, fn {value, label} -> %{value: value, label: label} end))

    ~H"""
    <div
      x-data={"{
        open: false,
        search: '#{Map.get(assigns, :selected_label, "")}',
        selected: '#{Map.get(assigns, :selected_label, "")}',
        selectedValue: '#{Map.get(assigns, :selected, "")}',
        highlight: -1,
        highlightOption(index) {
          this.highlight = index;
        },
        selectOption(value, label) {
          this.selectedValue = value;
          this.selected = label;
          this.open = false;
          this.search = label;

          const event = new CustomEvent('change', {
            detail: { value: value }
          });
          this.$refs.select.dispatchEvent(event);
        },
        filteredOptions() {
          return #{options_json}
            .filter(option => option.label.toLowerCase().includes(this.search.toLowerCase()));
        },
        onEscape() {
          this.open = false;
        },
        onArrowUp() {
          this.highlight = (this.highlight - 1 + this.filteredOptions().length) % this.filteredOptions().length;
        },
        onArrowDown() {
          if (this.open) {
            this.highlight = (this.highlight + 1) % this.filteredOptions().length;
          } else {
            this.open = true;
          }
        },
        onEnter() {
          if (this.highlight >= 0 && this.filteredOptions().length > 0) {
            const option = this.filteredOptions()[this.highlight];
            this.selectOption(option.value, option.label);
          }
        }
      }"}
      x-init="() => {
        $watch('search', () => {
          highlight = -1;
          if (search === '') {
            selectedValue = '';
            selected = '';
          }
        });
      }"
      class={@container_class}
    >
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <div class="relative">
        <input
          type="text"
          id={@id <> "_search"}
          placeholder={@placeholder}
          x-model="search"
          x-on:focus="open = true"
          x-on:click="open = true"
          x-on:keydown.escape="onEscape()"
          x-on:keydown.arrow-up.prevent="onArrowUp()"
          x-on:keydown.arrow-down.prevent="onArrowDown()"
          x-on:keydown.enter.prevent="onEnter()"
          class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{@class}"}
          required={@required}
          disabled={@disabled}
        />

        <input
          type="hidden"
          id={@id}
          name={@name}
          x-ref="select"
          x-model="selectedValue"
          phx-change={@phx_change}
        />

        <div
          x-show="open"
          x-on:click.away="open = false"
          class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
          x-cloak
        >
          <template x-if="filteredOptions().length === 0">
            <div class="px-4 py-2 text-sm text-gray-500">No results found</div>
          </template>

          <template x-for="(option, index) in filteredOptions()" x-bind:key="option.value">
            <div
              x-text="option.label"
              x-on:click="selectOption(option.value, option.label)"
              x-on:mouseover="highlightOption(index)"
              x-bind:class="{ 'bg-indigo-600 text-white': highlight === index, 'text-gray-900': highlight !== index }"
              class="relative cursor-pointer select-none py-2 pl-3 pr-9 hover:bg-indigo-600 hover:text-white"
            ></div>
          </template>
        </div>

        <div class="absolute inset-y-0 right-0 flex items-center pr-2">
          <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </div>
      </div>

      <%= if Map.get(assigns, :hint, nil) do %>
        <p class="mt-1 text-sm text-gray-500"><%= @hint %></p>
      <% end %>
      <%= if Map.get(assigns, :error, nil) do %>
        <p class="mt-1 text-sm text-red-600"><%= @error %></p>
      <% end %>
    </div>
    """
  end
end
