abstract class page {
    public int Level;
    
    public String chosebut = "主畫面";
    public String cat = "pipi";
    public boolean PageComplete = false;
    public boolean LevelComplete = false;
    
    public GameMap gmap;
    
    public Cutscene cut  = new Cutscene(width / 2 ,height / 2 ,cat);
    page() {}
    page(String pagename) {
        chosebut = pagename;
    }
    page(String pagename , String catname) {
        chosebut = pagename;
        cat = catname;
        cut  = new Cutscene(width / 2 ,height / 2 ,catname);
    }
    page(String pagename, String catname,color backgroundColor) {
        chosebut = pagename;
        cat = catname;
        cut  = new Cutscene(width / 2 ,height / 2 ,catname);
        gmap = new GameMap(backgroundColor);
    }
    page(String pagename, String catname,String imgPath) {
        chosebut = pagename;
        cat = catname;
        cut  = new Cutscene(width / 2 ,height / 2 ,catname);
        gmap = new GameMap(imgPath);
    }
    
    abstract void render();
    void move(int moveInstr) {}
    abstract void option();
    String theChoseButton() {
        return chosebut;
    }
    boolean isComplete() {
        return PageComplete;
    }
    int getLevel() {
        return Level;
    }
    boolean getlevelPass() {
        return LevelComplete;
    }
}

class Cutscene {
    private float left_x_1 = 0;
    private float right_x_1 = width;
    private float left_x_2 = width / 2;
    private float right_x_2 = width / 2;
    private float xpos , ypos;
    private float wid = 500 ,hei, ratio;
    private int seconds = 0;
    private boolean start = false;
    private String loading[] = {"Loading","Loading.","Loading..","Loading..."};
    
    private PImage introImg;
    Cutscene(float _x,float _y, String catname) {
        xpos = _x;
        ypos = _y;
        introImg = loadImage("pic/page/" + catname + "/cutscene.jpg");
        ratio = introImg.width / wid;
        hei = introImg.height / ratio;
    }
    boolean startCutscene() {
        rectMode(CORNER);
        left_x_2 -= 15;
        right_x_2 += 15;
        noStroke();
        fill(42);
        rect(0,0,left_x_2,height);
        rect(right_x_2,0,width,height);
        return(left_x_2<= 0) && (right_x_2 >= width);
    }
    boolean runCutscene() {
        if (!start) {
            seconds = millis();
            start = true;
        }
        background(42);
        imageMode(CENTER);
        image(introImg , xpos , ypos , wid , hei);
        textAlign(CENTER);
        textSize(50);
        fill(255);
        text(loading[second() % 4] , width / 2 , height - 100);
        return millis() > (seconds + 3000); 
    }
    boolean endCutscene() {
        rectMode(CORNER);
        left_x_1 += 15;
        right_x_1 -= 15;
        noStroke();
        fill(42);
        rect(0,0,left_x_1,height);
        rect(right_x_1,0,width,height);
        
        return left_x_1>= right_x_1;
    }
}
