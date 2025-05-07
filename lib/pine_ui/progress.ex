defmodule PineUi.Progress do
  @moduledoc """
  Provides progress indicator components for displaying completion status.

  The Progress module offers components for showing progress in various forms:
  - `bar/1` - Standard progress bar with customizable appearance
  - `circle/1` - Circular progress indicator
  - `steps/1` - Multi-step progress indicator for workflows
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a progress bar component.

  This component creates a horizontal progress bar that visually represents
  completion progress.

  ## Examples

      <.bar value={75} />

      <.bar
        value={42}
        max={100}
        label="Uploading..."
        show_percentage={true}
        size="lg"
        variant="indigo"
      />

  ## Options

  * `:value` - Current progress value (required)
  * `:max` - Maximum value representing 100% completion (optional, defaults to 100)
  * `:label` - Text label for the progress bar (optional)
  * `:show_percentage` - Whether to show percentage text (optional, defaults to false)
  * `:size` - Size of the bar: "sm", "md", "lg" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the progress container (optional)
  * `:bar_class` - CSS classes for the progress bar itself (optional)
  * `:label_class` - CSS classes for the label text (optional)
  """
  def bar(assigns) do
    assigns =
      assigns
      |> assign_new(:max, fn -> 100 end)
      |> assign_new(:show_percentage, fn -> false end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:bar_class, fn -> "" end)
      |> assign_new(:label_class, fn -> "" end)
      |> assign(:percentage, calculate_percentage(assigns.value, assigns.max))

    ~H"""
    <div class={"w-full #{@class}"}>
      <%= if Map.has_key?(assigns, :label) do %>
        <div class="flex justify-between mb-1">
          <span class={"text-sm font-medium text-gray-700 #{@label_class}"}><%= @label %></span>
          <%= if @show_percentage do %>
            <span class="text-sm font-medium text-gray-700"><%= @percentage %>%</span>
          <% end %>
        </div>
      <% end %>

      <div class={"w-full #{get_track_size_class(@size)} #{get_track_bg_class(@variant)} rounded-full overflow-hidden"}>
      <div
        class={"#{get_bar_size_class(@size)} #{get_bar_color_class(@variant)} rounded-full #{@bar_class}"}
        style={"width: #{@percentage}%"}
        role="progressbar"
        aria-valuenow={@value}
        aria-valuemin="0"
        aria-valuemax={@max}
        aria-label={if Map.has_key?(assigns, :label), do: "#{@label}: #{@percentage}%", else: "#{@percentage}%"}
      >
        <%= if @show_percentage and not Map.has_key?(assigns, :label) do %>
          <span class={"block text-center text-xs font-medium #{get_bar_text_class(@size)} text-white"}><%= @percentage %>%</span>
        <% end %>
      </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a circular progress indicator.

  This component creates a circular progress indicator with customizable appearance.

  ## Examples

      <.circle value={75} />

      <.circle
        value={42}
        max={100}
        label="Uploading..."
        show_percentage={true}
        size="lg"
        variant="indigo"
      />

  ## Options

  * `:value` - Current progress value (required)
  * `:max` - Maximum value representing 100% completion (optional, defaults to 100)
  * `:label` - Text label for the progress circle (optional)
  * `:show_percentage` - Whether to show percentage text inside the circle (optional, defaults to false)
  * `:size` - Size of the circle: "sm", "md", "lg", "xl" (optional, defaults to "md")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:track_width` - Width of the circle track: "thin", "normal", "thick" (optional, defaults to "normal")
  * `:class` - Additional CSS classes for the progress container (optional)
  * `:circle_class` - CSS classes for the circle itself (optional)
  * `:label_class` - CSS classes for the label text (optional)
  """
  def circle(assigns) do
    assigns =
      assigns
      |> assign_new(:max, fn -> 100 end)
      |> assign_new(:show_percentage, fn -> false end)
      |> assign_new(:size, fn -> "md" end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:track_width, fn -> "normal" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:circle_class, fn -> "" end)
      |> assign_new(:label_class, fn -> "" end)
      |> assign(:percentage, calculate_percentage(assigns.value, assigns.max))
      |> assign(:circumference, 2 * :math.pi() * 40) # SVG circle has r=40 as a base value
      |> assign(
           :stroke_dashoffset,
           fn percentage ->
             2 * :math.pi() * 40 * (1 - percentage / 100)
           end
         )

    ~H"""
    <div class={"flex flex-col items-center #{@class}"}>
      <div class={"relative #{get_circle_container_size_class(@size)} #{@circle_class}"}>
        <svg class="w-full h-full" viewBox="0 0 100 100">
          <!-- Background circle -->
          <circle
            class={"#{get_track_bg_class(@variant)}"}
            cx="50"
            cy="50"
            r="40"
            fill="none"
            stroke-width={get_track_width(@track_width)}
          />

          <!-- Progress circle -->
          <circle
            class={"#{get_bar_color_class(@variant)} transition-all duration-500"}
            cx="50"
            cy="50"
            r="40"
            fill="none"
            stroke-width={get_track_width(@track_width)}
            stroke-dasharray={@circumference}
            stroke-dashoffset={@stroke_dashoffset.(@percentage)}
            transform="rotate(-90 50 50)"
          />
        </svg>

        <%= if @show_percentage do %>
          <div class="absolute inset-0 flex items-center justify-center">
            <span class={"#{get_circle_text_size_class(@size)} font-semibold text-gray-800"}>
              <%= @percentage %>%
            </span>
          </div>
        <% end %>
      </div>

      <%= if Map.has_key?(assigns, :label) do %>
        <div class={"mt-2 text-center #{@label_class}"}>
          <span class={"#{get_label_size_class(@size)} font-medium text-gray-700"}>
            <%= @label %>
          </span>
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a multi-step progress indicator.

  This component creates a horizontal step indicator for processes or workflows.

  ## Examples

      <.steps
        steps={["Cart", "Shipping", "Payment", "Confirmation"]}
        current_step={2}
      />

      <.steps
        steps={[
          %{title: "Account", description: "Personal information"},
          %{title: "Profile", description: "Additional details"},
          %{title: "Complete", description: "Review submission"}
        ]}
        current_step={1}
        variant="green"
      />

  ## Options

  * `:steps` - List of step titles or maps with title and description (required)
  * `:current_step` - Index of the current active step (0-based, required)
  * `:orientation` - Direction of the steps: "horizontal" or "vertical" (optional, defaults to "horizontal")
  * `:variant` - Color variant: "indigo", "blue", "green", "red", "amber" (optional, defaults to "indigo")
  * `:class` - Additional CSS classes for the steps container (optional)
  * `:connector_class` - CSS classes for the connecting lines (optional)
  * `:step_class` - CSS classes for the step indicators (optional)
  """
  def steps(assigns) do
    assigns =
      assigns
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign_new(:variant, fn -> "indigo" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:connector_class, fn -> "" end)
      |> assign_new(:step_class, fn -> "" end)
      |> assign(:total_steps, length(assigns.steps))

    ~H"""
    <div class={
      case @orientation do
        "horizontal" -> "w-full #{@class}"
        "vertical" -> "flex flex-col space-y-4 #{@class}"
      end
    }>
      <div class={
        case @orientation do
          "horizontal" -> "flex items-center"
          "vertical" -> "flex flex-col space-y-6"
        end
      }>
        <%= for {step, index} <- Enum.with_index(@steps) do %>
          <div class={
            case @orientation do
              "horizontal" -> "flex-1 relative"
              "vertical" -> "flex"
            end
          }>
            <div class={
              case @orientation do
                "horizontal" -> "flex items-center"
                "vertical" -> "flex items-start"
              end
            }>
              <!-- Step circle -->
              <div class={get_step_status_class(index, @current_step, @variant, @step_class)}>
                <%= if index <= @current_step do %>
                  <svg class="w-5 h-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <%= if index < @current_step do %>
                      <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                    <% else %>
                      <circle cx="10" cy="10" r="3" />
                    <% end %>
                  </svg>
                <% else %>
                  <span class="text-xs font-medium"><%= index + 1 %></span>
                <% end %>
              </div>

              <!-- Step content -->
              <div class={
                case @orientation do
                  "horizontal" -> "ml-2 absolute -top-7 w-full"
                  "vertical" -> "ml-4"
                end
              }>
                <%= if is_map(step) do %>
                  <span class={
                    "block text-sm font-medium " <>
                    if(index <= @current_step, do: "text-gray-900", else: "text-gray-500")
                  }>
                    <%= step.title %>
                  </span>
                  <%= if Map.has_key?(step, :description) do %>
                    <span class="block text-xs text-gray-500"><%= step.description %></span>
                  <% end %>
                <% else %>
                  <span class={
                    "block text-sm font-medium " <>
                    if(index <= @current_step, do: "text-gray-900", else: "text-gray-500")
                  }>
                    <%= step %>
                  </span>
                <% end %>
              </div>
            </div>

            <!-- Connector line - not for the last item -->
            <%= if index < @total_steps - 1 do %>
              <div class={
                case @orientation do
                  "horizontal" -> "top-4 w-full flex-1 ml-5 #{@connector_class}"
                  "vertical" -> "ml-3 mt-3 h-10 w-0.5 #{@connector_class}"
                end <> " " <> if(index < @current_step, do: get_connector_active_class(@variant), else: "bg-gray-200")
              }></div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # Helper functions for calculations

  defp calculate_percentage(value, max) do
    percentage = trunc(value / max * 100)

    cond do
      percentage < 0 -> 0
      percentage > 100 -> 100
      true -> percentage
    end
  end

  # Helper functions for CSS classes

  defp get_track_size_class(size) do
    case size do
      "sm" -> "h-1.5"
      "md" -> "h-2.5"
      "lg" -> "h-4"
      _ -> "h-2.5" # Default
    end
  end

  defp get_bar_size_class(size) do
    case size do
      "sm" -> "h-1.5"
      "md" -> "h-2.5"
      "lg" -> "h-4"
      _ -> "h-2.5" # Default
    end
  end

  defp get_bar_text_class(size) do
    case size do
      "sm" -> "text-[8px] leading-[6px]"
      "md" -> "text-[10px] leading-[10px]"
      "lg" -> "text-xs leading-4"
      _ -> "text-[10px] leading-[10px]" # Default
    end
  end

  defp get_track_bg_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-100"
      "blue" -> "bg-blue-100"
      "green" -> "bg-green-100"
      "red" -> "bg-red-100"
      "amber" -> "bg-amber-100"
      _ -> "bg-indigo-100" # Default
    end
  end

  defp get_bar_color_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-600"
      "blue" -> "bg-blue-600"
      "green" -> "bg-green-600"
      "red" -> "bg-red-600"
      "amber" -> "bg-amber-600"
      _ -> "bg-indigo-600" # Default
    end
  end

  defp get_circle_container_size_class(size) do
    case size do
      "sm" -> "w-16 h-16"
      "md" -> "w-24 h-24"
      "lg" -> "w-32 h-32"
      "xl" -> "w-40 h-40"
      _ -> "w-24 h-24" # Default
    end
  end

  defp get_circle_text_size_class(size) do
    case size do
      "sm" -> "text-sm"
      "md" -> "text-base"
      "lg" -> "text-lg"
      "xl" -> "text-xl"
      _ -> "text-base" # Default
    end
  end

  defp get_track_width(width) do
    case width do
      "thin" -> "4"
      "normal" -> "8"
      "thick" -> "12"
      _ -> "8" # Default
    end
  end

  defp get_label_size_class(size) do
    case size do
      "sm" -> "text-xs"
      "md" -> "text-sm"
      "lg" -> "text-base"
      "xl" -> "text-lg"
      _ -> "text-sm" # Default
    end
  end

  defp get_step_status_class(index, current_step, variant, additional_class) do
    base_class = "flex items-center justify-center w-8 h-8 rounded-full"

    color_class =
      cond do
        index < current_step ->
          case variant do
            "indigo" -> "bg-indigo-600"
            "blue" -> "bg-blue-600"
            "green" -> "bg-green-600"
            "red" -> "bg-red-600"
            "amber" -> "bg-amber-600"
            _ -> "bg-indigo-600" # Default
          end
        index == current_step ->
          case variant do
            "indigo" -> "bg-indigo-600"
            "blue" -> "bg-blue-600"
            "green" -> "bg-green-600"
            "red" -> "bg-red-600"
            "amber" -> "bg-amber-600"
            _ -> "bg-indigo-600" # Default
          end
        true -> "bg-white border-2 border-gray-300 text-gray-500"
      end

    "#{base_class} #{color_class} #{additional_class}"
  end

  defp get_connector_active_class(variant) do
    case variant do
      "indigo" -> "bg-indigo-600"
      "blue" -> "bg-blue-600"
      "green" -> "bg-green-600"
      "red" -> "bg-red-600"
      "amber" -> "bg-amber-600"
      _ -> "bg-indigo-600" # Default
    end
  end
end
