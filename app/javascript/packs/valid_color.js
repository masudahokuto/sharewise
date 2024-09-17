$(document).on('turbolinks:load', function() {
  const categoryNameField = document.getElementById('category_name');
  const maxLength = 20;

  if (categoryNameField) {
    categoryNameField.addEventListener('input', function() {
      if (categoryNameField.value.length > maxLength) {
        categoryNameField.style.color = 'red';
      } else {
        categoryNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const titleNameField = document.getElementById('title_name');
  const maxLength = 20;

  if (titleNameField) {
    titleNameField.addEventListener('input', function() {
      if (titleNameField.value.length > maxLength) {
        titleNameField.style.color = 'red';
      } else {
        titleNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const genreNameField = document.getElementById('genre_name');
  const maxLength = 20;

  if (genreNameField) {
    genreNameField.addEventListener('input', function() {
      if (genreNameField.value.length > maxLength) {
        genreNameField.style.color = 'red';
      } else {
        genreNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const contentNameField = document.getElementById('content_name');
  const maxLength = 20;

  if (contentNameField) {
    contentNameField.addEventListener('input', function() {
      if (contentNameField.value.length > maxLength) {
        contentNameField.style.color = 'red';
      } else {
        contentNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const bodyArea = document.getElementById('body');
  const maxLength = 5000;

  if (bodyArea) {
    bodyArea.addEventListener('input', function() {
      if (bodyArea.value.length > maxLength) {
        bodyArea.style.color = 'red';
      } else {
        bodyArea.style.color = '';
      }
    });
  }
});
