public class ChooseCat extends page {
    String[] button_str = {"牛奶" ,"皮皮" , "小咪"};
    String[] cat_str = {"milk" ,"pipi" , "mi"};
    String choose_cat = "wait";

    Button[] button = new Button[3];
    PFont myFont;
    PImage backgroundImage ;
    PImage milk=loadImage("pic/Character/milk/right.png");
    PImage pipi=loadImage("pic/Character/pipi/right.png");
    PImage mi=loadImage("pic/Character/mi/right.png");

    public ChooseCat () {
        super("選擇貓咪","creater");
        backgroundImage = loadImage("pic/ntust.jpg");
        for(int i=0;i<button.length;i++){
            button[i] = new Button(width/4*(i+1) , height/2+200 , 200,70 , button_str[i] );
            button[i].setContent(cat_str[i]);
        }
    }
    void render(){
        imageMode(CORNER);
        image(backgroundImage , 0 , 0,width,height);
        title(width / 2,height / 2 - 200);
        rectMode(CENTER);
        fill(255,150);
        rect(width/2 , height/2+50 , 800 ,400,20);
        option();
    }
    void title(int x,int y) {
        textAlign(CENTER);
        myFont = createFont("標楷體",80);/* 直接輸入字型名稱，只要電腦有安裝該自行即可顯示 */
        textFont(myFont);
        fill(0);
        text("選擇就學的貓咪",x-2,y-2);  
        text("選擇就學的貓咪",x+2,y-2);  
        text("選擇就學的貓咪",x-2,y+2);  
        text("選擇就學的貓咪",x+2,y+2);  
        fill(255);
        text("選擇就學的貓咪",x,y);  
    }
    void option(){
        imageMode(CENTER);
        image(milk , width/4 ,  height/2 , 250, 200);
        image(pipi , width/4*2 ,  height/2 , 200, 200);
        image(mi , width/4*3 ,  height/2 , 250, 200);
        Arrays.stream(button).forEach(bb -> bb.render());
        for(int i=0;i<button.length;i++){
            if(button[i].isPressed()){
                choose_cat=button[i].getbuttonContent();
                chosebut = "主畫面";
                PageComplete = true;
                break;
            }
        }
    }
    
    String getCat(){
        return choose_cat;
    } 
}
