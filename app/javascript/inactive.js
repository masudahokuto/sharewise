$(document).on('turbolinks:load', function() {
  $('#show-inactive-users').on('click', function() {
    console.log('Button clicked!');  // クリック確認用のログ
    $.ajax({
      url: '/admin/users/inactive',
      type: 'GET',
      dataType: 'script',
      success: function() {
        console.log('AJAX request successful');  // リクエスト成功時のログ
      },
      error: function() {
        console.log('AJAX request failed');  // リクエスト失敗時のログ
      }
    });
  });
});