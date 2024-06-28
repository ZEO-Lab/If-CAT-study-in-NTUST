/*
class UpgradePage extends page{
    private float totalscore;
    private float lastscore;
    private float spendscore;

    private PImage backgroundImage;
    private Button[] button = new Button[5];
    private Button return_button;
    UpgradePage(String catname){
        super("升級");
        backgroundImage = loadImage("pic/page/"+catname+"/choose.jpg");
        return_button = new Button(70,70,100,100," ");
        return_button.setImage(rebutt_hovered_imgPath,rebutt_pressed_imgPath);
    
    }
    void setScore(float score){
        totalscore = score ;
        lastscore = totalscore-spendscore ;
    }
    void render(){

    }
    void option(){
        if(return_button.isPressed()){
            chosebut="主畫面";
            PageComplete = true;
        }
    }
}
*/
