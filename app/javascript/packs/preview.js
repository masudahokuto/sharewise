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


// if (document.URL.match(/new/)) {
//   document.addEventListener('DOMContentLoaded', () => {
//     let imageFieldCount = 0;  // 画像フィールドのカウント、初期値0

//     // プレビュー画像を更新する関数
//     const updatePreviewImage = (input, previewImageId) => {
//       const file = input.files[0];  // 入力されたファイルを取得
//       if (file) {
//         const blob = window.URL.createObjectURL(file);  // Blob URLを生成

//         // 対応するプレビュー画像を取得
//         let previewImage = document.getElementById(previewImageId);
//         if (previewImage) {
//           previewImage.src = blob;  // 既存のプレビュー画像を置き換え
//         } else {
//           // プレビュー画像が存在しない場合、新たに作成
//           previewImage = document.createElement('img');
//           previewImage.setAttribute('id', previewImageId);
//           previewImage.setAttribute('class', 'new-img');
//           previewImage.setAttribute('src', blob);

//           // inputタグの親要素にプレビュー画像を追加
//           input.parentNode.appendChild(previewImage);
//         }
//       }
//     };

//     // 最初の画像フィールドのイベントリスナー
//     const fileInput = document.getElementById('post_images');
//     fileInput.addEventListener('change', (e) => {
//       const files = e.target.files;
//       for (let i = 0; i < files.length; i++) {
//         updatePreviewImage(e.target, `preview_image_${i}`);
//       }
//     });

//     // 画像追加ボタンのクリックイベント
//     document.getElementById('add_image_button').addEventListener('click', () => {
//       imageFieldCount++;  // 新しいフィールドのID用にカウントを増やす

//       // 新しい画像フィールドを作成
//       const newImageField = document.createElement('input');
//       newImageField.type = 'file';
//       newImageField.name = 'post[images][]';
//       newImageField.id = `post_image_${imageFieldCount}`;
//       newImageField.classList.add('form-control', 'mt-2');
//       newImageField.multiple = true;

//       // 新しいプレビューエリアを作成
//       const newPreviewDiv = document.createElement('div');
//       newPreviewDiv.id = `preview_area_${imageFieldCount}`;
//       newPreviewDiv.classList.add('mt-3');

//       // 新しい画像フィールドとプレビューエリアを追加
//       const imageFieldContainer = document.createElement('div');
//       imageFieldContainer.classList.add('post-image-field', 'col-md-4', 'mt-5');
//       imageFieldContainer.appendChild(newImageField);
//       imageFieldContainer.appendChild(newPreviewDiv);

//       // 画像フィールドを追加する場所に挿入
//       const postImageField = document.querySelector('.post-image-field');
//       postImageField.appendChild(imageFieldContainer);

//       // 新しい画像フィールドにイベントリスナーを追加
//       newImageField.addEventListener('change', (e) => {
//         updatePreviewImage(e.target, `preview_image_${imageFieldCount}`);
//       });
//     });
//   });
// }



// if (document.URL.match(/new/)){
//   document.addEventListener('DOMContentLoaded', () => {
//     const ImageList = document.getElementById('new-image');

//     const createImageHTML = (blob) => {
//       const imageElement = document.createElement('div');
//       imageElement.setAttribute('class', "image-element")
//       let imageElementNum = document.querySelectorAll('.image-element').length
//       imageElement.setAttribute('id', `img-element-${imageElementNum}`)
//       const blobImage = document.createElement('img');
//       blobImage.setAttribute('class', 'new-img')
//       blobImage.setAttribute('src', blob);
//       blobImage.setAttribute('id', `new-img-${imageElementNum}`)

//       const inputHTML = document.createElement('input');
//       inputHTML.setAttribute('id', `post_image_${imageElementNum}`);
//       inputHTML.setAttribute('class', 'post-images');
//       inputHTML.setAttribute('name', 'post[images][]');
//       inputHTML.setAttribute('type', 'file');

//       imageElement.appendChild(blobImage);
//       if (imageElementNum < 2) {
//         imageElement.appendChild(inputHTML);
//       }
//       ImageList.appendChild(imageElement);

//       document.getElementById('post_image_0').addEventListener('change', (e) => {
//         var preview = document.getElementById('new-img-1');
//         if (preview) {
//           //console.log('test')
//           //console.log(preview.parentNode)
//           preview.parentNode.firstElementChild.remove()
//           //var img1 = document.getElementById('img-element-1')
//           //console.log(img1)
//           //img1.appendChild(blobImage)

//           //console.log(imageElement);
//           //var img1 = document.getElementById('post_image_1')
//           //console.log(img1)
//           //img1.parentNode.appendChild(blobImage)
//         }
//       });

//       inputHTML.addEventListener('change', (e) => {
//         const file = e.target.files[0];
//         const blob = window.URL.createObjectURL(file);
//         createImageHTML(blob);
//         //console.log(e.target)
//         //console.log(e.target.closest)
//       });


//     };

//     document.getElementById('post_images').addEventListener('change', (e) =>{
//       // const imageContent = document.querySelector('img');
//       // if (imageContent){
//       //   imageContent.remove();
//       // }

//       const file = e.target.files[0];
//       const blob = window.URL.createObjectURL(file);
//       createImageHTML(blob);
//     });
//   });
// }