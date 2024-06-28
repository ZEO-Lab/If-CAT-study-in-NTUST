// Depth sorting example by Jakub Valtar
// https://github.com/JakubValtar
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.util.*;
import gifAnimation.*;

private String page_name = "選擇貓咪";
private String student_cat = "pipi";
private String filePath = "pic/character/enemy/paper.png";
private int page_state = 2;
private int keybits = 0;
private int level = 1;

private int MoveingLeft, MoveingRight;
private int MoveingTop, MoveingDown;
private int Shooting, LaserShoot;
private int CallMenu;

private HashMap<String, page> hm = new HashMap<String, page>();
private Robot robot;
public Gif warning;

private ChooseCat cat;
private MainPage m1;
private ChoosePage cp1;
private College_Freshman cf1;
private College_Sophomore cs1;
private College_Junior cj1;
private College_Senior cs2;
private College_Graduate  research;

void setup() {
  size(900, 700);
  surface.setTitle("If 貓咪 study in NTUST");
  try {
    robot = new Robot();
  }
  catch(AWTException e) {
  }

  cat = new ChooseCat();
  m1 = new MainPage(student_cat);
  cp1 = new ChoosePage(student_cat, level);
  cf1 = new College_Freshman(student_cat);
  cs1 = new College_Sophomore(student_cat);
  cj1 = new College_Junior(student_cat);
  cs2 = new College_Senior(student_cat);
  research = new College_Graduate(student_cat);

  hm.put("選擇貓咪", cat);
  hm.put("主畫面", m1);
  hm.put("選擇學期", cp1);
  hm.put("大一", cf1);
  hm.put("大二", cs1);
  hm.put("大三", cj1);
  hm.put("大四", cs2);
  hm.put("研究所", research);
  shift();

  warning = new Gif (this, "pic/warning.gif");
  warning.play();
}
void draw() {
  // println("page_state:",page_state);
  // println("next_exe_state:",next_exe_state);
  keybits = (1<<7) | (CallMenu << 6) | (LaserShoot << 5) | (Shooting << 4) | (MoveingDown << 3) | (MoveingTop << 2) | (MoveingRight << 1) | MoveingLeft;
  switch(page_state) {
  case 0:
    if (!mousePressed) {
      reset(page_name, hm.get(page_name));
      page_state = 1;
    }
    break;
  case 1:
    hm.get(page_name).render();
    page_state = (hm.get(page_name).cut.startCutscene()) ? 2 : 1;
    break;
  case 2:
    hm.get(page_name).render();
    switch(page_name) {
    case "選擇貓咪":
      if (cat.getCat() != "wait") {
        student_cat = cat.getCat();
        // page_name = "主畫面";
      }
      break;
    case "主畫面":
      if (hm.get(page_name).theChoseButton() == "退出") {
        exit();
      }
    case "選擇關卡":
      break;
    default :
      hm.get(page_name).move(keybits);
      if (hm.get(page_name).getlevelPass()) {
        level = hm.get(page_name).getLevel() + 1;
      }
      break;
    }
    page_state = (hm.get(page_name).isComplete()) ? 3 : 2;
    break;
  case 3:
    page_state = (hm.get(page_name).cut.endCutscene()) ? 4 : 3;
    break;
  case 4:
    page_state = (hm.get(page_name).cut.runCutscene()) ? 5 : 4;
    break;
  case 5:
    page_name =  hm.get(page_name).theChoseButton();
    page_state = 0;
    break;
  }
}

void reset(String page_str, page obj) {
  hm.remove(page_str);
  switch(page_str) {
  case"主畫面" :
    obj = new MainPage(student_cat);
    break;
  case"選擇關卡":
    obj = new ChoosePage(student_cat, level);
    break;
  case"大一" :
    obj = new College_Freshman(student_cat);
    break;
  case"大二" :
    obj = new College_Sophomore(student_cat);
    break;
  case"大三" :
    obj = new College_Junior(student_cat);
    break;
  case "大四":
    obj = new College_Senior(student_cat);
    break;
  case "研究所" :
    obj = new College_Graduate(student_cat);
    break;
  }
  hm.put(page_str, obj);
}

void shift() {
  robot.keyPress(KeyEvent.VK_SHIFT);
  robot.keyRelease(KeyEvent.VK_SHIFT);
}
void mousePressed() {
  if (mouseButton ==  LEFT) {
    Shooting = 1;
  }
  if (mouseButton ==  RIGHT) {
    LaserShoot = 1;
  }
}
void mouseReleased() {
  if (mouseButton ==  LEFT) {
    Shooting = 0;
  }
  if (mouseButton ==  RIGHT) {
    LaserShoot = 0;
  }
}
void keyPressed() {
  if (key == 'a') {
    MoveingLeft = 1;
  }
  if (key == 'd') {
    MoveingRight = 1;
  }
  if (key == 'w') {
    MoveingTop = 1;
  }
  if (key == 's') {
    MoveingDown = 1;
  }
  if (key == ESC) {
    key = 0;
    CallMenu = 1;
  }
}

void keyReleased() {
  if (key == 'a') {
    MoveingLeft = 0;
  }
  if (key == 'd') {
    MoveingRight = 0;
  }
  if (key == 'w') {
    MoveingTop = 0;
  }
  if (key == 's') {
    MoveingDown = 0;
  }
  if (key == ESC) {
    key = 0;
    CallMenu = 0;
  }
}

public class RectObject {
  public float x, y;
  public float w, h;
  public RectObject(float _xpos, float _ypos, float _width, float _height) {
    x = _xpos;
    y = _ypos;
    w = _width;
    h = _height;
  }
}
