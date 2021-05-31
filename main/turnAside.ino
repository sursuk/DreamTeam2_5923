//функция поворота в одну сторону
void turnAside(int a) {
  for (int i = 0; i < 8; ++i) {
    // поворот
    Index = stepCounter % 8;                  //вычисляет индекс массива
    Pattern = PORTB;                          //получаем текущий Pattern
    Pattern = Pattern & B11110000;            //preserve MSN?? (созраняем MSN)?
    Pattern = Pattern | Motor[Index];         //делаем новый Pattern
    PORTB = Pattern;                          //отправляем новый Pattern мотору
    stepCounter += a;                         //к количеству шагов прибаляем направление
    delay(Delay);                             //контролирует скорость поворота (Delay=1)
  }
}
