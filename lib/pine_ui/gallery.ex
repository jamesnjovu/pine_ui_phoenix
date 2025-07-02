defmodule PineUiPhoenix.Gallery do
  @moduledoc """
  Provides image gallery components for displaying collections of images.

  The Gallery module offers components for creating responsive image galleries
  with different layouts and interactive features like lightbox previews.
  """
  use Phoenix.Component
  import Phoenix.HTML

  @doc """
  Renders a basic grid gallery component.

  This component creates a responsive grid layout for displaying multiple images.

  ## Examples

      <.grid
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1"},
          %{src: "/images/photo2.jpg", alt: "Photo 2"},
          %{src: "/images/photo3.jpg", alt: "Photo 3"}
        ]}
      />

      <.grid
        images={@photos}
        columns={3}
        gap="4"
        enable_lightbox={true}
      />

  ## Options

  * `:images` - List of image maps with src and alt keys (required)
  * `:columns` - Number of columns in the grid: 1, 2, 3, 4, 5, 6 (optional, defaults to 3)
  * `:gap` - Gap size between grid items: "1", "2", "4", "6", "8" (optional, defaults to "4")
  * `:aspect_ratio` - Image aspect ratio: "square", "video", "portrait" (optional, defaults to "square")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:enable_lightbox` - Whether to enable lightbox preview (optional, defaults to false)
  * `:class` - Additional CSS classes for the gallery container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def grid(assigns) do
    assigns =
      assigns
      |> assign_new(:columns, fn -> 3 end)
      |> assign_new(:gap, fn -> "4" end)
      |> assign_new(:aspect_ratio, fn -> "square" end)
      |> assign_new(:rounded, fn -> true end)
      |> assign_new(:enable_lightbox, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:image_class, fn -> "" end)

    ~H"""
    <div
      id="pine-gallery-grid"
      class={"#{@class}"}
      x-data="{
        lightboxOpen: false,
        currentImage: null,
        images: #{Jason.encode!(@images)},

        openLightbox(index) {
          this.currentImage = index;
          this.lightboxOpen = true;
          document.body.classList.add('overflow-hidden');
        },

        closeLightbox() {
          this.lightboxOpen = false;
          document.body.classList.remove('overflow-hidden');
        },

        next() {
          this.currentImage = (this.currentImage + 1) % this.images.length;
        },

        prev() {
          this.currentImage = (this.currentImage - 1 + this.images.length) % this.images.length;
        },

        handleKeyDown(e) {
          if (!this.lightboxOpen) return;

          if (e.key === 'Escape') {
            this.closeLightbox();
          } else if (e.key === 'ArrowRight') {
            this.next();
          } else if (e.key === 'ArrowLeft') {
            this.prev();
          }
        }
      }"
      x-init="$watch('lightboxOpen', value => {
        if (value) {
          window.addEventListener('keydown', handleKeyDown);
        } else {
          window.removeEventListener('keydown', handleKeyDown);
        }
      })"
    >
      <div class={"grid grid-cols-1 #{get_columns_class(@columns)} gap-#{@gap}"}>
        <%= for {image, index} <- Enum.with_index(@images) do %>
          <div
            class="relative overflow-hidden group"
            {if @enable_lightbox, do: ['x-on:click', "openLightbox(#{index})"], else: []}
          >
            <div class={"#{get_aspect_ratio_class(@aspect_ratio)} #{if @rounded, do: "rounded-lg overflow-hidden"}"}>
              <img
                src={image.src}
                alt={image.alt}
                class={"w-full h-full object-cover transition-all duration-300 group-hover:scale-105 #{@image_class}"}
              />
            </div>

            <%= if Map.has_key?(image, :caption) do %>
              <div class="absolute inset-x-0 bottom-0 px-4 py-2 bg-black bg-opacity-50 text-white text-sm">
                <%= image.caption %>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>

      <!-- Lightbox -->
      <%= if @enable_lightbox do %>
        <div
          x-show="lightboxOpen"
          x-transition:enter="transition ease-out duration-300"
          x-transition:enter-start="opacity-0"
          x-transition:enter-end="opacity-100"
          x-transition:leave="transition ease-in duration-200"
          x-transition:leave-start="opacity-100"
          x-transition:leave-end="opacity-0"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-90"
          x-on:click.self="closeLightbox"
          x-cloak
        >
          <!-- Previous Button -->
          <button
            type="button"
            class="absolute left-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="prev"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>

          <!-- Image -->
          <div class="relative max-w-3xl max-h-[80vh]">
            <template x-for="(image, index) in images" x-bind:key="index">
              <div x-show="currentImage === index" class="relative">
                <img
                  x-bind:src="image.src"
                  x-bind:alt="image.alt"
                  class="max-w-full max-h-[80vh] object-contain"
                />

                <template x-if="image.caption">
                  <div class="absolute inset-x-0 bottom-0 px-4 py-2 bg-black bg-opacity-50 text-white text-center">
                    <span x-text="image.caption"></span>
                  </div>
                </template>
              </div>
            </template>
          </div>

          <!-- Next Button -->
          <button
            type="button"
            class="absolute right-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="next"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>

          <!-- Close Button -->
          <button
            type="button"
            class="absolute top-4 right-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="closeLightbox"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a masonry gallery component.

  This component creates a masonry layout for displaying images of varying heights.

  ## Examples

      <.masonry
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1", height: "md"},
          %{src: "/images/photo2.jpg", alt: "Photo 2", height: "lg"},
          %{src: "/images/photo3.jpg", alt: "Photo 3", height: "sm"}
        ]}
      />

  ## Options

  * `:images` - List of image maps with src, alt, and optional height keys (required)
  * `:columns` - Number of columns in the layout: 1, 2, 3, 4 (optional, defaults to 3)
  * `:gap` - Gap size between items: "1", "2", "4", "6", "8" (optional, defaults to "4")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:enable_lightbox` - Whether to enable lightbox preview (optional, defaults to false)
  * `:class` - Additional CSS classes for the gallery container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def masonry(assigns) do
    assigns =
      assigns
      |> assign_new(:columns, fn -> 3 end)
      |> assign_new(:gap, fn -> "4" end)
      |> assign_new(:rounded, fn -> true end)
      |> assign_new(:enable_lightbox, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:image_class, fn -> "" end)

    column_count = assigns.columns
    columns = Enum.map(1..column_count, fn _ -> [] end)

    # Distribute images across columns
    {columns, _} =
      Enum.reduce(assigns.images, {columns, 0}, fn image, {cols, current_col} ->
        # Add image to current column
        updated_cols =
          List.update_at(cols, current_col, fn column_images ->
            column_images ++ [image]
          end)

        # Move to next column for next image
        next_col = rem(current_col + 1, column_count)
        {updated_cols, next_col}
      end)

    assigns = assign(assigns, :columns_content, columns)

    ~H"""
    <div
      id="pine-gallery-masonry"
      class={"#{@class}"}
      x-data="{
        lightboxOpen: false,
        currentImage: null,
        images: #{Jason.encode!(@images)},

        openLightbox(index) {
          this.currentImage = index;
          this.lightboxOpen = true;
          document.body.classList.add('overflow-hidden');
        },

        closeLightbox() {
          this.lightboxOpen = false;
          document.body.classList.remove('overflow-hidden');
        },

        next() {
          this.currentImage = (this.currentImage + 1) % this.images.length;
        },

        prev() {
          this.currentImage = (this.currentImage - 1 + this.images.length) % this.images.length;
        },

        handleKeyDown(e) {
          if (!this.lightboxOpen) return;

          if (e.key === 'Escape') {
            this.closeLightbox();
          } else if (e.key === 'ArrowRight') {
            this.next();
          } else if (e.key === 'ArrowLeft') {
            this.prev();
          }
        }
      }"
      x-init="$watch('lightboxOpen', value => {
        if (value) {
          window.addEventListener('keydown', handleKeyDown);
        } else {
          window.removeEventListener('keydown', handleKeyDown);
        }
      })"
    >
      <div class={"grid grid-cols-1 #{get_columns_class(@columns)} gap-#{@gap}"}>
        <%= for {column, col_index} <- Enum.with_index(@columns_content) do %>
          <div class={"flex flex-col space-y-#{@gap}"}>
            <%= for {image, img_index} <- Enum.with_index(column) do %>
              <% image_index = col_index + img_index * @columns %>
              <div
                class="relative overflow-hidden group"
                {if @enable_lightbox, do: ['x-on:click': "openLightbox(#{image_index})"], else: []}
              >
                <div class={"#{if @rounded, do: "rounded-lg overflow-hidden"}"}>
                  <img
                    src={image.src}
                    alt={image.alt}
                    class={"w-full #{get_masonry_height_class(Map.get(image, :height, "md"))} object-cover transition-all duration-300 group-hover:scale-105 #{@image_class}"}
                  />
                </div>

                <%= if Map.has_key?(image, :caption) do %>
                  <div class="absolute inset-x-0 bottom-0 px-4 py-2 bg-black bg-opacity-50 text-white text-sm">
                    <%= image.caption %>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>

      <!-- Lightbox -->
      <%= if @enable_lightbox do %>
        <div
          x-show="lightboxOpen"
          x-transition:enter="transition ease-out duration-300"
          x-transition:enter-start="opacity-0"
          x-transition:enter-end="opacity-100"
          x-transition:leave="transition ease-in duration-200"
          x-transition:leave-start="opacity-100"
          x-transition:leave-end="opacity-0"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-90"
          x-on:click.self="closeLightbox"
          x-cloak
        >
          <!-- Previous Button -->
          <button
            type="button"
            class="absolute left-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="prev"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>

          <!-- Image -->
          <div class="relative max-w-3xl max-h-[80vh]">
            <template x-for="(image, index) in images" x-bind:key="index">
              <div x-show="currentImage === index" class="relative">
                <img
                  x-bind:src="image.src"
                  x-bind:alt="image.alt"
                  class="max-w-full max-h-[80vh] object-contain"
                />

                <template x-if="image.caption">
                  <div class="absolute inset-x-0 bottom-0 px-4 py-2 bg-black bg-opacity-50 text-white text-center">
                    <span x-text="image.caption"></span>
                  </div>
                </template>
              </div>
            </template>
          </div>

          <!-- Next Button -->
          <button
            type="button"
            class="absolute right-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="next"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>

          <!-- Close Button -->
          <button
            type="button"
            class="absolute top-4 right-4 p-2 text-white hover:bg-white hover:bg-opacity-10 rounded-full"
            x-on:click.stop="closeLightbox"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a carousel gallery component.

  This component creates a slideshow carousel for displaying images.

  ## Examples

      <.carousel
        images={[
          %{src: "/images/photo1.jpg", alt: "Photo 1"},
          %{src: "/images/photo2.jpg", alt: "Photo 2"},
          %{src: "/images/photo3.jpg", alt: "Photo 3"}
        ]}
      />

      <.carousel
        images={@photos}
        autoplay={true}
        autoplay_speed={3000}
        show_thumbnails={true}
      />

  ## Options

  * `:images` - List of image maps with src and alt keys (required)
  * `:aspect_ratio` - Image aspect ratio: "square", "video", "portrait" (optional, defaults to "video")
  * `:rounded` - Whether to round image corners (optional, defaults to true)
  * `:show_indicators` - Whether to show slide indicators (optional, defaults to true)
  * `:show_arrows` - Whether to show navigation arrows (optional, defaults to true)
  * `:show_thumbnails` - Whether to show thumbnail navigation (optional, defaults to false)
  * `:autoplay` - Whether to autoplay the carousel (optional, defaults to false)
  * `:autoplay_speed` - Autoplay speed in milliseconds (optional, defaults to 5000)
  * `:class` - Additional CSS classes for the carousel container (optional)
  * `:image_class` - CSS classes for the images (optional)
  """
  def carousel(assigns) do
    assigns =
      assigns
      |> assign_new(:aspect_ratio, fn -> "video" end)
      |> assign_new(:rounded, fn -> true end)
      |> assign_new(:show_indicators, fn -> true end)
      |> assign_new(:show_arrows, fn -> true end)
      |> assign_new(:show_thumbnails, fn -> false end)
      |> assign_new(:autoplay, fn -> false end)
      |> assign_new(:autoplay_speed, fn -> 5000 end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:image_class, fn -> "" end)

    ~H"""
    <div
      id="pine-gallery-carousel"
      class={"relative #{@class}"}
      x-data="{
        currentSlide: 0,
        totalSlides: #{length(@images)},
        autoplay: #{@autoplay},
        autoplaySpeed: #{@autoplay_speed},
        autoplayInterval: null,

        init() {
          if (this.autoplay) {
            this.startAutoplay();
          }
        },

        startAutoplay() {
          this.autoplayInterval = setInterval(() => {
            this.next();
          }, this.autoplaySpeed);
        },

        stopAutoplay() {
          clearInterval(this.autoplayInterval);
        },

        next() {
          this.currentSlide = (this.currentSlide + 1) % this.totalSlides;
        },

        prev() {
          this.currentSlide = (this.currentSlide - 1 + this.totalSlides) % this.totalSlides;
        },

        goToSlide(index) {
          this.currentSlide = index;
          if (this.autoplay) {
            this.stopAutoplay();
            this.startAutoplay();
          }
        }
      }"
      x-on:mouseenter="stopAutoplay"
      x-on:mouseleave="autoplay ? startAutoplay() : null"
    >
      <!-- Main Carousel -->
      <div class={"relative #{get_aspect_ratio_class(@aspect_ratio)} #{if @rounded, do: "rounded-lg overflow-hidden"}"}>
        <%= for {image, index} <- Enum.with_index(@images) do %>
          <div
            x-show={"currentSlide === #{index}"}
            x-transition:enter="transition ease-out duration-300"
            x-transition:enter-start="opacity-0 transform scale-95"
            x-transition:enter-end="opacity-100 transform scale-100"
            x-transition:leave="transition ease-in duration-200"
            x-transition:leave-start="opacity-100 transform scale-100"
            x-transition:leave-end="opacity-0 transform scale-95"
            class="absolute inset-0"
          >
            <img
              src={image.src}
              alt={image.alt}
              class={"w-full h-full object-cover #{@image_class}"}
            />

            <%= if Map.has_key?(image, :caption) do %>
              <div class="absolute inset-x-0 bottom-0 p-4 bg-black bg-opacity-50">
                <p class="text-white text-sm"><%= image.caption %></p>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>

      <!-- Arrows -->
      <%= if @show_arrows do %>
        <button
          type="button"
          class="absolute top-1/2 left-4 transform -translate-y-1/2 p-1 rounded-full bg-black bg-opacity-50 text-white hover:bg-opacity-70 focus:outline-none"
          x-on:click.prevent="prev"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>

        <button
          type="button"
          class="absolute top-1/2 right-4 transform -translate-y-1/2 p-1 rounded-full bg-black bg-opacity-50 text-white hover:bg-opacity-70 focus:outline-none"
          x-on:click.prevent="next"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      <% end %>

      <!-- Indicators -->
      <%= if @show_indicators do %>
        <div class="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2">
          <%= for {_, index} <- Enum.with_index(@images) do %>
            <button
              type="button"
              class="w-2 h-2 rounded-full focus:outline-none"
              x-on:click={"goToSlide(#{index})"}
              x-bind:class={"currentSlide === #{index} ? 'bg-white' : 'bg-white bg-opacity-50'"}
            ></button>
          <% end %>
        </div>
      <% end %>

      <!-- Thumbnails -->
      <%= if @show_thumbnails do %>
        <div class="mt-4 flex items-center justify-center space-x-2 overflow-x-auto">
          <%= for {image, index} <- Enum.with_index(@images) do %>
            <button
              type="button"
              class="relative flex-shrink-0 w-16 h-16 focus:outline-none"
              x-on:click={"goToSlide(#{index})"}
            >
              <img
                src={image.src}
                alt={"Thumbnail #{index + 1}"}
                class={"w-full h-full object-cover #{if @rounded, do: "rounded"}"}
              />
              <div
                class="absolute inset-0 border-2 rounded"
                x-bind:class={"currentSlide === #{index} ? 'border-indigo-500' : 'border-transparent'"}
              ></div>
            </button>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  # Helper functions for CSS classes

  defp get_columns_class(columns) do
    case columns do
      1 -> "sm:grid-cols-1"
      2 -> "sm:grid-cols-2"
      3 -> "sm:grid-cols-3"
      4 -> "sm:grid-cols-4"
      5 -> "sm:grid-cols-5"
      6 -> "sm:grid-cols-6"
      _ -> "sm:grid-cols-3" # Default
    end
  end

  defp get_aspect_ratio_class(aspect_ratio) do
    case aspect_ratio do
      "square" -> "aspect-w-1 aspect-h-1"
      "video" -> "aspect-w-16 aspect-h-9"
      "portrait" -> "aspect-w-3 aspect-h-4"
      _ -> "aspect-w-1 aspect-h-1" # Default
    end
  end

  defp get_masonry_height_class(height) do
    case height do
      "sm" -> "h-48"
      "md" -> "h-64"
      "lg" -> "h-80"
      "xl" -> "h-96"
      _ -> "h-64" # Default
    end
  end
end
