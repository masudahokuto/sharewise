$(document).on('turbolinks:load', function() {
  window.toggleEditForm = function(categoryId) {
    $('#category-name-' + categoryId).toggle();
    $('#category-edit-form-' + categoryId).toggle();
  };
  $(document).on('click', '.edit-btn', function() {
    console.log("click");
    
    var categoryId = $(this).data('category-id');
    toggleEditForm(categoryId);
  });
  $(document).on('ajax:success', 'form[id^="edit-form-"]', function(event) {
    
    console.log("success");
    
    var [data, status, xhr] = event.detail;
    var form = $(this);
    var categoryId = form.attr('id').replace('edit-form-', '');
    $('#category-name-' + categoryId).text(form.find('input[name="category_name"]').val());
    toggleEditForm(categoryId);
  });
  $(document).on('ajax:error', 'form[id^="edit-form-"]', function(event) {
    console.log("error");
  });
});

