($(function(){//为有未完成任务的菜单增加动画效果
  var main_menu_items_has_alert = [];

  $('.navbar li.dropdown').each(function(idx,ele){
    var hasTodo = false;
    $(this).find(".alert-danger").each(function(_idx,_ele){
      if(parseInt($(this).text())>0){
        hasTodo = true;
      }
    });

    if (hasTodo)
      main_menu_items_has_alert.push($(this));
  });

  $(main_menu_items_has_alert).each(function(idx,ele){
    $(this).toggleClass("swing");
  });

  setInterval(
    function(){
      $(main_menu_items_has_alert).each(function(idx,ele){
        $(this).toggleClass("swing");
      });
    }
  ,5000);
}));