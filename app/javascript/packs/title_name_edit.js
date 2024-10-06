$(document).on('turbolinks:load', function() {
  window.toggleEditForm = function(titleId) {
    $('#title-name-' + titleId).toggle();
    $('#title-edit-form-' + titleId).toggle();
  };
  $(document).on('click', '.edit-btn', function() {
    var titleId = $(this).data('title-id');
    toggleEditForm(titleId);
  });
  $(document).on('ajax:success', 'form[id^="edit-form-"]', function(event) {
    var [data, status, xhr] = event.detail;
    var form = $(this);
    var titleId = form.attr('id').replace('edit-form-', '');
    $('#title-name-' + titleId).text(form.find('input[name="title_name"]').val());
    toggleEditForm(titleId);
  });
  $(document).on('ajax:error', 'form[id^="edit-form-"]', function(event) {
  });
});