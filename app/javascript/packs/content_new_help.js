document.addEventListener('DOMContentLoaded', function () {
  const helpButton = document.getElementById('help-button');
  const helpContent = document.getElementById('help-content');

  function toggleHelpButton() {
    if (helpContent.classList.contains('d-none')) {
      helpContent.classList.remove('d-none');
    } else {
      helpContent.classList.add('d-none');
    }
  }

  helpButton.addEventListener('click', toggleHelpButton);
});