document.addEventListener('DOMContentLoaded', function () {
  const daySelect = document.querySelector('#user_birthday_3i');
  const monthSelect = document.querySelector('#user_birthday_2i');
  const yearSelect = document.querySelector('#user_birthday_1i');

  function updateDayOptions() {
    const month = parseInt(monthSelect.value, 10);
    const year = parseInt(yearSelect.value, 10);

    let maxDays;

    if (month === 2) {
      // 2月の最大日数を計算
      maxDays = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
    } else if ([4, 6, 9, 11].includes(month)) {
      // 30日の月
      maxDays = 30;
    } else {
      // 31日の月
      maxDays = 31;
    }

    // 現在の日の選択肢を制限
    for (let day = 1; day <= 31; day++) {
      const option = daySelect.querySelector(`option[value="${day}"]`);
      if (option) {
        if (day > maxDays) {
          option.style.display = 'none';
        } else {
          option.style.display = 'block';
        }
      }
    }
  }

  // 月または年が変更されたときに日の選択肢を更新
  monthSelect.addEventListener('change', updateDayOptions);
  yearSelect.addEventListener('change', updateDayOptions);

  // ページ読み込み時に選択肢を初期化
  updateDayOptions();
});