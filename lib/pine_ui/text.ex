defmodule PineUiPhoenix.Text do
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

  def animation_blow(assigns) do
    ~H"""
    <span x-data="{
      startingAnimation: { opacity: 0, scale: 4 },
      endingAnimation: { opacity: 1, scale: 1, stagger: 0.07, duration: 1, ease: 'expo.out' },
      addCNDScript: true,
      animateText() {
        $el.classList.remove('invisible');
        gsap.fromTo($el.children, this.startingAnimation, this.endingAnimation);
      },
      splitCharactersIntoSpans(element) {
        text = element.innerHTML;
        modifiedHTML = [];
        for (var i = 0; i < text.length; i++) {
          attributes = '';
          if(text[i].trim()){ attributes = 'class=\'inline-block\''; }
          modifiedHTML.push('<span ' + attributes + '>' + text[i] + '</span>');
        }
        element.innerHTML = modifiedHTML.join('');
      },
      addScriptToHead(url) {
        script = document.createElement('script');
        script.src = url;
        document.head.appendChild(script);
      }
    }"
    x-init="
      splitCharactersIntoSpans($el);
      if(addCNDScript){
        addScriptToHead('https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js');
      }
      gsapInterval = setInterval(function(){
        if(typeof gsap !== 'undefined'){
          animateText();
          clearInterval(gsapInterval);
        }
      }, 5);
    "
      class="block text-3xl font-bold custom-font"
    >
      <%= @text %>
    </span>
    """
  end

  def animation_fade(assigns) do
    ~H"""
    <span x-data="{
        startingAnimation: { opacity: 0 },
        endingAnimation: { opacity: 1, stagger: 0.08, duration: 2.7, ease: 'power4.easeOut' },
        addCNDScript: true,
        splitCharactersIntoSpans(element) {
          text = element.innerHTML;
          modifiedHTML = [];
          for (var i = 0; i < text.length; i++) {
            attributes = '';
            if(text[i].trim()){ attributes = 'class=\'inline-block\''; }
              modifiedHTML.push('<span ' + attributes + '>' + text[i] + '</span>');
            }
            element.innerHTML = modifiedHTML.join('');
          },
          addScriptToHead(url) {
          script = document.createElement('script');
          script.src = url;
          document.head.appendChild(script);
        },
        animateText() {
          $el.classList.remove('invisible');
          gsap.fromTo($el.children, this.startingAnimation, this.endingAnimation);
        }
      }"
      x-init="
        splitCharactersIntoSpans($el);
        if(addCNDScript) {
          addScriptToHead('https://cdnjs.cloudflare.com/ajax/libs/gsap/3.11.5/gsap.min.js');
        }
        gsapInterval3 = setInterval(function() {
          if(typeof gsap !== 'undefined') {
            animateText();
            clearInterval(gsapInterval3);
          }
        }, 5);
      "
      class="block pb-0.5 overflow-hidden text-3xl font-bold custom-font"
    >
      <%= @text %>
    </span>
    """
  end
end
