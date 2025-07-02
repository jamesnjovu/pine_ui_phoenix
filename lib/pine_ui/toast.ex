defmodule PineUiPhoenix.Toast do
  @moduledoc """
  Provides toast notification components for displaying temporary messages.

  The Toast module offers components for creating non-intrusive notifications
  that appear temporarily and automatically dismiss after a configurable period.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a toast notification container.

  This component creates a container for toast notifications. It's designed to be
  placed at the root of your application layout.

  ## Examples

      <.container />

      <.container
        position="bottom-right"
        transition="slide"
      />

  ## Options

  * `:position` - Position of the toasts: "top-right", "top-left", "bottom-right", "bottom-left", "top-center", "bottom-center" (optional, defaults to "top-right")
  * `:transition` - Animation style: "fade", "slide", "zoom" (optional, defaults to "fade")
  * `:max_toasts` - Maximum number of toasts to show at once (optional, defaults to 5)
  * `:class` - Additional CSS classes for the container (optional)
  """
  def container(assigns) do
    assigns =
      assigns
      |> assign_new(:position, fn -> "top-right" end)
      |> assign_new(:transition, fn -> "fade" end)
      |> assign_new(:max_toasts, fn -> 5 end)
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <div
      id="pine-toast-container"
      x-data={"{
        toasts: [],
        lastId: 0,
        maxToasts: #{@max_toasts},
        position: '#{@position}',
        transition: '#{@transition}',

        add(toast) {
          // Generate a unique ID
          toast.id = ++this.lastId;

          // Set default duration if not provided
          if (!toast.duration) {
            toast.duration = 5000;
          }

          // Add toast to the list
          this.toasts.push(toast);

          // Limit the number of toasts
          if (this.toasts.length > this.maxToasts) {
            this.toasts.shift();
          }

          // Auto-dismiss after duration
          if (toast.duration > 0) {
            setTimeout(() => {
              this.remove(toast.id);
            }, toast.duration);
          }
        },

        remove(id) {
          this.toasts = this.toasts.filter(toast => toast.id !== id);
        }
      }"}
      x-on:add-toast.window="add($event.detail)"
      x-on:remove-toast.window="remove($event.detail.id)"
      class={
        "fixed z-50 w-full sm:max-w-sm p-4 #{@class} " <>
        get_position_class(@position)
      }
      aria-live="polite"
      aria-atomic="true"
    >
      <template x-for="toast in toasts" x-bind:key="toast.id">
        <div
          x-show="true"
          x-transition:enter={get_enter_transition(@transition)}
          x-transition:enter-start={get_enter_start_transition(@transition, @position)}
          x-transition:enter-end={get_enter_end_transition(@transition)}
          x-transition:leave={get_leave_transition(@transition)}
          x-transition:leave-start={get_leave_start_transition(@transition)}
          x-transition:leave-end={get_leave_end_transition(@transition, @position)}
          class={
            "w-full relative overflow-hidden mt-2 p-4 rounded-md shadow-lg " <>
            "pointer-events-auto ring-1 ring-black ring-opacity-5"
          }
          x-bind:class="{
            'bg-white': toast.type === 'default',
            'bg-green-50': toast.type === 'success',
            'bg-yellow-50': toast.type === 'warning',
            'bg-red-50': toast.type === 'error',
            'bg-blue-50': toast.type === 'info'
          }"
          role="alert"
        >
          <div class="flex items-start">
            <!-- Type Icon -->
            <div class="flex-shrink-0">
              <span x-show="toast.type === 'success'">
                <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
              </span>
              <span x-show="toast.type === 'error'">
                <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                </svg>
              </span>
              <span x-show="toast.type === 'warning'">
                <svg class="h-5 w-5 text-yellow-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                </svg>
              </span>
              <span x-show="toast.type === 'info'">
                <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                </svg>
              </span>
              <span x-show="toast.type === 'default' && toast.icon">
                <span x-html="toast.icon"></span>
              </span>
            </div>

            <!-- Toast Content -->
            <div class="ml-3 w-0 flex-1">
              <div
                x-bind:class="{
                  'text-green-800': toast.type === 'success',
                  'text-red-800': toast.type === 'error',
                  'text-yellow-800': toast.type === 'warning',
                  'text-blue-800': toast.type === 'info',
                  'text-gray-900': toast.type === 'default'
                }"
              >
                <p x-show="toast.title" x-text="toast.title" class="text-sm font-medium"></p>
                <p x-text="toast.message" class="mt-1 text-sm"></p>

                <!-- Optional Action Button -->
                <div x-show="toast.action" class="mt-3">
                  <button
                    type="button"
                    x-on:click="toast.action.onClick(); remove(toast.id)"
                    x-text="toast.action.text"
                    class="rounded bg-white px-2 py-1.5 text-xs font-medium text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
                  ></button>
                </div>
              </div>
            </div>

            <!-- Close Button -->
            <div class="ml-4 flex flex-shrink-0">
              <button
                type="button"
                x-on:click="remove(toast.id)"
                class="inline-flex rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                <span class="sr-only">Close</span>
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </button>
            </div>
          </div>

          <!-- Progress Bar (only for auto-dismissing toasts) -->
          <div
            x-show="toast.duration > 0"
            class="absolute bottom-0 left-0 right-0 h-1"
            x-bind:class="{
              'bg-green-100': toast.type === 'success',
              'bg-red-100': toast.type === 'error',
              'bg-yellow-100': toast.type === 'warning',
              'bg-blue-100': toast.type === 'info',
              'bg-gray-100': toast.type === 'default'
            }"
          >
            <div
              x-bind:class="{
                'bg-green-500': toast.type === 'success',
                'bg-red-500': toast.type === 'error',
                'bg-yellow-500': toast.type === 'warning',
                'bg-blue-500': toast.type === 'info',
                'bg-indigo-500': toast.type === 'default'
              }"
              class="h-full"
              x-bind:style="{
                width: '100%',
                transition: `width ${toast.duration}ms linear`,
                width: '0%'
              }"
            ></div>
          </div>
        </div>
      </template>
    </div>

    <script>
      window.pineToastHelper = function(options) {
        window.dispatchEvent(
          new CustomEvent('add-toast', {
            detail: options
          })
        );
      };

      window.pineToast = function(message, options = {}) {
        pineToastHelper({
          type: 'default',
          message,
          ...options
        });
      };

      window.pineToastSuccess = function(message, options = {}) {
        pineToastHelper({
          type: 'success',
          message,
          ...options
        });
      };

      window.pineToastError = function(message, options = {}) {
        pineToastHelper({
          type: 'error',
          message,
          ...options
        });
      };

      window.pineToastWarning = function(message, options = {}) {
        pineToastHelper({
          type: 'warning',
          message,
          ...options
        });
      };

      window.pineToastInfo = function(message, options = {}) {
        pineToastHelper({
          type: 'info',
          message,
          ...options
        });
      };
    </script>
    """
  end

  @doc """
  Renders a standalone toast notification.

  This component creates a single toast notification that can be shown directly
  in the UI (not via the notification system).

  ## Examples

      <.toast
        type="success"
        title="Success!"
        message="Your changes have been saved."
      />

      <.toast
        type="error"
        message="Failed to save changes."
        dismissable={true}
      />

  ## Options

  * `:type` - Toast type: "default", "success", "error", "warning", "info" (optional, defaults to "default")
  * `:title` - Toast title text (optional)
  * `:message` - Toast message text (required)
  * `:icon` - HTML string for custom icon (optional, for default type only)
  * `:dismissable` - Whether the toast can be dismissed (optional, defaults to false)
  * `:class` - Additional CSS classes for the toast (optional)
  """
  def toast(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "default" end)
      |> assign_new(:dismissable, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:on_dismiss, fn -> nil end)

    ~H"""
    <div
      x-data="{ show: true }"
      x-show="show"
      x-transition:enter="transform ease-out duration-300 transition"
      x-transition:enter-start="translate-y-2 opacity-0"
      x-transition:enter-end="translate-y-0 opacity-100"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      class={
        "w-full relative overflow-hidden p-4 rounded-md shadow-lg " <>
        "pointer-events-auto ring-1 ring-black ring-opacity-5 #{@class} " <>
        get_toast_bg_color(@type)
      }
      role="alert"
    >
      <div class="flex items-start">
        <!-- Icon -->
        <div class="flex-shrink-0">
          <%= case @type do %>
            <% "success" -> %>
              <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
            <% "error" -> %>
              <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
              </svg>
            <% "warning" -> %>
              <svg class="h-5 w-5 text-yellow-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
            <% "info" -> %>
              <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
              </svg>
            <% _ -> %>
              <%= if Map.has_key?(assigns, :icon) do %>
                <%= @icon %>
              <% end %>
          <% end %>
        </div>

        <!-- Toast Content -->
        <div class="ml-3 w-0 flex-1">
          <div class={get_toast_text_color(@type)}>
            <%= if Map.has_key?(assigns, :title) do %>
              <p class="text-sm font-medium"><%= @title %></p>
            <% end %>
            <p class="mt-1 text-sm"><%= @message %></p>

            <%= if Map.has_key?(assigns, :action) do %>
              <div class="mt-3">
                <button
                  type="button"
                  class="rounded bg-white px-2 py-1.5 text-xs font-medium text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
                  x-on:click={"#{@action[:on_click]}"}
                >
                  <%= @action[:text] %>
                </button>
              </div>
            <% end %>
          </div>
        </div>

        <!-- Close Button -->
        <%= if @dismissable do %>
          <div class="ml-4 flex flex-shrink-0">
            <button
              type="button"
              class="inline-flex rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              x-on:click={"show = false; #{if @on_dismiss, do: @on_dismiss}"}
            >
              <span class="sr-only">Close</span>
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a button that triggers a toast notification.

  This component creates a button that shows a toast notification
  when clicked.

  ## Examples

      <.trigger
        label="Show Success Toast"
        type="success"
        title="Success!"
        message="Operation completed successfully."
      />

  ## Options

  * `:label` - Button text (required)
  * `:type` - Toast type: "default", "success", "error", "warning", "info" (optional, defaults to "default")
  * `:title` - Toast title text (optional)
  * `:message` - Toast message text (required)
  * `:duration` - Duration in milliseconds before auto-dismiss (optional, defaults to 5000, set to 0 to disable)
  * `:position` - Position override for the toast (optional)
  * `:button_class` - CSS classes for the button (optional)
  * `:button_variant` - Button variant: "primary", "secondary", "outline" (optional, defaults to "primary")
  """
  def trigger(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "default" end)
      |> assign_new(:duration, fn -> 5000 end)
      |> assign_new(:button_variant, fn -> "primary" end)
      |> assign_new(:button_class, fn -> "" end)

    # Create the JavaScript object to be passed to the toast function
    toast_options =
      %{
        type: assigns.type,
        message: assigns.message,
        duration: assigns.duration
      }
      |> add_if_present(assigns, :title)
      |> add_if_present(assigns, :position)
      |> add_if_present(assigns, :action)
      |> Jason.encode!()

    ~H"""
    <button
      type="button"
      class={
        case @button_variant do
          "primary" -> "inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          "secondary" -> "inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
          "outline" -> "inline-flex items-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-indigo-600 shadow-sm ring-1 ring-inset ring-indigo-300 hover:bg-indigo-50"
          _ -> "inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        end <> " " <> @button_class
      }
      x-on:click={"window.pineToastHelper(#{toast_options})"}
    >
      <%= @label %>
    </button>
    """
  end

  # Helper functions

  defp add_if_present(map, assigns, key) do
    if Map.has_key?(assigns, key) do
      Map.put(map, key, Map.get(assigns, key))
    else
      map
    end
  end

  defp get_position_class(position) do
    case position do
      "top-right" -> "top-0 right-0"
      "top-left" -> "top-0 left-0"
      "bottom-right" -> "bottom-0 right-0"
      "bottom-left" -> "bottom-0 left-0"
      "top-center" -> "top-0 left-1/2 transform -translate-x-1/2"
      "bottom-center" -> "bottom-0 left-1/2 transform -translate-x-1/2"
      _ -> "top-0 right-0" # Default
    end
  end

  defp get_toast_bg_color(type) do
    case type do
      "success" -> "bg-green-50"
      "error" -> "bg-red-50"
      "warning" -> "bg-yellow-50"
      "info" -> "bg-blue-50"
      _ -> "bg-white"
    end
  end

  defp get_toast_text_color(type) do
    case type do
      "success" -> "text-green-800"
      "error" -> "text-red-800"
      "warning" -> "text-yellow-800"
      "info" -> "text-blue-800"
      _ -> "text-gray-900"
    end
  end

  # Transition classes for animations

  defp get_enter_transition(transition) do
    case transition do
      "fade" -> "transition ease-out duration-300"
      "slide" -> "transform transition ease-out duration-300"
      "zoom" -> "transform transition ease-out duration-300"
      _ -> "transition ease-out duration-300"
    end
  end

  defp get_enter_start_transition(transition, position) do
    case transition do
      "fade" -> "opacity-0"
      "slide" ->
        case position do
          "top-right" -> "translate-x-5 opacity-0"
          "top-left" -> "-translate-x-5 opacity-0"
          "bottom-right" -> "translate-x-5 opacity-0"
          "bottom-left" -> "-translate-x-5 opacity-0"
          "top-center" -> "translate-y-5 opacity-0"
          "bottom-center" -> "-translate-y-5 opacity-0"
          _ -> "translate-x-5 opacity-0"
        end
      "zoom" -> "scale-95 opacity-0"
      _ -> "opacity-0"
    end
  end

  defp get_enter_end_transition(transition) do
    case transition do
      "fade" -> "opacity-100"
      "slide" -> "translate-x-0 translate-y-0 opacity-100"
      "zoom" -> "scale-100 opacity-100"
      _ -> "opacity-100"
    end
  end

  defp get_leave_transition(transition) do
    case transition do
      "fade" -> "transition ease-in duration-200"
      "slide" -> "transform transition ease-in duration-200"
      "zoom" -> "transform transition ease-in duration-200"
      _ -> "transition ease-in duration-200"
    end
  end

  defp get_leave_start_transition(transition) do
    case transition do
      "fade" -> "opacity-100"
      "slide" -> "translate-x-0 translate-y-0 opacity-100"
      "zoom" -> "scale-100 opacity-100"
      _ -> "opacity-100"
    end
  end

  defp get_leave_end_transition(transition, position) do
    case transition do
      "fade" -> "opacity-0"
      "slide" ->
        case position do
          "top-right" -> "translate-x-5 opacity-0"
          "top-left" -> "-translate-x-5 opacity-0"
          "bottom-right" -> "translate-x-5 opacity-0"
          "bottom-left" -> "-translate-x-5 opacity-0"
          "top-center" -> "translate-y-5 opacity-0"
          "bottom-center" -> "-translate-y-5 opacity-0"
          _ -> "translate-x-5 opacity-0"
        end
      "zoom" -> "scale-95 opacity-0"
      _ -> "opacity-0"
    end
  end
end
