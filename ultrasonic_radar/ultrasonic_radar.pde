import processing.serial.*; 
import java.awt.event.KeyEvent; 
import java.io.IOException;

Serial myPort; 

String stringAngle = "";
String stringDistance = "";
String stringData = "";
float pixsDistance;
float angle;
float distance;
int index = 0;
int counter = 0;

boolean sendToTelegram = false;    //флаг отправки в Телеграм
PrintWriter output;  //объект файла
String[] scriptID;  //массив Айдишников
String[] tempSplitLine;  //нужно чтоб удобно заменить (\) на (\\)
String portName;    //имя порта
String scriptPath = "script.bat";    //путь до батника
String TelegramIDPath = "Settings and TelegramID.txt";    //путь до ID Телеграмма
String scriptName = "@curl \"https://api.telegram.org/bot1870867411:AAG4sQQjiZxABWPhsxGQdHeyAXa0Gs3q0IE/sendMessage?chat_id=";    //фиксированое начало скрипта

//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//


//сетап
void setup() {
  //настройки экрана
  background(31, 31, 31);
  size (1600, 2000);
  smooth();

  //настройки файлов
  output = createWriter(scriptPath);  //создаем файл батник
  scriptID = loadStrings(TelegramIDPath);  //грузим путь до дирректории и ID пользователей Телеграма
  portName = scriptID[1];
  tempSplitLine = split(scriptID[0], "\\");  //разбиваем Нулевую строк по символу (\), чтобы узнать путь до директории
  scriptID[0] = join(tempSplitLine, "\\\\");  //собираем обратно в одну с уже двумя (\\)

  //настройки Serial
  myPort = new Serial(this, portName, 9600); 
  myPort.bufferUntil('*');
}


//сообщение в телеграм
void TelegramNotification() {
  output = createWriter(scriptPath);  //открываем файл "script.bat";
  output.println("chcp 1251");

  //пишем в файл:    1.Скрипт 2.Айдишник пользователя 3.Расстояние 4.Угол
  for (int i = 2; i < scriptID.length; ++i) {
    output.println(scriptName + scriptID[i] + "&text=Найден объект на расстоянии: " + distance + " см; угол (" + angle +"°)\"" );
  }

  output.flush();  //записываем в файл
  output.close();  //закрываем файл

  sendToTelegram = false;   //ставим что уже отправили
  launch(scriptID[0] + "\\\\" + scriptPath);  //запуск bat файла по указанному пути
}


//функция рисования
void draw() {

  fill(98, 245, 31);
  strokeJoin(ROUND);
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, 1010); 

  fill(98, 245, 31); 

  //рисуем все
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

