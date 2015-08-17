deuces = {
  init: function(){
    deuces.idleWatch()
    deuces.formWatch()
  },


  idleWatch: function(){
    if($('#idle-watch').length > 0){
      idleTimer = null;
      idleState = false;
      idleWait = 30000;

      $('*').bind('mousemove mousedown mousewheel wheel DOMMouseScroll MSPointerDown MSPointerMove keypress keydown keyup touchstart touchmove touchend', function () {
          clearTimeout(idleTimer);
          idleState = false;
          idleTimer = setTimeout(function () {
            window.location.replace($('#idle-watch').data('destination'))
            idleState = true; }, idleWait);
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

      $(".validate-form *").live("keyup", function(evt) {
        if (evt.keyCode === 13) {
          alert('go button clicked')
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
