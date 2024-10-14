  $(document).on('turbolinks:load', function() {
  $('.auto-scroll-comment').jscroll({ // 追加したdivのclass名と合わせる
    contentSelector: '.auto-scroll-comment',
    nextSelector: '.pagination a[rel=next]', // 次ページリンクのセレクタ
    loadingHtml: '読み込み中',
    padding: 10
    });
  });