//функция когда на порт приходят данные
void serialEvent (Serial myPort) { 

  try {
    stringData = myPort.readStringUntil('*');
    stringData = stringData.substring(0, stringData.length()-1);

    index = stringData.indexOf(";"); 
    stringAngle = stringData.substring(0, index); 
    stringDistance = stringData.substring(index+1, stringData.length()); 

    angle = float(stringAngle);  //сейвим угол
    distance = float(stringDistance);  //сейвим дистанцию
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}

//функция для сетки радара
void drawRadar() {
  pushMatrix();
  translate(800, 850); 
  noFill();
  strokeWeight(4);
  stroke(255, 215, 1);
  // draws the arc lines
  arc(0, 0, 1500, 1500, PI, TWO_PI);
  arc(0, 0, 1200, 1200, PI, TWO_PI);
  arc(0, 0, 900, 900, PI, TWO_PI);
  arc(0, 0, 600, 600, PI, TWO_PI);
  arc(0, 0, 300, 300, PI, TWO_PI);
  // draws the angle lines
  line(-750, 0, 750, 0);
  line(0, 0, -750*cos(radians(30)), -750*sin(radians(30)));
  line(0, 0, -750*cos(radians(60)), -750*sin(radians(60)));
  line(0, 0, -750*cos(radians(90)), -750*sin(radians(90)));
  line(0, 0, -750*cos(radians(120)), -750*sin(radians(120)));
  line(0, 0, -750*cos(radians(150)), -750*sin(radians(150)));
  line(-750*cos(radians(30)), 0, 750, 0);
  popMatrix();
}


//функция для синий линии
void drawObject() {
  pushMatrix();
  translate(800, 850); 
  strokeWeight(33);
  stroke(0, 87, 183); 
  pixsDistance = distance*15.0; 
  //
  if (distance <= 50.0) { 
    line(-pixsDistance*cos(radians(angle)), -pixsDistance*sin(radians(angle)), -748*cos(radians(angle)), -748*sin(radians(angle)));

    pushMatrix();
    stroke(31, 31, 31);
    strokeWeight(15);
    strokeCap(SQUARE);
    line(-750, 10, 750, 10);
    popMatrix();
  } 
  popMatrix();
} 


//функция для желтой линии
void drawLine() { 
  pushMatrix(); 
  strokeWeight(15); 
  stroke(255, 215, 1); 
  translate(800, 850);  
  line(0, 0, -748*cos(radians(angle)), -748*sin(radians(angle))); 
  pushMatrix();
  stroke(31, 31, 31);
  strokeWeight(15);
  strokeCap(SQUARE);
  line(-750, 10, 750, 10);
  popMatrix();
  popMatrix();
} 


//текст
void drawText() {
  fill(255, 215, 1);

  //принт размеров на экран
  pushMatrix();
  translate(800, 850);
  textSize(25);
  text("10см", 50, -10);
  text("20см", 200, -10);
  text("30см", 350, -10);
  text("40см", 500, -10);
  text("50см", 650, -10);
  popMatrix();

  //принт надписей на экран
  pushMatrix();
  translate(800, 850);
  textSize(40);
  noStroke();
  fill(31, 31, 31);
  rect(-710, 10, 455, 60);

  //счетчик частоты находа для Телеграма
  counter++;
  if (counter == 512) {  //256 = 180° (1 прогон), 512 = 360° (2 прогона)
    sendToTelegram = !sendToTelegram;  //меняем на противоположный
    counter = 0;
  }

  //если дистанция < 50 - принтим на экран и в Телегу
  if (distance <= 50.0) {
    fill(0, 87, 183);
    text("Объект обнаружен", -700, 60);

    //если можно отправлять запрос
    if (sendToTelegram) {
      TelegramNotification();
    }
  } else {  //если нет - Объект не обнаружен
    fill(255, 215, 1);
    text("Объект не обнаружен", -700, 60);
  }

  //принт угла на экран
  noStroke();
  fill(31, 31, 31);
  rect(35, 10, 250, 60);
  fill(255, 215, 1);
  text("Угол: " + angle +"°", -75, 60);

  //принт расстояния на экран
  noStroke();
  fill(31, 31, 31);
  rect(540, 10, 200, 60);
  fill(255, 215, 1);
  if (distance <= 50.0) {
    text("Расстояние: " + distance + "см", 300, 60);
  } else {
    text("Расстояние:", 300, 60);
  }
  popMatrix();

  //принт цифр углов:
  pushMatrix();
  textSize(30);

  translate(795+775*cos(radians(0)), 820-775*sin(radians(0)));
  rotate(-radians(-87));
  text("180°", 0, 0);

  resetMatrix();
  translate(800+775*cos(radians(30)), 850-775*sin(radians(30)));
  rotate(-radians(-60));
  text("150°", 0, 0);

  resetMatrix();
  translate(800+775*cos(radians(60)), 850-775*sin(radians(60)));
  rotate(-radians(-30));
  text("120°", 0, 0);

  resetMatrix();
  translate(800+775*cos(radians(90)), 850-775*sin(radians(90)));
  rotate(radians(0));
  text("90°", 0, 0);

  resetMatrix();
  translate(800+775*cos(radians(120)), 850-775*sin(radians(120)));
  rotate(radians(-30));
  text("60°", 0, 0);

  resetMatrix();
  translate(800+775*cos(radians(150)), 850-775*sin(radians(150)));
  rotate(radians(-60));
  text("30°", 0, 0);

  resetMatrix();
  translate(805+775*cos(radians(180)), 850-775*sin(radians(180)));
  rotate(radians(-87));
  text("0°", 0, 0);

  popMatrix();
}
