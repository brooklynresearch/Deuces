deuces = {
  init: function(){
    deuces.idleWatch()
    deuces.formWatch()
    deuces.submitWatch()
    deuces.adminSearchSubmitWatch()
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
        $('.idle-watch').data('count', 30)
      });
    }
    $("body").trigger("mousemove");

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

  submitWatch: function(){
    if($('.validate-form').length > 0){
      $('.submit-label').click(function(){
        if (!deuces.formFilled()){
          $(".form-errors").text('Please fill out all fields')
          return false
        }
        else if(!deuces.isNumber($('.phone-input').val())){
          $(".form-errors").text('Please use only digits for the 4 digits of your phone number')
          return false
        }
        else if(!deuces.isFourDigitNumber($('.phone-input').val())){
          $(".form-errors").text('Please provide the last 4 digits of your phone number')
          return false
        }
      })
    }
  },

  adminSearchSubmitWatch: function(){
    if($('.validate-admin-form').length > 0){
      $('.submit-label').click(function(){
        if (!deuces.eitherFilled()){
          $(".form-errors").text('Please fill out either name or phone number')
          return false
        }
        else if($('.validate-admin-form .phone-input').val() != "" && !deuces.isNumber($('.validate-admin-form .phone-input').val())){
          $(".form-errors").text('Please use only digits for the 4 digits of your phone number')
          return false
        }
        else if($('.validate-admin-form .phone-input').val() != "" && !deuces.isFourDigitNumber($('.validate-admin-form .phone-input').val())){
          $(".form-errors").text('Please provide the last 4 digits of your phone number')
          return false
        }
      })
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
  },

  isNumber: function(string){
    return /^\d+$/.test(string)
  },

  isFourDigitNumber: function(string){
    return /^\d+$/.test(string) && string.length == 4
  },

  eitherFilled: function(){
    return ($('.validate-admin-form .name-input').val() != "" ||
    $('.validate-admin-form .phone-input').val() != "")
  },

}
