$(document).on('turbolinks:load', function() {

  window.toggleEditForm = function(genreId) {
    $('#genre-name-' + genreId).toggle();
    $('#genre-edit-form-' + genreId).toggle();
  };

  $(document).on('click', '.edit-btn', function() {
    var genreId = $(this).data('genre-id');
    toggleEditForm(genreId);
  });

  // フォーム送信の処理（`form_with` の非同期送信を活用する場合）
  $(document).on('ajax:success', 'form[id^="edit-form-"]', function(event) {
    var [data, status, xhr] = event.detail;
    var form = $(this);
    var genreId = form.attr('id').replace('edit-form-', '');
    $('#genre-name-' + genreId).text(form.find('input[name="genre_name"]').val());
    toggleEditForm(genreId); // フォームを隠す
  });

  $(document).on('ajax:error', 'form[id^="edit-form-"]', function(event) {
  });
});