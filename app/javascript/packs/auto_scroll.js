  $(document).on('turbolinks:load', function() {
  $('.auto-scroll').jscroll({ // 追加したdivのclass名と合わせる
    contentSelector: '.auto-scroll',
    nextSelector: '.pagination a[rel=next]', // 次ページリンクのセレクタ
    loadingHtml: '読み込み中',
    padding: 10
    });
  });