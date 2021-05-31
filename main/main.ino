#include <EEPROM.h>
#define PIN_TRIG 5               //пин импульса
#define PIN_ECHO 6               //пин приема эхолокации
#define PIN_SIGN 13              //пин сигнала

byte Motor[8] =                  //шаги двигателя
{ B00001000,
  B00001100,
  B00000100,
  B00000110,
  B00000010,
  B00000011,
  B00000001,
  B00001001
};
int Index = 0;                  // индекс массива Motor[]

int Azimuth = 0;                //Азимут (PI/128 радиан) измеренный против часовой стрелки
byte Pattern;                   //положение движка
int rotateDirection = 0;        //против часовой = -1, по часовой = 1
float duration = 0.0;           //длительность импульса
float distance = 0.0;           //расстояние до объекта
int Delay = 1;                  //дать время на движение двигателя
int stepCounter = 0;            //180 градусов = 2048 шагов
int address = 0;                //адрес для энегронезависимой памяти
float averegeResults[3];        //массив для вычисления среднего медианного

int signalFlag = 0;             //флаг разновидности сигнала
int rotateTime = 0;             //время на один поворот
int radarTime = 0;              //время на один скан радаром

////////////////////////////////////////////////////////


void setup() {
  //выставляем пины
  pinMode(PIN_SIGN, OUTPUT);
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
  Pattern = DDRB;                       //получить PORTB
  Pattern = Pattern | B00001111;        //сохранить MSN
  DDRB = Pattern;                       //отправляем Pattern мотору

  Serial.begin(9600);                   //порт для общения, в данном случае с процессингом

  //загружаем данные о положении мотора
  EEPROM.get(address, Azimuth);
  address += 4;
  EEPROM.get(address, rotateDirection);
  address += 4;
  EEPROM.get(address, stepCounter);
  address += 4;
}


void loop() {
  //каждые 25 мс поворачиваемся и ищем объекты
  if (millis() - rotateTime > 25 ) {
    rotateTime = millis();
    rotate(); //поворачиваем на шаг
    radar(); //функия радар
  }
}
