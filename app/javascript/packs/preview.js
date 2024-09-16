$(document).on('turbolinks:load', function() {
  // 画像フィールド追加処理
  $('#add_image_button').click(function () {
    const fieldsNum = $('.post-image-field').children("div").length; // .post-image-field内部のdivタグの数を調べる

    if (fieldsNum >= 3) { // 3枚制限
      return false;
    }

    // 追加するフィールド情報
    const field = `
      <div class="file-field_${fieldsNum} mb-3">
        <input name="post[images][]" type="file" aria-num="${fieldsNum}" onchange="fileSelect(this);">
        <img id="preview_area_${fieldsNum}">
      </div>
      `
    $('.post-image-field').append(field) // HTMLをフィールドに追加
  })


  window.fileSelect = function (element) {
    const fieldsNum = $(element).attr('aria-num'); // フィールド番号
    const file = $(element).prop('files')[0]; // ファィル1つ目
    const reader = new FileReader(); // Base64に変更準備

    // 画像をBase64エンコード
    reader.onload = (function(file){
      return function(e){
        $(`#preview_area_${fieldsNum}`).addClass('new-img mt-2').attr('src', e.target.result)
      };
    })(file);
    reader.readAsDataURL(file);
  }
});

$(document).on('turbolinks:load', function() {
  // 画像フィールド追加処理
  $('#add_image_button').click(function () {
    const fieldsNum = $('.content-image-field').children("div").length; // .content-image-field内部のdivタグの数を調べる

    if (fieldsNum >= 3) { // 3枚制限
      return false;
    }

    // 追加するフィールド情報
    const field = `
      <div class="file-field_${fieldsNum} mb-3">
        <input name="content[images][]" type="file" aria-num="${fieldsNum}" onchange="fileSelect(this);">
        <img id="preview_area_${fieldsNum}">
      </div>
      `
    $('.content-image-field').append(field) // HTMLをフィールドに追加
  })


  window.fileSelect = function (element) {
    const fieldsNum = $(element).attr('aria-num'); // フィールド番号
    const file = $(element).prop('files')[0]; // ファィル1つ目
    const reader = new FileReader(); // Base64に変更準備

    // 画像をBase64エンコード
    reader.onload = (function(file){
      return function(e){
        $(`#preview_area_${fieldsNum}`).addClass('new-img mt-2').attr('src', e.target.result)
      };
    })(file);
    reader.readAsDataURL(file);
  }
});