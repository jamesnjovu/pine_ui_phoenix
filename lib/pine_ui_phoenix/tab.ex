defmodule PineUiPhoenix.Tabs do
  @moduledoc """
  Provides tabs components for organizing content into selectable panes.

  The Tabs module offers tab navigation components that allow users to switch
  between different content sections within the same area, preserving space
  while maintaining organization.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic tabs component with tab buttons and content panes.

  This component creates a tabbed interface where clicking on a tab button
  displays its associated content pane.

  ## Examples

      <.basic>
        <:tab title="Account Settings" active={true}>
          <p>Content for the Account Settings tab.</p>
        </:tab>
        <:tab title="Profile">
          <p>Content for the Profile tab.</p>
        </:tab>
        <:tab title="Notifications">
          <p>Content for the Notifications tab.</p>
        </:tab>
      </.basic>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the tab button list (optional)
  * `:tab_button_class` - Base CSS classes for all tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active tab button (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive tab buttons (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the following attributes:
    * `:title` - Text displayed in the tab button (required)
    * `:active` - Whether this tab is selected initially (optional, defaults to false)
    * `:disabled` - Whether this tab is disabled (optional, defaults to false)
  """
  slot :tab, required: true do
    attr(:title, :string)
    attr(:active, :string)
    attr(:disabled, :boolean)
  end
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:tab_list_class, fn -> "flex border-b border-gray-200" end)
      |> assign_new(
           :tab_button_class,
           fn ->
             "px-4 py-2 text-sm font-medium focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
           end
         )
      |> assign_new(:tab_button_active_class, fn -> "border-b-2 border-indigo-500 text-indigo-600" end)
      |> assign_new(
           :tab_button_inactive_class,
           fn -> "text-gray-500 hover:text-gray-700 hover:border-b-2 hover:border-gray-300" end
         )
      |> assign_new(:tab_panel_class, fn -> "py-4" end)
      |> assign(:active_tab, get_active_tab_index(assigns))

    ~H"""
    <div class={@class} x-data={"{ activeTab: #{@active_tab} }"}>
      <div class={"#{@tab_list_class}"} role="tablist">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <button
            id={"tab-button-#{index}"}
            role="tab"
            x-on:click={"activeTab = #{index}"}
            aria-controls={"tab-panel-#{index}"}
            aria-selected={"x-bind:aria-selected='activeTab === #{index}'"}
            x-bind:tabindex={"activeTab === #{index} ? 0 : -1"}
            x-bind:class={"activeTab === #{index} ? '#{@tab_button_active_class}' : '#{@tab_button_inactive_class}'"}
            class={"#{@tab_button_class}"}
            {if Map.get(tab, :disabled, false), do: [disabled: true], else: []}
          >
            <%= tab.title %>
          </button>
        <% end %>
      </div>

      <div class="tab-content">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <div
            id={"tab-panel-#{index}"}
            role="tabpanel"
            aria-labelledby={"tab-button-#{index}"}
            x-show={"activeTab === #{index}"}
            x-cloak
            class={"#{@tab_panel_class}"}
          >
            <%= render_slot(tab) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a pill-style tabs component with rounded tab buttons.

  This component creates a tabbed interface with pill-shaped tab buttons.

  ## Examples

      <.pills>
        <:tab title="Overview" active={true}>
          <p>Overview content goes here.</p>
        </:tab>
        <:tab title="Features">
          <p>Features content goes here.</p>
        </:tab>
        <:tab title="Specifications">
          <p>Specifications content goes here.</p>
        </:tab>
      </.pills>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the pill tab list (optional)
  * `:tab_button_class` - Base CSS classes for all pill tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active pill tab (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive pill tabs (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the same attributes as in the `basic/1` component
  """
  slot :tab, required: true do
    attr(:title, :string)
    attr(:active, :string)
    attr(:disabled, :boolean)
  end
  def pills(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:tab_list_class, fn -> "flex space-x-2 mb-4" end)
      |> assign_new(
           :tab_button_class,
           fn ->
             "px-4 py-2 text-sm font-medium rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
           end
         )
      |> assign_new(:tab_button_active_class, fn -> "bg-indigo-600 text-white" end)
      |> assign_new(:tab_button_inactive_class, fn -> "bg-gray-100 text-gray-700 hover:bg-gray-200" end)
      |> assign_new(:tab_panel_class, fn -> "py-4" end)
      |> assign(:active_tab, get_active_tab_index(assigns))

    ~H"""
    <div class={@class} x-data={"{ activeTab: #{@active_tab} }"}>
      <div class={"#{@tab_list_class}"} role="tablist">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <button
            id={"pill-tab-button-#{index}"}
            role="tab"
            x-on:click={"activeTab = #{index}"}
            aria-controls={"pill-tab-panel-#{index}"}
            aria-selected={"x-bind:aria-selected='activeTab === #{index}'"}
            x-bind:tabindex={"activeTab === #{index} ? 0 : -1"}
            x-bind:class={"activeTab === #{index} ? '#{@tab_button_active_class}' : '#{@tab_button_inactive_class}'"}
            class={"#{@tab_button_class}"}
            {if Map.get(tab, :disabled, false), do: [disabled: "true"], else: []}
          >
            <%= tab.title %>
          </button>
        <% end %>
      </div>

      <div class="tab-content">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <div
            id={"pill-tab-panel-#{index}"}
            role="tabpanel"
            aria-labelledby={"pill-tab-button-#{index}"}
            x-show={"activeTab === #{index}"}
            x-cloak
            class={"#{@tab_panel_class}"}
          >
            <%= render_slot(tab) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a boxed tabs component with full-width tab panels and border.

  This component creates a tabbed interface with box-style tabs and
  content panels with a border.

  ## Examples

      <.boxed>
        <:tab title="Comments" active={true}>
          <p>Comments content goes here.</p>
        </:tab>
        <:tab title="Activity">
          <p>Activity content goes here.</p>
        </:tab>
        <:tab title="Archives">
          <p>Archives content goes here.</p>
        </:tab>
      </.boxed>

  ## Options

  * `:class` - Additional CSS classes for the tabs container (optional)
  * `:tab_list_class` - CSS classes for the boxed tab list (optional)
  * `:tab_button_class` - Base CSS classes for all boxed tab buttons (optional)
  * `:tab_button_active_class` - CSS classes added to the active boxed tab (optional)
  * `:tab_button_inactive_class` - CSS classes added to inactive boxed tabs (optional)
  * `:tab_panel_class` - CSS classes for the tab content panels (optional)
  * `:tab` - Tab slots with the same attributes as in the `basic/1` component
  """
  def boxed(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:tab_list_class, fn -> "flex border-b border-gray-200" end)
      |> assign_new(:tab_button_class, fn -> "px-6 py-3 text-sm font-medium focus:outline-none" end)
      |> assign_new(
           :tab_button_active_class,
           fn -> "bg-white border-l border-t border-r border-gray-200 text-indigo-600 rounded-t-md -mb-px" end
         )
      |> assign_new(:tab_button_inactive_class, fn -> "text-gray-500 hover:text-gray-700" end)
      |> assign_new(:tab_panel_class, fn -> "p-6 bg-white border-l border-r border-b border-gray-200 rounded-b-md" end)
      |> assign(:active_tab, get_active_tab_index(assigns))

    ~H"""
    <div class={@class} x-data={"{ activeTab: #{@active_tab} }"}>
      <div class={"#{@tab_list_class}"} role="tablist">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <button
            id={"boxed-tab-button-#{index}"}
            role="tab"
            x-on:click={"activeTab = #{index}"}
            aria-controls={"boxed-tab-panel-#{index}"}
            aria-selected={"x-bind:aria-selected='activeTab === #{index}'"}
            x-bind:tabindex={"activeTab === #{index} ? 0 : -1"}
            x-bind:class={"activeTab === #{index} ? '#{@tab_button_active_class}' : '#{@tab_button_inactive_class}'"}
            class={"#{@tab_button_class}"}
            {if Map.get(tab, :disabled, false), do: [disabled: "true"], else: []}
          >
            <%= tab.title %>
          </button>
        <% end %>
      </div>

      <div class="tab-content">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <div
            id={"boxed-tab-panel-#{index}"}
            role="tabpanel"
            aria-labelledby={"boxed-tab-button-#{index}"}
            x-show={"activeTab === #{index}"}
            x-cloak
            class={"#{@tab_panel_class}"}
          >
            <%= render_slot(tab) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp get_active_tab_index(assigns) do
    case Enum.find_index(assigns.tab, &Map.get(&1, :active, false)) do
      nil -> 0
      # Default to first tab if none is active
      index -> index
    end
  end
end
