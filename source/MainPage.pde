class MainPage extends page{
    private int w,h;
    private int bwidth = 300;
    private int bheigh = bwidth / 16 * 5;
    private HashMap<String,String> hm = new HashMap<String,String>();
    {
        hm.put("milk" , "牛奶");
        hm.put("pipi" , "皮皮");
        hm.put("mi" , "小咪");
    }
    private PFont myFont;
    private PImage backgroundImage ;
    private Button[] button = new Button[3];
    
    MainPage(String catname) {
        super("主畫面",catname);
        w = width;
        h = height;
        button[0] = new Button(w / 2 ,h / 2,bwidth,bheigh,"大一");
        button[1] = new Button(w / 2 ,h / 2 + bheigh + 50,bwidth,bheigh,"選擇關卡");
        button[2] = new Button(w / 2 ,h / 2 +2* bheigh + 2*50,bwidth,bheigh,"退出");
        backgroundImage = loadImage("pic/page/"+cat+"/main.jpg");
    } 
    void render() {
        imageMode(CORNER);
        image(backgroundImage , 0 , 0,width,height);
        title(w / 2,h / 2 - 200);
        option();
    } 
    void title(int x,int y) {
        textAlign(CENTER);
        myFont = createFont("標楷體",80);/* 直接輸入字型名稱，只要電腦有安裝該自行即可顯示 */
        textFont(myFont);
        fill(0);
        text("If "+hm.get(cat)+" study in NTUST",x-2,y-2);  
        text("If "+hm.get(cat)+" study in NTUST",x+2,y-2);  
        text("If "+hm.get(cat)+" study in NTUST",x-2,y+2);  
        text("If "+hm.get(cat)+" study in NTUST",x+2,y+2);  
        fill(255);
        text("If "+hm.get(cat)+" study in NTUST",x,y);  
    }
    void option(){
        Arrays.stream(button).forEach(bb -> bb.render());
        for(int i=0;i<button.length;i++){
            if(button[i].isPressed()){
                chosebut=button[i].getbuttonContent();
                PageComplete = true;
                break;
            }
        }
    }       
}
