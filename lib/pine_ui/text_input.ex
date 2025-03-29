defmodule PineUi.TextInput do
  @moduledoc false
  use Phoenix.Component

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
    base_classes = "block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
    error_classes = if Map.get(assigns, :error, nil), do: "border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500", else: ""
    prefix_classes = if Map.get(assigns, :prefix, nil), do: "pl-9", else: ""
    suffix_classes = if Map.get(assigns, :suffix, nil), do: "pr-9", else: ""
    extra_classes = Map.get(assigns, :class, "")

    [base_classes, error_classes, prefix_classes, suffix_classes, extra_classes]
    |> Enum.filter(&(&1 != ""))
    |> Enum.join(" ")
  end

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
