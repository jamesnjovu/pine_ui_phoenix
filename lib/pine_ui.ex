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
  Text Animation Blow.

  ## Examples

      <PineUi.text_animation_blow text="Pines UI Library" />
  """
  def text_animation_blow(assigns) do
    assigns = assign_new(assigns, :text, fn -> "Pines UI Library" end)

    Text.animation_blow(assigns)
  end

  @doc """
  Tooltip.

  ## Examples

      <PineUi.tooltip
        title="Hover Me"
        description="Tooltip text"
        class="px-3 py-1 text-xs rounded-full cursor-pointer text-neutral-500 bg-neutral-100"
      />
  """
  def tooltip(assigns) do
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

  @doc """
  Text Animation Fade.

  ## Examples

      <PineUI.text_animation_fade text="Pines UI Library" />
  """
  def text_animation_fade(assigns) do
    assigns = assign_new(assigns, :text, fn -> "Pines UI Library" end)

    Text.animation_fade(assigns)
  end
end
