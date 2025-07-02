defmodule PineUiPhoenix.DataTable do
  @moduledoc """
  Provides data table components for displaying tabular data with sorting and filtering.

  The DataTable module offers components for creating interactive tables
  that allow users to sort, filter, and paginate through tabular data.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic data table component.

  This component creates a table for displaying tabular data with
  optional sorting, filtering, and pagination.

  ## Examples

      <.basic
        id="users-table"
        columns={[
          %{key: "name", label: "Name", sortable: true},
          %{key: "email", label: "Email"},
          %{key: "role", label: "Role", filterable: true}
        ]}
        data={@users}
      />

      <.basic
        id="products-table"
        columns={@columns}
        data={@products}
        sortable={true}
        filterable={true}
        paginate={true}
        per_page={10}
      />

  ## Options

  * `:id` - Unique identifier for the table (required)
  * `:columns` - List of column configuration maps (required)
  * `:data` - List of data items to display in the table (required)
  * `:sortable` - Whether sorting is enabled globally (optional, defaults to false)
  * `:filterable` - Whether filtering is enabled globally (optional, defaults to false)
  * `:paginate` - Whether pagination is enabled (optional, defaults to false)
  * `:per_page` - Number of items per page when pagination is enabled (optional, defaults to 10)
  * `:selectable` - Whether rows can be selected with checkboxes (optional, defaults to false)
  * `:class` - Additional CSS classes for the table container (optional)
  * `:table_class` - CSS classes for the table element (optional)
  * `:empty_state` - Content to display when there are no rows to show (optional)
  * `:row_click` - Event name or function to call when a row is clicked (optional)
  * `:on_selection_change` - Event name or function to call when selection changes (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:sortable, fn -> false end)
      |> assign_new(:filterable, fn -> false end)
      |> assign_new(:paginate, fn -> false end)
      |> assign_new(:per_page, fn -> 10 end)
      |> assign_new(:selectable, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:table_class, fn -> "" end)
      |> assign_new(:empty_state, fn -> nil end)
      |> assign_new(:row_click, fn -> nil end)
      |> assign_new(:on_selection_change, fn -> nil end)

    # Process columns to ensure they have required properties
    columns =
      Enum.map(
        assigns.columns,
        fn column ->
          Map.merge(
            %{
              key: nil,
              label: "",
              sortable: assigns.sortable,
              filterable: assigns.filterable,
              width: nil,
              align: "left",
              render: nil
            },
            column
          )
        end
      )

    assigns = assign(assigns, :processed_columns, columns)

    ~H"""
    <div
      id={@id}
      class={"w-full #{@class}"}
      x-data={"{
        columns: #{Jason.encode!(@processed_columns)},
        data: #{Jason.encode!(@data)},
        filteredData: [],
        displayData: [],
        sortColumn: null,
        sortDirection: 'asc',
        searchTerms: {},
        selectedRows: [],
        currentPage: 1,
        perPage: #{@per_page},

        init() {
          // Initialize search terms for each filterable column
          this.columns.forEach(column => {
            if (column.filterable) {
              this.searchTerms[column.key] = '';
            }
          });

          // Set initial filtered and display data
          this.filteredData = [...this.data];
          this.updateDisplayData();

          // Watch for changes that require updating the display
          this.$watch('searchTerms', () => {
            this.applyFilters();
            this.currentPage = 1; // Reset to first page when filters change
          });

          this.$watch('currentPage', () => {
            this.updateDisplayData();
          });

          this.$watch('selectedRows', () => {
            #{if @on_selection_change, do: @on_selection_change, else: ""}
          });
        },

        // Sorting functions
        sortBy(columnKey) {
          if (this.sortColumn === columnKey) {
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
          } else {
            this.sortColumn = columnKey;
            this.sortDirection = 'asc';
          }

          this.filteredData.sort((a, b) => {
            const valueA = a[columnKey];
            const valueB = b[columnKey];

            if (valueA === valueB) return 0;

            if (this.sortDirection === 'asc') {
              if (typeof valueA === 'string' && typeof valueB === 'string') {
                return valueA.localeCompare(valueB);
              }
              return valueA < valueB ? -1 : 1;
            } else {
              if (typeof valueA === 'string' && typeof valueB === 'string') {
                return valueB.localeCompare(valueA);
              }
              return valueA > valueB ? -1 : 1;
            }
          });

          this.updateDisplayData();
        },

        // Filtering functions
        applyFilters() {
          this.filteredData = this.data.filter(item => {
            return Object.keys(this.searchTerms).every(key => {
              const term = this.searchTerms[key].toLowerCase();
              if (!term) return true;

              const value = item[key];
              if (typeof value === 'string') {
                return value.toLowerCase().includes(term);
              } else if (value !== null && value !== undefined) {
                return value.toString().toLowerCase().includes(term);
              }
              return false;
            });
          });

          // Re-apply sorting if active
          if (this.sortColumn) {
            this.sortBy(this.sortColumn);
          } else {
            this.updateDisplayData();
          }
        },

        // Pagination functions
        updateDisplayData() {
          if (#{@paginate}) {
            const startIndex = (this.currentPage - 1) * this.perPage;
            this.displayData = this.filteredData.slice(startIndex, startIndex + this.perPage);
          } else {
            this.displayData = this.filteredData;
          }
        },

        get totalPages() {
          return Math.ceil(this.filteredData.length / this.perPage);
        },

        nextPage() {
          if (this.currentPage < this.totalPages) {
            this.currentPage++;
          }
        },

        prevPage() {
          if (this.currentPage > 1) {
            this.currentPage--;
          }
        },

        goToPage(page) {
          this.currentPage = page;
        },

        // Selection functions
        toggleSelectAll() {
          if (this.selectedRows.length === this.displayData.length) {
            this.selectedRows = [];
          } else {
            this.selectedRows = [...Array(this.displayData.length).keys()];
          }
        },

        isSelected(index) {
          return this.selectedRows.includes(index);
        },

        toggleRowSelection(index) {
          const position = this.selectedRows.indexOf(index);
          if (position === -1) {
            this.selectedRows.push(index);
          } else {
            this.selectedRows.splice(position, 1);
          }
        }
      }"}
    >
      <!-- Table Filters -->

    </div>
    """
  end

  @doc """
  Renders a data table with expandable rows.

  This component creates a table where rows can be expanded to show additional details.

  ## Examples

      <.expandable
        id="orders-table"
        columns={[
          %{key: "order_id", label: "Order ID"},
          %{key: "customer", label: "Customer"},
          %{key: "date", label: "Date"},
          %{key: "status", label: "Status"}
        ]}
        data={@orders}
      >
        <:expanded_row :let={row}>
          <div class="p-4 bg-gray-50">
            <h3 class="font-medium">Order Details</h3>
            <p>Items: <%= row.items.length %></p>
            <p>Total: $<%= row.total %></p>
          </div>
        </:expanded_row>
      </.expandable>

  ## Options

  * `:id` - Unique identifier for the table (required)
  * `:columns` - List of column configuration maps (required)
  * `:data` - List of data items to display in the table (required)
  * `:sortable` - Whether sorting is enabled globally (optional, defaults to false)
  * `:filterable` - Whether filtering is enabled globally (optional, defaults to false)
  * `:paginate` - Whether pagination is enabled (optional, defaults to false)
  * `:per_page` - Number of items per page when pagination is enabled (optional, defaults to 10)
  * `:class` - Additional CSS classes for the table container (optional)
  * `:table_class` - CSS classes for the table element (optional)
  * `:empty_state` - Content to display when there are no rows to show (optional)
  * `:expanded_row` - Slot for customizing the expanded row content (required)
  """
  def expandable(assigns) do
    assigns =
      assigns
      |> assign_new(:sortable, fn -> false end)
      |> assign_new(:filterable, fn -> false end)
      |> assign_new(:paginate, fn -> false end)
      |> assign_new(:per_page, fn -> 10 end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:table_class, fn -> "" end)
      |> assign_new(:empty_state, fn -> nil end)

    # Process columns to ensure they have required properties
    columns =
      Enum.map(
        assigns.columns,
        fn column ->
          Map.merge(
            %{
              key: nil,
              label: "",
              sortable: assigns.sortable,
              filterable: assigns.filterable,
              width: nil,
              align: "left",
              render: nil
            },
            column
          )
        end
      )

    assigns = assign(assigns, :processed_columns, columns)

    ~H"""
    ...
    """
  end
end
