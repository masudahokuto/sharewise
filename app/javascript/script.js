// 3秒後にフラッシュメッセージをフェードアウト
setTimeout(function() {
  var flashMessages = document.getElementById('flash-messages');
  if (flashMessages) {
    flashMessages.style.transition = 'opacity 0.5s ease';
    flashMessages.style.opacity = '0';
    setTimeout(function() {
      flashMessages.remove();
    }, 500);
  }
}, 3000);

// 上部に戻るボタン
$(function() {
  $('#back a').on('click',function(event){
    $('body, html').animate({
      scrollTop:0
    }, 500);
    event.preventDefault();
  });
});