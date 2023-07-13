defmodule PineUi.Text do
  @moduledoc false
  use Phoenix.Component

  def typing_effect(assigns) do
    ~H"""
    <div
      x-data={"{
        text: '',
        textArray: JSON.parse(JSON.stringify(#{@text_list})),
        textIndex: 0,
        charIndex: 0,
        typeSpeed: 110,
        cursorSpeed: 550,
        pauseEnd: 1500,
        pauseStart: 20,
        direction: 'forward',
      }"}
      x-init="$nextTick(() => {
        let typingInterval = setInterval(startTyping, $data.typeSpeed);

        function startTyping(){
          let current = $data.textArray[ $data.textIndex ];

          // check to see if we hit the end of the string
          if($data.charIndex > current.length){
            $data.direction = 'backward';
            clearInterval(typingInterval);

            setTimeout(function(){
              typingInterval = setInterval(startTyping, $data.typeSpeed);
            }, $data.pauseEnd);
          }

          $data.text = current.substring(0, $data.charIndex);

          if($data.direction == 'forward') {
            $data.charIndex += 1;
          } else {
            if($data.charIndex == 0) {
              $data.direction = 'forward';
              clearInterval(typingInterval);
              setTimeout(function() {
                $data.textIndex += 1;
                if($data.textIndex >= $data.textArray.length) {
                  $data.textIndex = 0;
                }
                typingInterval = setInterval(startTyping, $data.typeSpeed);
              }, $data.pauseStart);
            }
            $data.charIndex -= 1;
          }
        }

        setInterval(function(){
          if($refs.cursor.classList.contains('hidden')) {
            $refs.cursor.classList.remove('hidden');
          } else {
            $refs.cursor.classList.add('hidden');
          }
        }, $data.cursorSpeed);
      })"
    class={"flex mx-auto #{@class} max-w-7xl"}>
      <div class="relative flex items-center justify-center h-auto">
          <p class={@text_class} x-text="text"></p>
          <span class="absolute right-0 w-2 -mr-2 bg-black h-3/4" x-ref="cursor"></span>
      </div>
    </div>
    """
  end

  def tooltip_top(assigns) do
    ~H"""
    <div
      x-data={"{
        tooltipVisible: false,
        tooltipText: '#{@description}',
        tooltipArrow: true,
        tooltipPosition: 'top',
      }"}
      x-init="$refs.content.addEventListener('mouseenter', () => { tooltipVisible = true; }); $refs.content.addEventListener('mouseleave', () => { tooltipVisible = false; });"
      class="relative">

      <div x-ref="tooltip" x-show="tooltipVisible" x-bind:class="{ 'top-0 left-1/2 -translate-x-1/2 -mt-0.5 -translate-y-full' : tooltipPosition == 'top', 'top-1/2 -translate-y-1/2 -ml-0.5 left-0 -translate-x-full' : tooltipPosition == 'left', 'bottom-0 left-1/2 -translate-x-1/2 -mb-0.5 translate-y-full' : tooltipPosition == 'bottom', 'top-1/2 -translate-y-1/2 -mr-0.5 right-0 translate-x-full' : tooltipPosition == 'right' }" class="absolute w-auto text-sm" x-cloak>
        <div x-show="tooltipVisible" x-transition class="relative px-2 py-1 text-white bg-black rounded bg-opacity-90">
          <p x-text="tooltipText" class="flex-shrink-0 block text-xs whitespace-nowrap"></p>
          <div x-ref="tooltipArrow" x-show="tooltipArrow" x-bind:class="{
            'bottom-0 -translate-x-1/2 left-1/2 w-2.5 translate-y-full' : tooltipPosition == 'top',
            'right-0 -translate-y-1/2 top-1/2 h-2.5 -mt-px translate-x-full' : tooltipPosition == 'left',
            'top-0 -translate-x-1/2 left-1/2 w-2.5 -translate-y-full' : tooltipPosition == 'bottom',
            'left-0 -translate-y-1/2 top-1/2 h-2.5 -mt-px -translate-x-full' : tooltipPosition == 'right' }"
            class="absolute inline-flex items-center justify-center overflow-hidden">
            <div x-bind:class="{
              'origin-top-left -rotate-45' : tooltipPosition == 'top',
              'origin-top-left rotate-45' : tooltipPosition == 'left',
              'origin-bottom-left rotate-45' : tooltipPosition == 'bottom',
              'origin-top-right -rotate-45' : tooltipPosition == 'right' }"
              class="w-1.5 h-1.5 transform bg-black bg-opacity-90">
            </div>
          </div>
        </div>
      </div>
      <div x-ref="content" class={@class}><%= @title %></div>
    </div>
    """
  end
end
