defmodule PineUi do
  @moduledoc """
  Documentation for `PineUi`.
  """

  use Phoenix.Component

  alias PineUi.{
    Text,
    Tooltip
  }

  @doc """
  Typing Effect.

  ## Examples

      <PineUi.typing_effect
        text_list={Poison.encode!(["I'm here james", "All mightily push"])}
        class="item-center justify-center"
        text_class="text-2xl font-black leading-tight"
      />
  """
  def typing_effect(assigns) do
    assigns =
      assign_new(assigns, :text_list, fn ->
        Poison.encode!(["Alpine JS is Amazing", "It is Truly Awesome!", "You Have to Try It!"])
      end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:text_class, fn -> "text-2xl font-black leading-tight" end)

    Text.typing_effect(assigns)
  end

  @doc """
  Tooltip Top.

  ## Examples

      <PineUI.tooltip_top
        title="Hover Me"
        description="Tooltip text"
        class="px-3 py-1 text-xs rounded-full cursor-pointer text-neutral-500 bg-neutral-100"
      />
  """
  def tooltip_top(assigns) do
    assigns =
      assign_new(assigns, :title, fn -> "hover me" end)
      |> assign_new(:description, fn -> "Tooltip text" end)
      |> assign_new(:type, fn -> nil end)
      |> assign_new(:class, fn ->
        "px-3 py-1 text-xs rounded-full cursor-pointer text-neutral-500 bg-neutral-100"
      end)

    case assigns.type do
      "left" -> Tooltip.left(assigns)
      "right" -> Tooltip.right(assigns)
      _ -> Tooltip.top(assigns)
    end
  end
end
