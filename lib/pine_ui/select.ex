defmodule PineUi.Select do
  @moduledoc false
  use Phoenix.Component

  def basic(assigns) do
    ~H"""
    <div class={Map.get(assigns, :container_class, "")}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <select
        id={@id}
        name={Map.get(assigns, :name, @id)}
        class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{Map.get(assigns, :class, "")}"}
        phx-change={Map.get(assigns, :phx_change, nil)}
        required={Map.get(assigns, :required, false)}
        disabled={Map.get(assigns, :disabled, false)}
      >
        <%= if Map.get(assigns, :placeholder, nil) do %>
          <option value=""><%= @placeholder %></option>
        <% end %>
        <%= for {value, label} <- @options do %>
          <option value={value} selected={value == Map.get(assigns, :selected, nil)}><%= label %></option>
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

  def grouped(assigns) do
    ~H"""
    <div class={Map.get(assigns, :container_class, "")}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <select
        id={@id}
        name={Map.get(assigns, :name, @id)}
        class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{Map.get(assigns, :class, "")}"}
        phx-change={Map.get(assigns, :phx_change, nil)}
        required={Map.get(assigns, :required, false)}
        disabled={Map.get(assigns, :disabled, false)}
      >
        <%= if Map.get(assigns, :placeholder, nil) do %>
          <option value=""><%= @placeholder %></option>
        <% end %>
        <%= for {group_label, options} <- @option_groups do %>
          <optgroup label={group_label}>
            <%= for {value, label} <- options do %>
              <option value={value} selected={value == Map.get(assigns, :selected, nil)}><%= label %></option>
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

  def searchable(assigns) do
    ~H"""
    <div
      x-data="{
        open: false,
        search: '',
        selected: #{if Map.get(assigns, :selected_label), do: "'#{@selected_label}'", else: "''"},
        selectedValue: #{if Map.get(assigns, :selected), do: "'#{@selected}'", else: "''"},
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
          return #{Jason.encode!(Enum.map(@options, fn {value, label} -> %{value: value, label: label} end))}
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
      }"
      x-init="() => {
        $watch('search', () => {
          highlight = -1;
          if (search === '') {
            selectedValue = '';
            selected = '';
          }
        });
      }"
      class={Map.get(assigns, :container_class, "")}
    >
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <div class="relative">
        <input
          type="text"
          id={@id <> "_search"}
          placeholder={Map.get(assigns, :placeholder, "Select an option")}
          x-model="search"
          x-on:focus="open = true"
          x-on:click="open = true"
          x-on:keydown.escape="onEscape()"
          x-on:keydown.arrow-up.prevent="onArrowUp()"
          x-on:keydown.arrow-down.prevent="onArrowDown()"
          x-on:keydown.enter.prevent="onEnter()"
          class={"block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm #{Map.get(assigns, :class, "")}"}
          required={Map.get(assigns, :required, false)}
          disabled={Map.get(assigns, :disabled, false)}
        />

        <input
          type="hidden"
          id={@id}
          name={Map.get(assigns, :name, @id)}
          x-ref="select"
          x-model="selectedValue"
          phx-change={Map.get(assigns, :phx_change, nil)}
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

          <template x-for="(option, index) in filteredOptions()" :key="option.value">
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
