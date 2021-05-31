//функция, подающая сигнал на диод и излучатель звука
void makeSignal() {
  if ((distance > 40.0) && (distance <= 50.0)) {
    if (signalFlag != 5) {  //если флаг был, чтобы не заходить повторно для каждого вида сигналов
      tone(PIN_SIGN, 250);  //пищим не напряжно
      signalFlag = 5;
    }
  }
  else if ((distance > 30.0) && (distance <= 40.0)) {
    if (signalFlag != 4) {
      tone(PIN_SIGN, 500);
      signalFlag = 4;
    }
  }
  else if ((distance > 20.0) && (distance <= 30.0)) {
    if (signalFlag != 3) {
      tone(PIN_SIGN, 750);  //пищим сильнее
      signalFlag = 3;
    }
  }
  else if ((distance > 10.0) && (distance <= 20.0)) {
    if (signalFlag != 2) {
      tone(PIN_SIGN, 1000);
      signalFlag = 2;
    }
  }
  else if ((distance > 0) && (distance < 10.0)) {
    if (signalFlag != 1) {
      tone(PIN_SIGN, 1250); //орем
      signalFlag = 1;
    }
  }
  else {
    noTone(PIN_SIGN); //не обнаружено - отключаем подачу сигнала
    signalFlag = 0;
  }
}
