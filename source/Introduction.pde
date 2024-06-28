public class Introduction extends page{
    private int state = 0;
    private boolean pressed = false;
    
    
    private PFont myFont;
    private Button next_img = new Button(width / 2 , 600 , 200, 200 / 16 * 5 , "下一頁");
    private Button complete = new Button(width / 2 , 600 , 200, 200 / 16 * 5 , "開始遊玩！");
    private PImage intro_image1 = loadImage("pic/intro/intro1.jpg");
    private PImage intro_image2 = loadImage("pic/intro/intro2.jpg");
    private PImage intro_image3 = loadImage("pic/intro/intro3.jpg");
    private PImage intro_image4 = loadImage("pic/intro/intro4.jpg");
    private PImage intro_image5 = loadImage("pic/intro/intro5.jpg");
    private PImage intro_image6 = loadImage("pic/intro/intro6.jpg");
    
    void render() {
        float Line1 = height / 2 - 100;
        float Line2 = height / 2 + 170;
        myFont = createFont("標楷體",50);
        textFont(myFont);
        fill(0,200);
        rectMode(CORNER);
        rect(0,0,width,height);
        if (state != 5) {
            next_img.render();
        }
        else{
            complete.render();
        }
        imageMode(CENTER);
        textAlign(CENTER,CENTER);
        fill(255);
        switch(state) {
            case 0 :
                image(intro_image1 , width / 2 , Line1 , 500,400);
                text("玩家需要操控視窗的貓咪\n通過每個學期的各種挑戰",  width / 2, Line2); 
                break;	
            case 1 :
                image(intro_image2 , width / 2 , Line1 , 500,400);
                text("透過WASD能操控貓咪移動\n躲避敵人的攻擊\nESC能暫停遊戲",  width / 2, Line2); 
                break;	
            case 2 :
                image(intro_image3 , width / 2 , Line1 , 500,400);
                text("有些敵人的攻擊會附帶特殊效果\n請小心閃避",  width / 2, Line2); 
                break;	
            case 3 :
                image(intro_image4 , width / 2 , Line1 , 500,400);
                text("滑鼠左鍵能夠發射子彈",  width / 2, Line2); 
                break;	
            case 4 :
                image(intro_image5 , width / 2 , Line1 , 500,400);
                text("滑鼠右鍵能夠射出雷射",  width / 2, Line2); 
                break;	
            case 5 :
                image(intro_image6 , width / 2 , Line1 , 500,400);
                text("擊敗最終BOSS通過每個學期吧!",  width / 2, Line2); 
                break;	
        }
        option();
    }
    void option() {
        switch(state) {
            case 5 :        
                if (complete.isPressed()) {
                    if (!pressed) {
                        PageComplete = true;
                    }
                }
                else{
                    pressed = false;
                }
                break;	
            default:
                if (next_img.isPressed()) {
                    if (!pressed) {
                        state++;
                        pressed = true;
                    }
                }
                else{
                    pressed = false;
                }
                break;
        }
    }
}
