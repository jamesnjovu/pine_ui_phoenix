defmodule PineUiPhoenix.FileUploader do
  @moduledoc """
  Provides file upload components with drag-and-drop functionality.

  The FileUploader module offers components for file uploads with support for
  drag-and-drop, file previews, and multiple file selection.
  """
  use Phoenix.Component
  import Phoenix.HTML
  import Phoenix.HTML.Form

  @doc """
  Renders a basic file uploader component.

  This component creates a file upload area with drag-and-drop functionality.

  ## Examples

      <.basic
        id="document-upload"
        name="document"
        label="Upload Document"
        accept=".pdf,.doc,.docx"
      />

      <.basic
        id="profile-image"
        name="profile_image"
        label="Upload Profile Image"
        accept="image/*"
        max_file_size={5 * 1024 * 1024}
        show_preview={true}
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed file types (optional)
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:multiple` - Whether to allow multiple file selection (optional, defaults to false)
  * `:show_preview` - Whether to show file previews (optional, defaults to false for multiple files, true for single files)
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def basic(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:multiple, fn -> false end)
      |> assign_new(:show_preview, fn -> !assigns.multiple end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:on_change, fn -> nil end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class={"#{@class}"}
      x-data={"{
        files: [],
        fileInput: null,
        uploading: false,
        dragover: false,
        previewUrls: [],
        maxFileSizeExceeded: false,
        errorMessage: '',

        init() {
          this.fileInput = document.getElementById('#{@id}');
          this.$watch('files', (files) => {
            this.previewUrls = [];
            this.maxFileSizeExceeded = false;
            this.errorMessage = '';

            for (let i = 0; i < files.length; i++) {
              const file = files[i];

              #{if Map.has_key?(assigns, :max_file_size) do
                "if (file.size > #{@max_file_size}) {
                  this.maxFileSizeExceeded = true;
                  this.errorMessage = 'File size exceeds maximum allowed size';
                  this.files = [];
                  this.fileInput.value = '';
                  return;
                }"
              else
                ""
              end}

              #{if @show_preview do
                "if (file.type.startsWith('image/')) {
                  const reader = new FileReader();
                  reader.onload = (e) => {
                    this.previewUrls.push({ name: file.name, url: e.target.result, type: 'image' });
                  };
                  reader.readAsDataURL(file);
                } else if (file.type === 'application/pdf') {
                  this.previewUrls.push({ name: file.name, url: '#', type: 'pdf' });
                } else {
                  this.previewUrls.push({ name: file.name, url: '#', type: 'file' });
                }"
              else
                ""
              end}
            }

            #{if @on_change do
              @on_change
            else
              ""
            end}
          });
        },

        handleDrop(event) {
          this.dragover = false;
          event.preventDefault();

          if (event.dataTransfer.files.length) {
            this.files = #{if @multiple, do: "event.dataTransfer.files", else: "[event.dataTransfer.files[0]]"};
            this.fileInput.files = event.dataTransfer.files;
          }
        },

        handleFileInputChange(event) {
          this.files = #{if @multiple, do: "event.target.files", else: "event.target.files.length ? [event.target.files[0]] : []"};
        },

        removeFile(index) {
          const dt = new DataTransfer();
          const files = Array.from(this.fileInput.files);
          files.splice(index, 1);

          files.forEach(file => dt.items.add(file));

          this.fileInput.files = dt.files;
          this.files = dt.files;
          this.previewUrls.splice(index, 1);
        }
      }"}
    >
      <%= if Map.has_key?(assigns, :label) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <div
        x-on:dragover.prevent="dragover = true"
        x-on:dragleave.prevent="dragover = false"
        x-on:drop="handleDrop($event)"
        x-bind:class="{ 'border-indigo-500 bg-indigo-50': dragover }"
        class="flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:border-indigo-400 transition duration-150"
      >
        <div class="space-y-1 text-center">
          <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
            <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <div class="flex text-sm text-gray-600">
            <label
              for={@id}
              class="relative cursor-pointer rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
            >
              <span>Upload <%= if @multiple, do: "files", else: "a file" %></span>
              <input
                id={@id}
                name={@name}
                type="file"
                class="sr-only"
                {if @multiple, do: ["multiple", true], else: []}
                {if Map.has_key?(assigns, :accept), do: ["accept", "#{@accept}"], else: []}
                x-on:change="handleFileInputChange($event)"
              />
            </label>
            <p class="pl-1">or drag and drop</p>
          </div>
          <p class="text-xs text-gray-500">
            <%= if Map.has_key?(assigns, :accept) do %>
              <%= @accept |> String.split(",") |> Enum.map(fn x -> String.trim(x) |> String.replace(".", "") end) |> Enum.join(", ") |> String.upcase() %>
            <% else %>
              Any file type
            <% end %>
            <%= if Map.has_key?(assigns, :max_file_size) do %>
              up to <%= format_file_size(@max_file_size) %>
            <% end %>
          </p>
        </div>
      </div>

      <template x-if="maxFileSizeExceeded">
        <p class="mt-2 text-sm text-red-600" x-text="errorMessage"></p>
      </template>

      <!-- File Previews -->
      <template x-if={"files.length > 0 && #{@show_preview}"}>
        <div class="mt-4 space-y-2">
          <template x-for="(preview, index) in previewUrls" x-bind:key="index">
            <div class="relative rounded-md bg-gray-50 p-3 flex items-center">
              <!-- Image Preview -->
              <template x-if="preview.type === 'image'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 overflow-hidden rounded border border-gray-200">
                  <img class="h-full w-full object-cover" x-bind:src="preview.url" x-bind:alt="preview.name" />
                </div>
              </template>

              <!-- PDF Icon -->
              <template x-if="preview.type === 'pdf'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 flex items-center justify-center rounded border border-gray-200 bg-gray-50">
                  <svg class="h-8 w-8 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2 6a1 1 0 011-1h6a1 1 0 110 2H7a1 1 0 01-1-1zm1 3a1 1 0 100 2h6a1 1 0 100-2H7z" clip-rule="evenodd"></path>
                  </svg>
                </div>
              </template>

              <!-- Generic File Icon -->
              <template x-if="preview.type === 'file'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 flex items-center justify-center rounded border border-gray-200 bg-gray-50">
                  <svg class="h-8 w-8 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4z" clip-rule="evenodd"></path>
                  </svg>
                </div>
              </template>

              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate" x-text="preview.name"></p>
                <p class="text-xs text-gray-500 truncate" x-text="files[index] ? (files[index].size ? formatBytes(files[index].size) : '') : ''"></p>
              </div>

              <div class="ml-4 flex-shrink-0">
                <button
                  type="button"
                  class="rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  x-on:click.prevent="removeFile(index)"
                >
                  <span class="sr-only">Remove</span>
                  <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
          </template>
        </div>
      </template>

      <!-- File Count (for multiple files when preview is disabled) -->
      <template x-if={"files.length > 0 && #{@multiple && !@show_preview}"}>
        <div class="mt-2 text-sm text-gray-500">
          <span x-text="files.length"></span> <%= if @multiple, do: "files", else: "file" %> selected
        </div>
      </template>

      <script>
        function formatBytes(bytes, decimals = 2) {
          if (bytes === 0) return '0 Bytes';

          const k = 1024;
          const dm = decimals < 0 ? 0 : decimals;
          const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];

          const i = Math.floor(Math.log(bytes) / Math.log(k));

          return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
        }
      </script>
    </div>
    """
  end

  @doc """
  Renders an image uploader with cropping capability.

  This component creates an uploader specifically for images with
  built-in preview and optional cropping functionality.

  ## Examples

      <.image
        id="avatar-upload"
        name="avatar"
        label="Upload Avatar"
      />

      <.image
        id="cover-photo"
        name="cover_photo"
        label="Cover Photo"
        aspect_ratio={16/9}
        allow_cropping={true}
        preview_height="10rem"
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed image types (optional, defaults to "image/*")
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:aspect_ratio` - Fixed aspect ratio for the image (optional)
  * `:allow_cropping` - Whether to enable image cropping (optional, defaults to false)
  * `:preview_height` - Height of the preview area (optional, defaults to "12rem")
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def image(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:accept, fn -> "image/*" end)
      |> assign_new(:allow_cropping, fn -> false end)
      |> assign_new(:preview_height, fn -> "12rem" end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:on_change, fn -> nil end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class={"#{@class}"}
      x-data={"{
        file: null,
        fileInput: null,
        previewUrl: '',
        uploading: false,
        dragover: false,
        maxFileSizeExceeded: false,
        errorMessage: '',
        aspectRatio: #{if Map.has_key?(assigns, :aspect_ratio), do: @aspect_ratio, else: "null"},
        allowCropping: #{@allow_cropping},
        previewHeight: '#{@preview_height}',
        cropper: null,
        croppedCanvas: null,

        init() {
          this.fileInput = document.getElementById('#{@id}');

          this.$watch('file', (file) => {
            if (!file) {
              this.previewUrl = '';
              return;
            }

            #{if Map.has_key?(assigns, :max_file_size) do
              "if (file.size > #{@max_file_size}) {
                this.maxFileSizeExceeded = true;
                this.errorMessage = 'File size exceeds maximum allowed size';
                this.file = null;
                this.fileInput.value = '';
                return;
              }"
            else
              ""
            end}

            const reader = new FileReader();
            reader.onload = (e) => {
              this.previewUrl = e.target.result;

              if (this.allowCropping) {
                this.$nextTick(() => {
                  if (this.cropper) {
                    this.cropper.destroy();
                  }

                  const image = document.getElementById('#{@id}-preview-image');
                  this.cropper = new Cropper(image, {
                    aspectRatio: this.aspectRatio,
                    viewMode: 1,
                    autoCropArea: 1,
                    crop: (event) => {
                      this.croppedCanvas = this.cropper.getCroppedCanvas();
                      this.croppedCanvas.toBlob((blob) => {
                        const croppedFile = new File([blob], this.file.name, { type: this.file.type });
                        const dt = new DataTransfer();
                        dt.items.add(croppedFile);
                        this.fileInput.files = dt.files;
                      });
                    }
                  });
                });
              }
            };
            reader.readAsDataURL(file);

            #{if @on_change do
              @on_change
            else
              ""
            end}
          });
        },

        handleDrop(event) {
          this.dragover = false;
          event.preventDefault();

          if (event.dataTransfer.files.length && event.dataTransfer.files[0].type.startsWith('image/')) {
            this.file = event.dataTransfer.files[0];
            this.fileInput.files = event.dataTransfer.files;
          }
        },

        handleFileInputChange(event) {
          if (event.target.files.length) {
            this.file = event.target.files[0];
          } else {
            this.file = null;
          }
        },

        resetFile() {
          this.file = null;
          this.fileInput.value = '';
          if (this.cropper) {
            this.cropper.destroy();
            this.cropper = null;
          }
        }
      }"}
    >
      <%= if Map.has_key?(assigns, :label) do %>
        <label for={@id} class="block text-sm font-medium text-gray-700 mb-1"><%= @label %></label>
      <% end %>

      <!-- Upload Area (displayed when no image is selected) -->
      <div
        x-show="!previewUrl"
        x-on:dragover.prevent="dragover = true"
        x-on:dragleave.prevent="dragover = false"
        x-on:drop="handleDrop($event)"
        x-bind:class="{ 'border-indigo-500 bg-indigo-50': dragover }"
        class="flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:border-indigo-400 transition duration-150"
        x-bind:style="{ 'min-height': previewHeight }"
      >
        <div class="space-y-1 text-center">
          <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
            <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <div class="flex text-sm text-gray-600">
            <label
              for={@id}
              class="relative cursor-pointer rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
            >
              <span>Upload an image</span>
              <input
                id={@id}
                name={@name}
                type="file"
                class="sr-only"
                accept={@accept}
                x-on:change="handleFileInputChange($event)"
              />
            </label>
            <p class="pl-1">or drag and drop</p>
          </div>
          <p class="text-xs text-gray-500">
            PNG, JPG, GIF up to
            <%= if Map.has_key?(assigns, :max_file_size) do %>
              <%= format_file_size(@max_file_size) %>
            <% else %>
              10MB
            <% end %>
          </p>
        </div>
      </div>

      <!-- Image Preview Area -->
      <div
        x-show="previewUrl"
        class="relative rounded-md border border-gray-300 overflow-hidden"
        x-bind:style="{ height: previewHeight }"
      >
        <img
          id={"#{@id}-preview-image"}
          x-bind:src="previewUrl"
          class="max-w-full h-full mx-auto object-contain"
          x-bind:class="{ 'max-w-full': !allowCropping, 'w-full': allowCropping }"
        />

        <!-- Remove button -->
        <button
          type="button"
          class="absolute top-2 right-2 p-1 rounded-full bg-white bg-opacity-75 text-gray-700 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          x-on:click.prevent="resetFile()"
        >
          <span class="sr-only">Remove</span>
          <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
      </div>

      <template x-if="maxFileSizeExceeded">
        <p class="mt-2 text-sm text-red-600" x-text="errorMessage"></p>
      </template>

      <!-- Cropper.js Script (Only included when cropping is enabled) -->
      <%= if @allow_cropping do %>
        <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css"
          integrity="sha512-cyzxRvewl+FOKTtpBzYjW6x6IAYUCZy3sGP40hn+DQkqQYuEMJICOXG/4w1WjnJ0lgj5fqXKfNsQQe/YgPQQQ=="
          crossorigin="anonymous"
          referrerpolicy="no-referrer"
        />
        <script
          src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"
          integrity="sha512-6lplKUSl86rUVprDIjiKKsXtpJ5GeX+WOCTmAVNngRONMHdnqlPTiIJ+GC2d4OHoEY9f+hQNsYwQHxTYP8X+A=="
          crossorigin="anonymous"
          referrerpolicy="no-referrer"
        ></script>
      <% end %>
    </div>
    """
  end
