class ChoosePage extends page{
    private int bwidth = 300;
    private int bheigh = bwidth / 16 * 5;
    private String butt_str[] = {"大一" ,"大二","大三","大肆","研究所"};
    private final String rebutt_hovered_imgPath = "pic/button/Return_Hovered.png";
    private final String rebutt_pressed_imgPath = "pic/button/Return_Pressed.png";
    
    private PFont myFont;
    private PImage backgroundImage;
    private Button[] button = new Button[5];
    private Button return_button;
    
    ChoosePage(String catname,int level) {
        super("選擇學期",catname);
        backgroundImage = loadImage("pic/page/"+catname+"/choose.jpg");
        button[0] = new Button(width / 6 , 500,bwidth,bheigh,butt_str[0]);
        button[1] = new Button(width / 6 * 2 , 600,bwidth,bheigh,butt_str[1]);
        button[2] = new Button(width / 6 * 3 , 500,bwidth,bheigh,butt_str[2]);
        button[3] = new Button(width / 6 * 4 , 600,bwidth,bheigh,butt_str[3]);
        button[4] = new Button(width / 6 * 5 , 500,bwidth,bheigh,butt_str[4]);
        for(int i=0;i<button.length ;i++){
            if((level-1)<i){
                button[i].setEnable(false);
            }
        }
        return_button = new Button(70,70,100,100," ");
        return_button.setImage(rebutt_hovered_imgPath,rebutt_pressed_imgPath);
    }
    void render() {
        imageMode(CORNER);
        image(backgroundImage , 0 , 0,width,height);
        title(width / 2 , height / 2 - 300);
        option();        
    }
    void title(int x,int y) {
        fill(0,0,0,150);
        rectMode(CENTER);
        rect(x, y, 450, 100,10);
        textAlign(CENTER,CENTER);
        myFont = createFont("標楷體",80);/* 直接輸入字型名稱，只要電腦有安裝該自行即可顯示 */
        textFont(myFont);
        fill(0);
        text("選擇學期",x-2,y-2);  
        text("選擇學期",x+2,y-2);  
        text("選擇學期",x-2,y+2);  
        text("選擇學期",x+2,y+2);  
        fill(255);
        text("選擇學期",x,y);  
    }
    void option(){
        Arrays.stream(button).forEach(bb -> bb.render());
        return_button.render();
        for(int i=0;i<button.length;i++){
            if(button[i].isPressed()){
                chosebut=button[i].getbuttonContent();
                PageComplete = true;
                break;
            }
        }
        if(return_button.isPressed()){
            chosebut="主畫面";
            PageComplete = true;
        }
    }
}
