deuces = {

  init: function(){
    $('.submit-btn').click(function(){
      console.log($($(this).data('target')))
      $($(this).data('target')).submit()
      return false
    })
  }
}
