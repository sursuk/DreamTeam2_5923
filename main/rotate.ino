//функция поворота двигателя на шаг
void rotate() {
  if (rotateDirection == 0) {   //какое направление поворота?
    turnAside(1);    //против часовой

    Azimuth++;                  //каждые 8 шагов увеличивает азимут
    if (Azimuth >= 256) {       //если ушел влево

      //меняем направление
      Azimuth = 256;
      rotateDirection = 1;
      stepCounter = 2048;
    }
  }
  else
  {
    turnAside(-1);    //по часовой

    Azimuth--;                  //каждые 8 шагов уменьшает азимут
    if (Azimuth < 0) {          //если ушел вправо

      //меняем направление
      Azimuth = 0;
      rotateDirection = 0;
      stepCounter = 0;

    }
  }

  //каждый прогон двигателя сохраняем данные о текущем положении и направлении в энергонезависимую память
  address = 0;
  EEPROM.put(address, Azimuth);
  address += 4;
  EEPROM.put(address, rotateDirection);
  address += 4;
  EEPROM.put(address, stepCounter);
  address += 4;
}
