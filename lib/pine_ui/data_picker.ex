defmodule PineUi.DatePicker do
  @moduledoc """
  Provides date picker components for selecting dates and date ranges.

  The DatePicker module offers components for selecting single dates
  and date ranges with calendar interfaces.
  """
  use Phoenix.Component
  import Phoenix.HTML
  import Phoenix.HTML.Form

  @doc """
  Renders a basic date picker component.

  This component creates a date picker for selecting a single date.

  ## Examples

      <.basic
        id="event-date"
        name="event[date]"
        label="Event Date"
      />

      <.basic
        id="appointment-date"
        name="appointment[date]"
        label="Appointment Date"
        min="2023-01-01"
        max="2023-12-31"
        format="MM/DD/YYYY"
        value="2023-06-15"
      />

  ## Options

  * `:id` - The ID for the input element (required)
  * `:name` - The name attribute for the input (optional, defaults to ID)
  * `:label` - Label text for the input (optional)
  * `:value` - Current date value in ISO format (YYYY-MM-DD) (optional)
  * `:min` - Minimum selectable date in ISO format (optional)
  * `:max` - Maximum selectable date in ISO format (optional)
  * `:format` - Date display format: "YYYY-MM-DD", "MM/DD/YYYY", "DD/MM/YYYY" (optional, defaults to "YYYY-MM-DD")
  * `:placeholder` - Placeholder text when no date is selected (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:disabled` - Whether the input is disabled (optional, defaults to false)
  * `:required` - Whether the input is required (optional, defaults to false)
  * `:class` - Additional CSS classes for the container (optional)
  * `:input_class` - CSS classes for the input element (optional)
  * `:calendar_class` - CSS classes for the calendar dropdown (optional)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  """
  def basic(assigns) do
    assigns =
        assigns
        |> assign_new(:name, fn -> assigns.id end)
        |> assign_new(:format, fn -> "YYYY-MM-DD" end)
        |> assign_new(:placeholder, fn -> "Select date..." end)
        |> assign_new(:disabled, fn -> false end)
        |> assign_new(:required, fn -> false end)
        |> assign_new(:class, fn -> "" end)
        |> assign_new(:input_class, fn -> "" end)
        |> assign_new(:calendar_class, fn -> "" end)
        |> assign_new(:phx_change, fn -> nil end)
        |> assign_new(:phx_blur, fn -> nil end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class={"relative #{@class}"}
      x-data={"{
        datePickerOpen: false,
        date: '#{Map.get(assigns, :value, "")}',
        displayValue: '',
        dateFormat: '#{@format}',
        minDate: '#{Map.get(assigns, :min, "")}',
        maxDate: '#{Map.get(assigns, :max, "")}',
        currentMonth: null,
        currentYear: null,
        daysInMonth: [],

        init() {
          if (this.date) {
            this.displayValue = this.formatDate(this.date);
            const date = new Date(this.date);
            this.currentMonth = date.getMonth();
            this.currentYear = date.getFullYear();
          } else {
            const today = new Date();
            this.currentMonth = today.getMonth();
            this.currentYear = today.getFullYear();
          }

          this.calculateDays();

          // Watch for changes to the date
          this.$watch('date', (newValue) => {
            this.displayValue = this.formatDate(newValue);

            // Set value of the hidden input
            const hiddenInput = document.getElementById('#{@id}');
            hiddenInput.value = newValue;

            // Trigger change event
            const event = new Event('change', { bubbles: true });
            hiddenInput.dispatchEvent(event);
          });
        },

        isDisabled(dateString) {
          if (!dateString) return false;

          if (this.minDate && dateString < this.minDate) {
            return true;
          }

          if (this.maxDate && dateString > this.maxDate) {
            return true;
          }

          return false;
        },

        calculateDays() {
          this.daysInMonth = [];

          const firstDay = new Date(this.currentYear, this.currentMonth, 1);
          const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0);
          const daysInMonth = lastDay.getDate();

          // Add empty cells for days before first day of month
          const firstDayOfWeek = firstDay.getDay(); // 0 = Sunday, 1 = Monday, ...
          for (let i = 0; i < firstDayOfWeek; i++) {
            this.daysInMonth.push({ day: '', date: null });
          }

          // Add days of the month
          for (let day = 1; day <= daysInMonth; day++) {
            const date = new Date(this.currentYear, this.currentMonth, day);
            const dateString = this.formatISODate(date);
            this.daysInMonth.push({
              day: day,
              date: dateString,
              isToday: this.isToday(date),
              isSelected: dateString === this.date,
              isDisabled: this.isDisabled(dateString)
            });
          }
        },

        nextMonth() {
          if (this.currentMonth === 11) {
            this.currentMonth = 0;
            this.currentYear++;
          } else {
            this.currentMonth++;
          }
          this.calculateDays();
        },

        prevMonth() {
          if (this.currentMonth === 0) {
            this.currentMonth = 11;
            this.currentYear--;
          } else {
            this.currentMonth--;
          }
          this.calculateDays();
        },

        selectDate(dateString) {
          if (!dateString || this.isDisabled(dateString)) return;

          this.date = dateString;
          this.datePickerOpen = false;
        },

        clearDate() {
          this.date = '';
          this.displayValue = '';
        },

        isToday(date) {
          const today = new Date();
          return date.getDate() === today.getDate() &&
                 date.getMonth() === today.getMonth() &&
                 date.getFullYear() === today.getFullYear();
        },

        formatDate(dateString) {
          if (!dateString) return '';

          const date = new Date(dateString);
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');

          switch (this.dateFormat) {
            case 'MM/DD/YYYY':
              return `${month}/${day}/${year}`;
            case 'DD/MM/YYYY':
              return `${day}/${month}/${year}`;
            default: // YYYY-MM-DD
              return `${year}-${month}-${day}`;
          }
        },

        formatISODate(date) {
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');
          return `${year}-${month}-${day}`;
        },

        parseDate(value) {
          if (!value) return null;

          let year, month, day;

          switch (this.dateFormat) {
            case 'MM/DD/YYYY':
              [month, day, year] = value.split('/');
              break;
            case 'DD/MM/YYYY':
              [day, month, year] = value.split('/');
              break;
            default: // YYYY-MM-DD
              [year, month, day] = value.split('-');
              break;
          }

          if (!year || !month || !day) return null;

          // Ensure values are padded correctly
          month = String(parseInt(month)).padStart(2, '0');
          day = String(parseInt(day)).padStart(2, '0');

          return `${year}-${month}-${day}`;
        },

        handleInputChange(e) {
          this.displayValue = e.target.value;
          this.date = this.parseDate(this.displayValue);
        },

        getMonthName(month) {
          const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
          return monthNames[month];
        }
      }"}
      x-on:click.away="datePickerOpen = false"
      x-on:keydown.escape="datePickerOpen = false"
    >
      <%= if Map.has_key?(assigns, :label) do %>
        <label for={"#{@id}-display"} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <div class="relative">
        <!-- Display Input -->
        <input
          type="text"
          id={"#{@id}-display"}
          x-model="displayValue"
          x-on:focus="datePickerOpen = true"
          x-on:input="handleInputChange($event)"
          placeholder={@placeholder}
          class={"block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{@input_class}"}
          autocomplete="off"
          disabled={@disabled}
          required={@required}
        />

        <!-- Calendar Icon -->
        <div
          class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer"
          x-on:click="datePickerOpen = !datePickerOpen"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>

        <!-- Hidden Input for Form Submission -->
        <input
          type="hidden"
          id={@id}
          name={@name}
          value={Map.get(assigns, :value, "")}
          phx-change={@phx_change}
          phx-blur={@phx_blur}
        />

        <!-- Calendar Dropdown -->
        <div
          x-show="datePickerOpen"
          x-transition:enter="transition ease-out duration-200"
          x-transition:enter-start="opacity-0 translate-y-1"
          x-transition:enter-end="opacity-100 translate-y-0"
          x-transition:leave="transition ease-in duration-150"
          x-transition:leave-start="opacity-100 translate-y-0"
          x-transition:leave-end="opacity-0 translate-y-1"
          class={"absolute z-10 mt-1 bg-white shadow-lg rounded-md p-4 #{@calendar_class}"}
          style="width: 320px"
          x-cloak
        >
          <!-- Calendar Header -->
          <div class="flex justify-between items-center mb-4">
            <button
              type="button"
              class="p-1 rounded-full hover:bg-gray-100"
              x-on:click.prevent="prevMonth"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
            </button>

            <div class="text-lg font-semibold text-gray-800">
              <span x-text="getMonthName(currentMonth)"></span>
              <span x-text="currentYear"></span>
            </div>

            <button
              type="button"
              class="p-1 rounded-full hover:bg-gray-100"
              x-on:click.prevent="nextMonth"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>

          <!-- Weekday Headers -->
          <div class="grid grid-cols-7 gap-1 mb-2">
            <div class="text-center text-xs font-medium text-gray-500">Su</div>
            <div class="text-center text-xs font-medium text-gray-500">Mo</div>
            <div class="text-center text-xs font-medium text-gray-500">Tu</div>
            <div class="text-center text-xs font-medium text-gray-500">We</div>
            <div class="text-center text-xs font-medium text-gray-500">Th</div>
            <div class="text-center text-xs font-medium text-gray-500">Fr</div>
            <div class="text-center text-xs font-medium text-gray-500">Sa</div>
          </div>

          <!-- Calendar Days -->
          <div class="grid grid-cols-7 gap-1">
            <template x-for="(day, index) in daysInMonth" x-bind:key="index">
              <div
                x-on:click="selectDate(day.date)"
                x-bind:class="{
                  'text-center p-2 rounded-md text-sm cursor-pointer': true,
                  'bg-indigo-600 text-white hover:bg-indigo-700': day.isSelected,
                  'text-gray-800 hover:bg-gray-100': !day.isSelected && !day.isDisabled && day.date,
                  'text-gray-400': !day.date,
                  'bg-gray-100 text-gray-800 ring-1 ring-indigo-500 ring-offset-2 ring-offset-white': day.isToday && !day.isSelected,
                  'opacity-50 cursor-not-allowed': day.isDisabled
                }"
              >
                <span x-text="day.day"></span>
              </div>
            </template>
          </div>

          <!-- Calendar Footer -->
          <div class="mt-4 flex justify-between">
            <button
              type="button"
              class="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 rounded-md"
              x-on:click="clearDate"
            >
              Clear
            </button>

            <button
              type="button"
              class="px-4 py-2 text-sm text-white bg-indigo-600 hover:bg-indigo-700 rounded-md"
              x-on:click="datePickerOpen = false"
            >
              Done
            </button>
          </div>
        </div>
      </div>

      <!-- Hint & Error Messages -->
      <%= if Map.has_key?(assigns, :hint) do %>
        <p class="mt-1 text-sm text-gray-500"><%= @hint %></p>
      <% end %>

      <%= if Map.has_key?(assigns, :error) do %>
        <p class="mt-1 text-sm text-red-600"><%= @error %></p>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a date range picker component.

  This component creates a date picker for selecting a start and end date range.

  ## Examples

      <.range
        id="date-range"
        name_start="start_date"
        name_end="end_date"
        label="Date Range"
      />

      <.range
        id="booking"
        name_start="booking[start_date]"
        name_end="booking[end_date]"
        label="Booking Period"
        value_start="2023-06-15"
        value_end="2023-06-30"
        min="2023-01-01"
        max="2023-12-31"
      />

  ## Options

  * `:id` - The ID prefix for the input elements (required)
  * `:name_start` - The name attribute for the start date input (required)
  * `:name_end` - The name attribute for the end date input (required)
  * `:label` - Label text for the input (optional)
  * `:value_start` - Current start date value in ISO format (optional)
  * `:value_end` - Current end date value in ISO format (optional)
  * `:min` - Minimum selectable date in ISO format (optional)
  * `:max` - Maximum selectable date in ISO format (optional)
  * `:format` - Date display format: "YYYY-MM-DD", "MM/DD/YYYY", "DD/MM/YYYY" (optional, defaults to "YYYY-MM-DD")
  * `:placeholder_start` - Placeholder text for start date input (optional)
  * `:placeholder_end` - Placeholder text for end date input (optional)
  * `:hint` - Help text displayed below the input (optional)
  * `:error` - Error message displayed below the input (optional)
  * `:disabled` - Whether the inputs are disabled (optional, defaults to false)
  * `:required` - Whether the inputs are required (optional, defaults to false)
  * `:class` - Additional CSS classes for the container (optional)
  * `:input_class` - CSS classes for the input elements (optional)
  * `:calendar_class` - CSS classes for the calendar dropdown (optional)
  * `:phx_change` - Phoenix change event name (optional)
  * `:phx_blur` - Phoenix blur event name (optional)
  """
  def range(assigns) do
    assigns =
      assigns
      |> assign_new(:format, fn -> "YYYY-MM-DD" end)
      |> assign_new(:placeholder_start, fn -> "Start date" end)
      |> assign_new(:placeholder_end, fn -> "End date" end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:required, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:input_class, fn -> "" end)
      |> assign_new(:calendar_class, fn -> "" end)
      |> assign_new(:phx_change, fn -> nil end)
      |> assign_new(:phx_blur, fn -> nil end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class={"relative #{@class}"}
      x-data={"{
        datePickerOpen: false,
        startDate: '#{Map.get(assigns, :value_start, "")}',
        endDate: '#{Map.get(assigns, :value_end, "")}',
        displayStartValue: '',
        displayEndValue: '',
        dateFormat: '#{@format}',
        minDate: '#{Map.get(assigns, :min, "")}',
        maxDate: '#{Map.get(assigns, :max, "")}',
        currentMonth: null,
        currentYear: null,
        daysInMonth: [],
        selectingStartDate: true,
        hoverDate: null,

        init() {
          if (this.startDate) {
            this.displayStartValue = this.formatDate(this.startDate);
          }

          if (this.endDate) {
            this.displayEndValue = this.formatDate(this.endDate);
          }

          const today = new Date();
          if (this.startDate) {
            const date = new Date(this.startDate);
            this.currentMonth = date.getMonth();
            this.currentYear = date.getFullYear();
          } else {
            this.currentMonth = today.getMonth();
            this.currentYear = today.getFullYear();
          }

          this.calculateDays();

          // Watch for changes to the dates
          this.$watch('startDate', (newValue) => {
            this.displayStartValue = this.formatDate(newValue);

            // Set value of the hidden input
            const hiddenInput = document.getElementById('#{@id}-start');
            hiddenInput.value = newValue;

            // Trigger change event
            const event = new Event('change', { bubbles: true });
            hiddenInput.dispatchEvent(event);

            this.calculateDays();
          });

          this.$watch('endDate', (newValue) => {
            this.displayEndValue = this.formatDate(newValue);

            // Set value of the hidden input
            const hiddenInput = document.getElementById('#{@id}-end');
            hiddenInput.value = newValue;

            // Trigger change event
            const event = new Event('change', { bubbles: true });
            hiddenInput.dispatchEvent(event);

            this.calculateDays();
          });
        },

        isDisabled(dateString) {
          if (!dateString) return false;

          if (this.minDate && dateString < this.minDate) {
            return true;
          }

          if (this.maxDate && dateString > this.maxDate) {
            return true;
          }

          return false;
        },

        isInRange(dateString) {
          if (!this.startDate || !this.endDate || !dateString) return false;
          return dateString > this.startDate && dateString < this.endDate;
        },

        isInHoverRange(dateString) {
          if (!this.startDate || !this.hoverDate || !dateString || !this.selectingStartDate === false) return false;
          return dateString > this.startDate && dateString <= this.hoverDate;
        },

        calculateDays() {
          this.daysInMonth = [];

          const firstDay = new Date(this.currentYear, this.currentMonth, 1);
          const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0);
          const daysInMonth = lastDay.getDate();

          // Add empty cells for days before first day of month
          const firstDayOfWeek = firstDay.getDay(); // 0 = Sunday, 1 = Monday, ...
          for (let i = 0; i < firstDayOfWeek; i++) {
            this.daysInMonth.push({ day: '', date: null });
          }

          // Add days of the month
          for (let day = 1; day <= daysInMonth; day++) {
            const date = new Date(this.currentYear, this.currentMonth, day);
            const dateString = this.formatISODate(date);
            this.daysInMonth.push({
              day: day,
              date: dateString,
              isToday: this.isToday(date),
              isStart: dateString === this.startDate,
              isEnd: dateString === this.endDate,
              isInRange: this.isInRange(dateString),
              isDisabled: this.isDisabled(dateString)
            });
          }
        },

        nextMonth() {
          if (this.currentMonth === 11) {
            this.currentMonth = 0;
            this.currentYear++;
          } else {
            this.currentMonth++;
          }
          this.calculateDays();
        },

        prevMonth() {
          if (this.currentMonth === 0) {
            this.currentMonth = 11;
            this.currentYear--;
          } else {
            this.currentMonth--;
          }
          this.calculateDays();
        },

        handleDayHover(dateString) {
          this.hoverDate = dateString;
        },

        selectDate(dateString) {
          if (!dateString || this.isDisabled(dateString)) return;

          if (this.selectingStartDate) {
            // Selecting start date
            this.startDate = dateString;
            this.endDate = '';
            this.selectingStartDate = false;
          } else {
            // Selecting end date
            if (dateString < this.startDate) {
              // If end date is before start date, swap them
              this.endDate = this.startDate;
              this.startDate = dateString;
            } else {
              this.endDate = dateString;
            }
            this.selectingStartDate = true;
            this.datePickerOpen = false;
          }
        },

        clearDates() {
          this.startDate = '';
          this.endDate = '';
          this.displayStartValue = '';
          this.displayEndValue = '';
          this.selectingStartDate = true;
        },

        isToday(date) {
          const today = new Date();
          return date.getDate() === today.getDate() &&
                 date.getMonth() === today.getMonth() &&
                 date.getFullYear() === today.getFullYear();
        },

        formatDate(dateString) {
          if (!dateString) return '';

          const date = new Date(dateString);
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');

          switch (this.dateFormat) {
            case 'MM/DD/YYYY':
              return `${month}/${day}/${year}`;
            case 'DD/MM/YYYY':
              return `${day}/${month}/${year}`;
            default: // YYYY-MM-DD
              return `${year}-${month}-${day}`;
          }
        },

        formatISODate(date) {
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');
          return `${year}-${month}-${day}`;
        },

        parseDate(value) {
          if (!value) return null;

          let year, month, day;

          switch (this.dateFormat) {
            case 'MM/DD/YYYY':
              [month, day, year] = value.split('/');
              break;
            case 'DD/MM/YYYY':
              [day, month, year] = value.split('/');
              break;
            default: // YYYY-MM-DD
              [year, month, day] = value.split('-');
              break;
          }

          if (!year || !month || !day) return null;

          // Ensure values are padded correctly
          month = String(parseInt(month)).padStart(2, '0');
          day = String(parseInt(day)).padStart(2, '0');

          return `${year}-${month}-${day}`;
        },

        handleStartInputChange(e) {
          this.displayStartValue = e.target.value;
          this.startDate = this.parseDate(this.displayStartValue);
        },

        handleEndInputChange(e) {
          this.displayEndValue = e.target.value;
          this.endDate = this.parseDate(this.displayEndValue);
        },

        getMonthName(month) {
          const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
          return monthNames[month];
        }
      }"}
      x-on:click.away="datePickerOpen = false"
      x-on:keydown.escape="datePickerOpen = false"
    >
      <%= if Map.has_key?(assigns, :label) do %>
        <label for={"#{@id}-start-display"} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <div class="flex space-x-2">
        <!-- Start Date Input -->
        <div class="relative flex-1">
          <input
            type="text"
            id={"#{@id}-start-display"}
            x-model="displayStartValue"
            x-on:focus="datePickerOpen = true; selectingStartDate = true"
            x-on:input="handleStartInputChange($event)"
            placeholder={@placeholder_start}
            class={"block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{@input_class}"}
            autocomplete="off"
            disabled={@disabled}
            required={@required}
          />

          <!-- Calendar Icon -->
          <div
            class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer"
            x-on:click="datePickerOpen = !datePickerOpen; selectingStartDate = true"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>

          <!-- Hidden Input for Form Submission -->
          <input
            type="hidden"
            id={"#{@id}-start"}
            name={@name_start}
            value={Map.get(assigns, :value_start, "")}
            phx-change={@phx_change}
            phx-blur={@phx_blur}
          />
        </div>

        <div class="flex items-center">
          <span class="text-gray-500">to</span>
        </div>

        <!-- End Date Input -->
        <div class="relative flex-1">
          <input
            type="text"
            id={"#{@id}-end-display"}
            x-model="displayEndValue"
            x-on:focus="datePickerOpen = true; selectingStartDate = false"
            x-on:input="handleEndInputChange($event)"
            placeholder={@placeholder_end}
            class={"block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm #{@input_class}"}
            autocomplete="off"
            disabled={@disabled}
            required={@required}
          />

          <!-- Calendar Icon -->
          <div
            class="absolute inset-y-0 right-0 flex items-center pr-3 cursor-pointer"
            x-on:click="datePickerOpen = !datePickerOpen; selectingStartDate = false"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>

          <!-- Hidden Input for Form Submission -->
          <input
            type="hidden"
            id={"#{@id}-end"}
            name={@name_end}
            value={Map.get(assigns, :value_end, "")}
            phx-change={@phx_change}
            phx-blur={@phx_blur}
          />
        </div>
      </div>

      <!-- Calendar Dropdown -->
      <div
        x-show="datePickerOpen"
        x-transition:enter="transition ease-out duration-200"
        x-transition:enter-start="opacity-0 translate-y-1"
        x-transition:enter-end="opacity-100 translate-y-0"
        x-transition:leave="transition ease-in duration-150"
        x-transition:leave-start="opacity-100 translate-y-0"
        x-transition:leave-end="opacity-0 translate-y-1"
        class={"absolute z-10 mt-1 bg-white shadow-lg rounded-md p-4 #{@calendar_class}"}
        style="width: 320px"
        x-cloak
      >
        <!-- Calendar Header -->
        <div class="flex justify-between items-center mb-4">
          <button
            type="button"
            class="p-1 rounded-full hover:bg-gray-100"
            x-on:click.prevent="prevMonth"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>

          <div class="text-lg font-semibold text-gray-800">
            <span x-text="getMonthName(currentMonth)"></span>
            <span x-text="currentYear"></span>
          </div>

          <button
            type="button"
            class="p-1 rounded-full hover:bg-gray-100"
            x-on:click.prevent="nextMonth"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>

        <!-- Selection Status -->
        <div class="text-sm text-center mb-2">
          <template x-if="selectingStartDate">
            <p class="text-gray-600">Select start date</p>
          </template>
          <template x-if="!selectingStartDate">
            <p class="text-gray-600">Select end date</p>
          </template>
        </div>

        <!-- Weekday Headers -->
        <div class="grid grid-cols-7 gap-1 mb-2">
          <div class="text-center text-xs font-medium text-gray-500">Su</div>
          <div class="text-center text-xs font-medium text-gray-500">Mo</div>
          <div class="text-center text-xs font-medium text-gray-500">Tu</div>
          <div class="text-center text-xs font-medium text-gray-500">We</div>
          <div class="text-center text-xs font-medium text-gray-500">Th</div>
          <div class="text-center text-xs font-medium text-gray-500">Fr</div>
          <div class="text-center text-xs font-medium text-gray-500">Sa</div>
        </div>

        <!-- Calendar Days -->
        <div class="grid grid-cols-7 gap-1">
          <template x-for="(day, index) in daysInMonth" x-bind:key="index">
            <div
              x-on:click="selectDate(day.date)"
              x-on:mouseenter="handleDayHover(day.date)"
              x-bind:class="{
                'text-center p-2 rounded-md text-sm cursor-pointer': true,
                'bg-indigo-600 text-white': day.isStart || day.isEnd,
                'bg-indigo-100 text-indigo-700': day.isInRange || isInHoverRange(day.date),
                'text-gray-800 hover:bg-gray-100': !day.isStart && !day.isEnd && !day.isInRange && !isInHoverRange(day.date) && !day.isDisabled && day.date,
                'text-gray-400': !day.date,
                'bg-gray-100 text-gray-800 ring-1 ring-indigo-500 ring-offset-2 ring-offset-white': day.isToday && !day.isStart && !day.isEnd && !day.isInRange,
                'opacity-50 cursor-not-allowed': day.isDisabled
              }"
            >
              <span x-text="day.day"></span>
            </div>
          </template>
        </div>

        <!-- Calendar Footer -->
        <div class="mt-4 flex justify-between">
          <button
            type="button"
            class="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 rounded-md"
            x-on:click="clearDates"
          >
            Clear
          </button>

          <button
            type="button"
            class="px-4 py-2 text-sm text-white bg-indigo-600 hover:bg-indigo-700 rounded-md"
            x-on:click="datePickerOpen = false"
          >
            Done
          </button>
        </div>
      </div>

      <!-- Hint & Error Messages -->
      <%= if Map.has_key?(assigns, :hint) do %>
        <p class="mt-1 text-sm text-gray-500"><%= @hint %></p>
      <% end %>

      <%= if Map.has_key?(assigns, :error) do %>
        <p class="mt-1 text-sm text-red-600"><%= @error %></p>
      <% end %>
    </div>
    """
  end
end
