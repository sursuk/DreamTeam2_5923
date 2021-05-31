//функция для генерации импульса(поиск объекта)
void generateImpulse() {

//цикл для среднего медианного
for (int i = 0; i < 3; i++) {
digitalWrite(PIN_TRIG, LOW);  //генерация короткого импульса
delayMicroseconds(2);
digitalWrite(PIN_TRIG, HIGH); //генерация длинного импульса
delayMicroseconds(10);
digitalWrite(PIN_TRIG, LOW);
duration = pulseIn(PIN_ECHO, HIGH, 10000);  //вычиление растояния
averegeResults[i] = (duration < 1.0) ? (100.0) : ((duration / 2.0) / 29.1); //если pulseIn не нашла объект за 10мс - будем считать что дистация 100, если нашла - вычисляем
}

//в distance присваивается реузльтат среднего медианного
distance = ((averegeResults[0] >= averegeResults[1] && averegeResults[0] <= averegeResults[2]) || (averegeResults[0] <= averegeResults[1] && averegeResults[0] >= averegeResults[2])) ? (averegeResults[0])
: (((averegeResults[1] >= averegeResults[0] && averegeResults[1] <= averegeResults[2]) || (averegeResults[1] <= averegeResults[0] && averegeResults[1] >= averegeResults[2])) ? (averegeResults[1]) : (averegeResults[2]));

//передаем данные в процессинг
Serial.print(float(Azimuth) * (180.0 / 256.0));
Serial.print(";");
Serial.print(distance);
Serial.print("*");

//ждем 20мс
while (millis() - radarTime < 20);
radarTime = millis();
}
