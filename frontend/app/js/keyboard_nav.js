$(function(){
  Mousetrap.bind(['command+enter', 'ctrl+enter'], function(){
    var focusedElement = $(document.activeElement);
    if(focusedElement.hasClass('mousetrap')){
      focusedElement.parents('form').submit();
    }
  })
})
