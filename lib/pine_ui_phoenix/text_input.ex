defmodule PineUiPhoenix.TextInput do
  @moduledoc """
  Provides text input components for forms and user input.

  The TextInput module offers three main variants:

  - `basic/1` - Standard text input with optional prefix/suffix
  - `with_icon/1` - Text input with an icon
  - `textarea/1` - Multiline text input

  All text input components support labels, hints, error messages, and
  are fully integrated with Phoenix LiveView.

  ## Examples

      <PineUi.text_input
        id="email"
        label="Email Address"
        type="email"
        placeholder="you@example.com"
      />

      <PineUi.text_input_with_icon
        id="search"
        icon={~H"<svg>...</svg>"}
        placeholder="Search..."
      />

      <PineUi.textarea
        id="description"
        label="Description"
        rows={6}
      />

  ## Accessibility

  All text input components include proper labeling, focus styles, and
  ARIA attributes for accessibility.
  """
  use Phoenix.Component

  @doc """
  Renders a basic text input component.

  This component supports various input types and can include prefix/suffix
  text alongside the input.

  ## Examples

      <.basic id="username" label="Username" />

      <.basic
        id="price"
        label="Price"
        type="number"
        prefix="$"
        hint="Enter amount in dollars"
      />

      <.basic
        id="email"
        label="Email"
        type="email"
        error="Please enter a valid email address"
        required={true}
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:type` - Input type (optional, defaults to "text")
  * `:value` - Current input value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:prefix` - Text to display before the input (optional)
  * `:suffix` - Text to display after the input (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_focus` - Phoenix focus event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the input element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def basic(assigns) do
    ~H"""
    <div class={Map.get(assigns, :container_class, "")}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <div class="relative rounded-md shadow-sm">
        <%= if Map.get(assigns, :prefix, nil) do %>
          <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <span class="text-gray-500 sm:text-sm"><%= @prefix %></span>
          </div>
        <% end %>
        <input
          type={Map.get(assigns, :type, "text")}
          name={Map.get(assigns, :name, @id)}
          id={@id}
          value={Map.get(assigns, :value, "")}
          placeholder={Map.get(assigns, :placeholder, "")}
          class={get_input_classes(assigns)}
          required={Map.get(assigns, :required, false)}
          disabled={Map.get(assigns, :disabled, false)}
          readonly={Map.get(assigns, :readonly, false)}
          autofocus={Map.get(assigns, :autofocus, false)}
          phx-change={Map.get(assigns, :phx_change, nil)}
          phx-blur={Map.get(assigns, :phx_blur, nil)}
          phx-focus={Map.get(assigns, :phx_focus, nil)}
          phx-debounce={Map.get(assigns, :phx_debounce, nil)}
        />
        <%= if Map.get(assigns, :suffix, nil) do %>
          <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
            <span class="text-gray-500 sm:text-sm"><%= @suffix %></span>
          </div>
        <% end %>
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

  defp get_input_classes(assigns) do
    base_classes =
      "block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"

    error_classes =
      if Map.get(assigns, :error, nil),
         do:
           "border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500",
         else: ""

    prefix_classes = if Map.get(assigns, :prefix, nil), do: "pl-9", else: ""
    suffix_classes = if Map.get(assigns, :suffix, nil), do: "pr-9", else: ""
    extra_classes = Map.get(assigns, :class, "")

    [base_classes, error_classes, prefix_classes, suffix_classes, extra_classes]
    |> Enum.filter(&(&1 != ""))
    |> Enum.join(" ")
  end

  @doc """
  Renders a text input with an icon on the left side.

  This component is ideal for search inputs or any field that benefits from
  a visual indicator of its purpose.

  ## Examples

      <.with_icon
        id="search"
        icon={~H"<svg class='h-5 w-5 text-gray-400' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'><path fill-rule='evenodd' d='M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z' clip-rule='evenodd'/></svg>"}
        placeholder="Search..."
      />

      <.with_icon
        id="email"
        icon={~H"<svg>...</svg>"}
        label="Email"
        error={@form.errors[:email]}
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:icon` - The icon to display (required, as HEEx or HTML string)
  * `:type` - Input type (optional, defaults to "text")
  * `:value` - Current input value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_focus` - Phoenix focus event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the input element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def with_icon(assigns) do
    ~H"""
    <div class={Map.get(assigns, :container_class, "")}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <div class="relative rounded-md shadow-sm">
        <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
          <%= @icon %>
        </div>
        <input
          type={Map.get(assigns, :type, "text")}
          name={Map.get(assigns, :name, @id)}
          id={@id}
          value={Map.get(assigns, :value, "")}
          placeholder={Map.get(assigns, :placeholder, "")}
          class={"pl-10 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{if Map.get(assigns, :error, nil), do: "border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500", else: ""} #{Map.get(assigns, :class, "")}"}
          required={Map.get(assigns, :required, false)}
          disabled={Map.get(assigns, :disabled, false)}
          readonly={Map.get(assigns, :readonly, false)}
          autofocus={Map.get(assigns, :autofocus, false)}
          phx-change={Map.get(assigns, :phx_change, nil)}
          phx-blur={Map.get(assigns, :phx_blur, nil)}
          phx-focus={Map.get(assigns, :phx_focus, nil)}
          phx-debounce={Map.get(assigns, :phx_debounce, nil)}
        />
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

  @doc """
  Renders a textarea component for multiline text input.

  ## Examples

      <.textarea
        id="description"
        label="Description"
        rows={4}
      />

      <.textarea
        id="feedback"
        label="Your Feedback"
        placeholder="Tell us what you think..."
        hint="Your feedback helps us improve our service"
        rows={8}
      />

  ## Options

  * `:id` - The ID for the textarea element (required)
  * `:name` - The name attribute (optional, defaults to ID)
  * `:label` - Label text (optional)
  * `:value` - Current textarea value (optional)
  * `:placeholder` - Placeholder text (optional)
  * `:rows` - Number of visible rows (optional, defaults to 4)
  * `:hint` - Help text displayed below the textarea (optional)
  * `:error` - Error message displayed below the textarea (optional)
  * `:required` - Whether the field is required (optional, defaults to false)
  * `:disabled` - Whether the field is disabled (optional, defaults to false)
  * `:readonly` - Whether the field is read only (optional, defaults to false)
  * `:autofocus` - Whether the field should autofocus (optional, defaults to false)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  * `:phx_debounce` - Phoenix debounce setting (optional)
  * `:class` - Additional CSS classes for the textarea element (optional)
  * `:container_class` - CSS classes for the container div (optional)
  """
  def textarea(assigns) do
    ~H"""
    <div class={Map.get(assigns, :container_class, "")}>
      <%= if Map.get(assigns, :label, nil) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>
      <textarea
        name={Map.get(assigns, :name, @id)}
        id={@id}
        placeholder={Map.get(assigns, :placeholder, "")}
        rows={Map.get(assigns, :rows, 4)}
        class={"block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{if Map.get(assigns, :error, nil), do: "border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500", else: ""} #{Map.get(assigns, :class, "")}"}
        required={Map.get(assigns, :required, false)}
        disabled={Map.get(assigns, :disabled, false)}
        readonly={Map.get(assigns, :readonly, false)}
        autofocus={Map.get(assigns, :autofocus, false)}
        phx-change={Map.get(assigns, :phx_change, nil)}
        phx-blur={Map.get(assigns, :phx_blur, nil)}
        phx-debounce={Map.get(assigns, :phx_debounce, nil)}
      ><%= Map.get(assigns, :value, "") %></textarea>
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
