deuces = {
  init: function(){
    deuces.idleWatch()
    deuces.formWatch()
  },


  idleWatch: function(){
    if (typeof counter != "undefined") {
      clearInterval(counter)
    }

    if($('.idle-watch').length > 0){
      counter = setInterval(function () {
        oldCount = $('.idle-watch').data('count')
        $('.idle-watch').data('count', oldCount - 1)
        if($('.idle-watch').data('count') <= 0){
          window.location.replace($('.idle-watch').data('destination'))
        }
      }, 1000);

      $('*').bind('mousemove mousedown mousewheel wheel DOMMouseScroll MSPointerDown MSPointerMove keypress keydown keyup touchstart touchmove touchend click', function () {
          clearTimeout(idleTimer);
          idleTimer = setTimeout(function () {
            window.location.replace($('#idle-watch').data('destination'))}, idleWait);
      });
      $("body").trigger("mousemove");
    }
  },

  formWatch: function(){
    if($('.validate-form').length > 0){
      $('.validate-form *').bind('keypress keydown keyup touchstart touchmove touchend click', function () {
        if(deuces.formFilled()){
          $('.submit-label').addClass('green')
          $('.hidden-submit').attr('disabled', false)
        }
        else{
          $('.submit-label').removeClass('green')
          $('.hidden-submit').attr('disabled', true)
        }
      });

      $(".validate-form *").bind("keypress keydown keyup", function(evt) {
        if (evt.keyCode === 13) {
          if(deuces.formFilled()){
            $(".validate-form").submit()
          }
          else{
            $(".form-errors").text('Please fill out all fields')
          }
        }
      });
    }
  },

  formFilled: function(){
    return ($('.validate-form .name-input').val() != "" &&
    $('.validate-form .phone-input').val() != "" &&
    deuces.termsCheckedIfPresent())
  },

  termsCheckedIfPresent: function(){
    if ($('.validate-form .terms-input').length > 0){
      return $('.validate-form .terms-input').prop('checked')
    }
    else{
      return true
    }
  }

}
