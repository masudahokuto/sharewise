document.addEventListener("DOMContentLoaded", () => {
  // いいねボタンを選択
  document.querySelectorAll('.favorite-link').forEach(link => {
    link.addEventListener('click', event => {
      event.preventDefault(); // デフォルトのリンク動作を防ぐ

      const url = link.href; // リンクの URL を取得

      fetch(url, {
        method: link.dataset.method || 'GET', // メソッドを取得、デフォルトは GET
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })
      .then(response => response.json())
      .then(data => {
        // いいねの数とアイコンを更新
        link.innerHTML = data.html;
      })
      .catch(error => console.error('Error:', error));
    });
  });
});