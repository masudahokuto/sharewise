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
  const linkNameField = document.getElementById('link_name');
  const maxLength = 20;

  if (linkNameField) {
    linkNameField.addEventListener('input', function() {
      if (linkNameField.value.length > maxLength) {
        linkNameField.style.color = 'red';
      } else {
        linkNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const bodyArea = document.getElementById('body');
  const maxLength = 3000;

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

$(document).on('turbolinks:load', function() {
  const commentArea = document.getElementById('comment');
  const maxLength = 200;

  if (commentArea) {
    commentArea.addEventListener('input', function() {
      if (commentArea.value.length > maxLength) {
        commentArea.style.color = 'red';
      } else {
        commentArea.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const lastNameField = document.getElementById('last_name');
  const maxLength = 20;

  if (lastNameField) {
    lastNameField.addEventListener('input', function() {
      if (lastNameField.value.length > maxLength) {
        lastNameField.style.color = 'red';
      } else {
        lastNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const firstNameField = document.getElementById('first_name');
  const maxLength = 20;

  if (firstNameField) {
    firstNameField.addEventListener('input', function() {
      if (firstNameField.value.length > maxLength) {
        firstNameField.style.color = 'red';
      } else {
        firstNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const nickNameField = document.getElementById('nick_name');
  const maxLength = 20;

  if (nickNameField) {
    nickNameField.addEventListener('input', function() {
      if (nickNameField.value.length > maxLength) {
        nickNameField.style.color = 'red';
      } else {
        nickNameField.style.color = '';
      }
    });
  }
});

$(document).on('turbolinks:load', function() {
  const profileArea = document.getElementById('profile');
  const maxLength = 40;

  if (profileArea) {
    profileArea.addEventListener('input', function() {
      if (profileArea.value.length > maxLength) {
        profileArea.style.color = 'red';
      } else {
        profileArea.style.color = '';
      }
    });
  }
});