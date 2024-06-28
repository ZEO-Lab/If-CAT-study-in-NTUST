class Button{
    private PVector Pos = new PVector(0,0);
    private PImage pressedImg = loadImage("pic/button/Pressed.png");
    private PImage  hoverImg = loadImage("pic/button/Hover.png");
    private PFont myFont;
    
    private float w = 0.0 , h = 0.0;
    private float LeftSide ,RightSide , TopSide , BottomSide;
    private String str;
    private String content;
    private float strSizes;
    
    private boolean Pressed = false;
    private boolean Enable = true;
    
    Button(int x,int y,int _w,int _h,String str) {
        Pos.x = x;
        Pos.y = y;
        w = _w;
        h = _h;
        this.str = str;
        content = str;
        strSizes = h - 30;
        LeftSide = Pos.x - w / 2;
        RightSide = Pos.x + w / 2;
        TopSide = Pos.y - h / 2;
        BottomSide = Pos.y + h / 2;
    }
    void setContent(String content) {
        this.content = content;
    }
    void setImage(String hoverimgPath , String pressedimgPath) {
        hoverImg = loadImage(hoverimgPath);
        pressedImg = loadImage(pressedimgPath);
    }
    void render() {
        update();
        myFont = createFont("標楷體",strSizes);/* 直接輸入字型名稱，只要電腦有安裝該自行即可顯示 */
        textFont(myFont);
        imageMode(CENTER);
        if (Enable) {
            image( (Pressed) ? pressedImg : hoverImg,Pos.x,Pos.y,w,h);
        }
        else{ 
            image(pressedImg,Pos.x,Pos.y,w,h);
        }
        fill(0); 
        // textSize(strSizes);
        textAlign(CENTER,CENTER);
        text(str,Pos.x ,Pos.y);
    }
    void update() {
        if (Enable) {
            Pressed = (mousePressed && mouseButton == LEFT 
            && mouseX >= LeftSide && mouseX <= RightSide && mouseY >= TopSide && mouseY <= BottomSide) ? 
            true : false;  
        }
            else{
            Pressed = false;
        }   
    }
    void setEnable(boolean state) {
        Enable = state;
    }
    boolean isPressed() {
        return Pressed;
    }
    String getbuttonString() {
        return str;
    }
    String getbuttonContent() {
        return content;
    }
        
}
        