@doc """
  Renders a multi-file uploader component with progress tracking.

  This component creates an uploader that handles multiple files with
  individual progress tracking for each file.

  ## Examples

      <.multi
        id="gallery-upload"
        name="gallery"
        label="Upload Images"
        accept="image/*"
        max_files={5}
      />

  ## Options

  * `:id` - The ID for the file input (required)
  * `:name` - The name attribute for the file input (optional, defaults to ID)
  * `:label` - Label text for the uploader (optional)
  * `:accept` - Comma-separated list of allowed file types (optional)
  * `:max_file_size` - Maximum file size in bytes (optional)
  * `:max_files` - Maximum number of files that can be selected (optional)
  * `:show_preview` - Whether to show file previews (optional, defaults to true)
  * `:class` - Additional CSS classes for the uploader container (optional)
  * `:on_change` - JavaScript function to call when files change (optional)
  """
  def multi(assigns) do
    assigns =
      assigns
      |> assign_new(:name, fn -> assigns.id end)
      |> assign_new(:show_preview, fn -> true end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:on_change, fn -> nil end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class={"#{@class}"}
      x-data={"{
        files: [],
        fileInput: null,
        uploading: false,
        dragover: false,
        previewUrls: [],
        fileErrors: [],
        maxFilesExceeded: false,

        init() {
          this.fileInput = document.getElementById('#{@id}');
          this.$watch('files', (files) => {
            this.previewUrls = [];
            this.fileErrors = [];
            this.maxFilesExceeded = false;

            #{if Map.has_key?(assigns, :max_files) do
              "if (files.length > #{@max_files}) {
                this.maxFilesExceeded = true;
                return;
              }"
            else
              ""
            end}

            for (let i = 0; i < files.length; i++) {
              const file = files[i];

              #{if Map.has_key?(assigns, :max_file_size) do
                "if (file.size > #{@max_file_size}) {
                  this.fileErrors.push({ index: i, file: file, error: 'File size exceeds maximum allowed size' });
                  continue;
                }"
              else
                ""
              end}

              #{if @show_preview do
                "if (file.type.startsWith('image/')) {
                  const reader = new FileReader();
                  reader.onload = (e) => {
                    this.previewUrls.push({ index: i, name: file.name, url: e.target.result, type: 'image' });
                    this.previewUrls.sort((a, b) => a.index - b.index);
                  };
                  reader.readAsDataURL(file);
                } else if (file.type === 'application/pdf') {
                  this.previewUrls.push({ index: i, name: file.name, url: '#', type: 'pdf' });
                } else {
                  this.previewUrls.push({ index: i, name: file.name, url: '#', type: 'file' });
                }"
              else
                ""
              end}
            }

            #{if @on_change do
              @on_change
            else
              ""
            end}
          });
        },

        handleDrop(event) {
          this.dragover = false;
          event.preventDefault();

          if (event.dataTransfer.files.length) {
            const selectedFiles = Array.from(this.fileInput.files || []);
            const newFiles = Array.from(event.dataTransfer.files);

            const dt = new DataTransfer();

            // Add existing files
            selectedFiles.forEach(file => dt.items.add(file));

            // Add new files
            newFiles.forEach(file => dt.items.add(file));

            this.fileInput.files = dt.files;
            this.files = Array.from(dt.files);
          }
        },

        handleFileInputChange(event) {
          this.files = Array.from(event.target.files);
        },

        removeFile(index) {
          const dt = new DataTransfer();
          const files = Array.from(this.fileInput.files);
          files.splice(index, 1);

          files.forEach(file => dt.items.add(file));

          this.fileInput.files = dt.files;
          this.files = Array.from(dt.files);
        },

        removeAllFiles() {
          this.fileInput.value = '';
          this.files = [];
        }
      }"}
    >
      <%= if Map.has_key?(assigns, :label) do %>
        <div class="flex justify-between items-center mb-1">
          <label for={@id} class="block text-sm font-medium text-gray-700"><%= @label %></label>
          <template x-if="files.length > 0">
            <button
              type="button"
              class="text-xs text-gray-500 hover:text-gray-700"
              x-on:click="removeAllFiles()"
            >
              Clear all
            </button>
          </template>
        </div>
      <% end %>

      <div
        x-on:dragover.prevent="dragover = true"
        x-on:dragleave.prevent="dragover = false"
        x-on:drop="handleDrop($event)"
        x-bind:class="{ 'border-indigo-500 bg-indigo-50': dragover }"
        class="flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:border-indigo-400 transition duration-150"
      >
        <div class="space-y-1 text-center">
          <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
            <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <div class="flex text-sm text-gray-600">
            <label
              for={@id}
              class="relative cursor-pointer rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
            >
              <span>Upload files</span>
              <input
                id={@id}
                name={@name}
                type="file"
                class="sr-only"
                multiple
                {if Map.has_key?(assigns, :accept), do: [accept: "#{@accept}"], else: []}
                x-on:change="handleFileInputChange($event)"
              />
            </label>
            <p class="pl-1">or drag and drop</p>
          </div>
          <p class="text-xs text-gray-500">
            <%= if Map.has_key?(assigns, :accept) do %>
              <%= @accept |> String.split(",") |> Enum.map(fn x -> String.trim(x) |> String.replace(".", "") end) |> Enum.join(", ") |> String.upcase() %>
            <% else %>
              Any file type
            <% end %>
            <%= if Map.has_key?(assigns, :max_file_size) do %>
              up to <%= format_file_size(@max_file_size) %>
            <% end %>
            <%= if Map.has_key?(assigns, :max_files) do %>
              (max #{@max_files} files)
            <% end %>
          </p>
        </div>
      </div>

      <!-- Error Messages -->
      <template x-if="maxFilesExceeded">
        <p class="mt-2 text-sm text-red-600">
          Maximum of <%= if Map.has_key?(assigns, :max_files), do: @max_files, else: "multiple" %> files allowed
        </p>
      </template>

      <template x-if="fileErrors.length > 0">
        <div class="mt-2">
          <template x-for="error in fileErrors" x-bind:key="error.index">
            <p class="text-sm text-red-600">
              <span x-text="error.file.name"></span>: <span x-text="error.error"></span>
            </p>
          </template>
        </div>
      </template>

      <!-- File Previews -->
      <template x-if={"files.length > 0 && #{@show_preview}"}>
        <div class="mt-4 space-y-2">
          <template x-for="preview in previewUrls" x-bind:key="preview.index">
            <div class="relative rounded-md bg-gray-50 p-3 flex items-center">
              <!-- Image Preview -->
              <template x-if="preview.type === 'image'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 overflow-hidden rounded border border-gray-200">
                  <img class="h-full w-full object-cover" x-bind:src="preview.url" x-bind:alt="preview.name" />
                </div>
              </template>

              <!-- PDF Icon -->
              <template x-if="preview.type === 'pdf'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 flex items-center justify-center rounded border border-gray-200 bg-gray-50">
                  <svg class="h-8 w-8 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2 6a1 1 0 011-1h6a1 1 0 110 2H7a1 1 0 01-1-1zm1 3a1 1 0 100 2h6a1 1 0 100-2H7z" clip-rule="evenodd"></path>
                  </svg>
                </div>
              </template>

              <!-- Generic File Icon -->
              <template x-if="preview.type === 'file'">
                <div class="mr-3 h-16 w-16 flex-shrink-0 flex items-center justify-center rounded border border-gray-200 bg-gray-50">
                  <svg class="h-8 w-8 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4z" clip-rule="evenodd"></path>
                  </svg>
                </div>
              </template>

              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate" x-text="preview.name"></p>
                <p class="text-xs text-gray-500 truncate" x-text="files[preview.index] ? (files[preview.index].size ? formatBytes(files[preview.index].size) : '') : ''"></p>
              </div>

              <div class="ml-4 flex-shrink-0">
                <button
                  type="button"
                  class="rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  x-on:click.prevent="removeFile(preview.index)"
                >
                  <span class="sr-only">Remove</span>
                  <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
          </template>
        </div>
      </template>

      <!-- File Count Summary -->
      <template x-if="files.length > 0">
        <div class="mt-2 text-sm text-gray-500">
          <span x-text="files.length"></span> files selected
          <template x-if="fileErrors.length > 0">
            (<span x-text="fileErrors.length"></span> with errors)
          </template>
        </div>
      </template>

      <script>
        function formatBytes(bytes, decimals = 2) {
          if (bytes === 0) return '0 Bytes';

          const k = 1024;
          const dm = decimals < 0 ? 0 : decimals;
          const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];

          const i = Math.floor(Math.log(bytes) / Math.log(k));

          return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
        }
      </script>
    </div>
    """
  end

  # Helper functions

  defp format_file_size(bytes) when is_integer(bytes) do
    cond do
      bytes < 1024 -> "#{bytes} B"
      bytes < 1024 * 1024 -> "#{Float.round(bytes / 1024, 1)} KB"
      bytes < 1024 * 1024 * 1024 -> "#{Float.round(bytes / 1024 / 1024, 1)} MB"
      true -> "#{Float.round(bytes / 1024 / 1024 / 1024, 1)} GB"
    end
  end
end
