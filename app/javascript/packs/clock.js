document.getElementById('toggleClockButton').addEventListener('click', function() {
  var clockContainer = document.getElementById('clockContainer');

  if (clockContainer.classList.contains('hidden')) {
    clockContainer.classList.remove('hidden');
    this.textContent = '時計'; // ボタンのテキストを更新
  } else {
    clockContainer.classList.add('hidden');
    this.textContent = '時計'; // ボタンのテキストを更新
  }
});
document.addEventListener('DOMContentLoaded', (event) => {
  function updateClock() {
    const now = new Date();
    const seconds = now.getSeconds();
    const minutes = now.getMinutes();
    const hours = now.getHours();

    // 時計の角度を計算する
    const secondDegrees = (seconds / 60) * 360;  // 秒針の角度
    const minuteDegrees = (minutes / 60) * 360 + (seconds / 60) * 6; // 分針の角度 + 秒針の影響
    const hourDegrees = ((hours % 12) / 12) * 360 + (minutes / 60) * 30; // 時針の角度 + 分針の影響

    // 要素の取得
    const secondHand = document.querySelector('.second-hand');
    const minuteHand = document.querySelector('.minute-hand');
    const hourHand = document.querySelector('.hour-hand');

    // 要素が存在する場合にスタイルを設定
    if (secondHand) {
      secondHand.style.transform = `rotate(${secondDegrees}deg)`;
    }

    if (minuteHand) {
      minuteHand.style.transform = `rotate(${minuteDegrees}deg)`;
    }

    if (hourHand) {
      hourHand.style.transform = `rotate(${hourDegrees}deg)`;
    }
  }

  // 1秒ごとに時計を更新
  setInterval(updateClock, 1000);

  // 初期表示のために1回呼び出し
  updateClock();
});

