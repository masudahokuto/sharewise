document.addEventListener('DOMContentLoaded', (event) => {
  const helpButton = document.getElementById('help-button');
  const helpContent = document.getElementById('help-content');

  function toggleHelpButton() {
    if (helpContent.classList.contains('d-none')) {
      helpContent.classList.remove('d-none');
    } else {
      helpContent.classList.add('d-none');
    }
  }

  // クリックイベントを関数に変更
  helpButton.addEventListener('click', toggleHelpButton);
});