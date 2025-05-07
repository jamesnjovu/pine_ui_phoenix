defmodule PineUi.Switch do
  @moduledoc """
  Provides toggle switch components for binary choices.

  The Switch module offers toggle switches that provide a visual way to
  enable or disable options. These components are designed to be accessible
  and integrate well with Phoenix forms.
  """
  use Phoenix.Component
  import Phoenix.HTML.Form

  @doc """
  Renders a basic toggle switch component.

  This component creates a simple on/off toggle switch for boolean options.

  ## Examples

      <.basic
        id="notifications"
        name="user[notifications]"
        value={@user.notifications}
        label="Enable notifications"
      />

      <.basic
        id="dark_mode"
        value={false}
        label="Dark mode"
        size="sm"
        variant="indigo"
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:label` - Text label for the switch (optional)
  * `:help_text` - Help text displayed below the switch (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:size` - Size of the switch: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the switch container (optional)
  * `:label_class` - CSS classes for the label text (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:value, fn -> false end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:label_class, fn -> "" end)
      |> assign_new(:help_text, fn -> nil end)
      |> assign_new(:phx_change, fn -> nil end)

    ~H"""
    <div class={"flex items-center justify-between #{@class}"}>
      <span class={"#{get_label_size_class(@size)} text-gray-500"} x-on:click="!$el.parentNode.querySelector('input').disabled && (value = false, $el.parentNode.querySelector('input').checked = false, $el.parentNode.querySelector('input').dispatchEvent(new Event('change', { bubbles: true })))">
        <%= @left_label %>
      </span>

      <div class="relative flex items-center mx-3">
        <input
          type="checkbox"
          id={@id}
          name={@name}
          checked={@value}
          disabled={@disabled}
          class="sr-only peer"
          phx-change={@phx_change}
          value="true"
          x-data={"{
            value: #{@value},
            handleChange() {
              this.value = !this.value;
              const event = new Event('change', { bubbles: true });
              this.$el.checked = this.value;
              this.$el.dispatchEvent(event);
            }
          }"}
          x-model="value"
          x-init="$el.checked = value"
          x-on:click.prevent="handleChange()"
        />
        <div
          class={
            "#{get_track_size_class(@size)} #{get_track_color_class(@variant)}"
            <> " rounded-full cursor-pointer peer-checked:bg-opacity-100 peer-checked:after:translate-x-full peer-disabled:cursor-not-allowed"
            <> " peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-offset-2 #{get_track_ring_color_class(@variant)}"
            <> " after:content-[''] after:absolute after:bg-white #{get_thumb_size_class(@size)}"
            <> " after:rounded-full after:shadow-sm after:transition-all after:duration-200"
          }
        ></div>
      </div>

      <span class={"#{get_label_size_class(@size)} text-gray-900"} x-on:click="!$el.parentNode.querySelector('input').disabled && (value = true, $el.parentNode.querySelector('input').checked = true, $el.parentNode.querySelector('input').dispatchEvent(new Event('change', { bubbles: true })))">
        <%= @right_label %>
      </span>

      <%= if @help_text do %>
        <p class="mt-1 text-sm text-gray-500"><%= @help_text %></p>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a card-style toggle switch component.

  This component creates an elegant card-style switch with label and icon.

  ## Examples

      <.card_switch
        id="auto_renewal"
        value={true}
        title="Auto-renewal"
        description="Automatically renew your subscription"
        icon={~H"<svg class='h-6 w-6 text-indigo-600' fill='none' viewBox='0 0 24 24' stroke-width='1.5' stroke='currentColor'>
          <path stroke-linecap='round' stroke-linejoin='round' d='M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99' />
        </svg>"}
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:title` - The card title text (optional)
  * `:description` - Descriptive text for the switch (optional)
  * `:icon` - Icon markup to display (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the card container (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def card_switch(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:value, fn -> false end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:phx_change, fn -> nil end)

    ~H"""
    <div
      class={"flex items-center justify-between p-4 border rounded-lg #{@class} #{if @disabled, do: "opacity-60", else: "cursor-pointer hover:bg-gray-50"}"}
      x-data={"{
        value: #{@value},
        handleChange() {
          if (! #{@disabled}s) {
            this.value = !this.value;
            const input = this.$refs.input;
            input.checked = this.value;
            input.dispatchEvent(new Event('change', { bubbles: true }));
          }
        }
      }"}
      x-on:click="handleChange()"
    >
      <div class="flex items-start">
        <%= if Map.has_key?(assigns, :icon) do %>
          <div class="flex-shrink-0 mr-4">
            <%= @icon %>
          </div>
        <% end %>
        <div>
          <%= if Map.has_key?(assigns, :title) do %>
            <h3 class="text-base font-medium text-gray-900"><%= @title %></h3>
          <% end %>
          <%= if Map.has_key?(assigns, :description) do %>
            <p class="mt-1 text-sm text-gray-500"><%= @description %></p>
          <% end %>
        </div>
      </div>

      <div class="relative flex-shrink-0 ml-4">
        <input
          type="checkbox"
          id={@id}
          name={@name}
          x-ref="input"
          checked={@value}
          disabled={@disabled}
          class="sr-only peer"
          phx-change={@phx_change}
          value="true"
          x-model="value"
          x-init="$el.checked = value"
          x-on:click.stop=""
        />
        <div
          class={
            "w-11 h-6 #{get_track_color_class(@variant)}"
            <> " rounded-full peer-checked:bg-opacity-100 peer-checked:after:translate-x-full peer-disabled:cursor-not-allowed"
            <> " peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-offset-2 #{get_track_ring_color_class(@variant)}"
            <> " after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:w-5 after:h-5"
            <> " after:rounded-full after:shadow-sm after:transition-all after:duration-200"
          }
        ></div>
      </div>
    </div>
    """
  end

  # Helper functions for CSS classes

  defp get_track_size_class(size) do
    case size do
      "sm" -> "w-8 h-4"
      "md" -> "w-11 h-6"
      "lg" -> "w-14 h-7"
      _ -> "w-11 h-6" # Default
    end
  end

  defp get_thumb_size_class(size) do
    case size do
      "sm" -> "after:top-[2px] after:left-[2px] after:w-3 after:h-3"
      "md" -> "after:top-[2px] after:left-[2px] after:w-5 after:h-5"
      "lg" -> "after:top-[2px] after:left-[2px] after:w-6 after:h-6"
      _ -> "after:top-[2px] after:left-[2px] after:w-5 after:h-5" # Default
    end
  end

  defp get_label_size_class(size) do
    case size do
      "sm" -> "text-xs"
      "md" -> "text-sm"
      "lg" -> "text-base"
      _ -> "text-sm" # Default
    end
  end

  defp get_track_color_class(variant) do
    case variant do
      "indigo" -> "bg-gray-200 peer-checked:bg-indigo-600"
      "blue" -> "bg-gray-200 peer-checked:bg-blue-600"
      "green" -> "bg-gray-200 peer-checked:bg-green-600"
      "red" -> "bg-gray-200 peer-checked:bg-red-600"
      "amber" -> "bg-gray-200 peer-checked:bg-amber-600"
      _ -> "bg-gray-200 peer-checked:bg-indigo-600" # Default
    end
  end

  defp get_track_ring_color_class(variant) do
    case variant do
      "indigo" -> "peer-focus:ring-indigo-500"
      "blue" -> "peer-focus:ring-blue-500"
      "green" -> "peer-focus:ring-green-500"
      "red" -> "peer-focus:ring-red-500"
      "amber" -> "peer-focus:ring-amber-500"
      _ -> "peer-focus:ring-indigo-500" # Default
    end
  end


  @doc """
  Renders a labeled toggle switch component with a descriptive label on each side.

  This component creates a switch with labels for both on and off states.

  ## Examples

      <.labeled_switch
        id="status"
        name="project[status]"
        value={@project.status}
        left_label="Draft"
        right_label="Published"
      />

  ## Options

  * `:id` - The ID for the switch element (required)
  * `:name` - The name attribute for form submission (optional, defaults to ID)
  * `:value` - Whether the switch is on or off (optional, defaults to false)
  * `:left_label` - Text label for the off state (optional, defaults to "Off")
  * `:right_label` - Text label for the on state (optional, defaults to "On")
  * `:help_text` - Help text displayed below the switch (optional)
  * `:disabled` - Whether the switch is disabled (optional, defaults to false)
  * `:size` - Size of the switch: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the switch container (optional)
  * `:phx_change` - Phoenix change event name (optional)
  """
  def labeled_switch(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:value, fn -> false end)
      |> assign_new(:left_label, fn -> "Off" end)
      |> assign_new(:right_label, fn -> "On" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:help_text, fn -> nil end)
      |> assign_new(:phx_change, fn -> nil end)

    ~H"""
    <div class={"flex items-center #{@class}"}>
      <div class="relative flex items-center">
        <input
          type="checkbox"
          id={@id}
          name={@name}
          checked={@value}
          disabled={@disabled}
          class="sr-only peer"
          phx-change={@phx_change}
          value="true"
          x-data={"{
            value: #{@value},
            handleChange() {
              this.value = !this.value;
              const event = new Event('change', { bubbles: true });
              this.$el.checked = this.value;
              this.$el.dispatchEvent(event);
            }
          }"}
          x-model="value"
          x-init="$el.checked = value"
          x-on:click.prevent="handleChange()"
        />
        <div
          class={
            "#{get_track_size_class(@size)} #{get_track_color_class(@variant)}"
            <> " rounded-full cursor-pointer peer-checked:bg-opacity-100 peer-checked:after:translate-x-full peer-disabled:cursor-not-allowed"
            <> " peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-offset-2 #{get_track_ring_color_class(@variant)}"
            <> " after:content-[''] after:absolute after:bg-white #{get_thumb_size_class(@size)}"
            <> " after:rounded-full after:shadow-sm after:transition-all after:duration-200"
          }
        ></div>
      </div>
      <%= if Map.has_key?(assigns, :label) do %>
        <span
          class={"ml-3 #{get_label_size_class(@size)} font-medium text-gray-900 cursor-pointer #{@label_class}"}
          x-on:click="handleChange()"
        >
          <%= @label %>
        </span>
      <% end %>
      <%= if @help_text do %>
        <p class="mt-1 text-sm text-gray-500"><%= @help_text %></p>
      <% end %>
    </div>
    """
  end

end
