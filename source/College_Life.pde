abstract class College_Life extends page{
    public int state = 0 , pre_state;
    // public float score_point = 0;
    
    public int warning_time = 0;
    public int enemy_number;
    public int enemy_generate_times = 0;
    public int enemy_dead_number = 0;
    public String[] button_1_str = { "繼續" , "重新開始" , "主畫面" };
    public String[] button_2_str = { "重新開始" , "主畫面" };
    public String[] button_3_str = { "下一關" , "重新開始" , "主畫面" };
    public boolean CallMenu = false;
    public boolean pressed = false;
    
    public Boss boss;
    public Player player;
    public ArrayList<Enemy> enemylist = new ArrayList<Enemy>();
    public Recovering_Hp recovering;
    public Small_Map smap = new Small_Map(new RectObject(width - 200 - 50 , 50 , 200 , 150) , gmap);
    public Small_Window pause_page  , win_page , fail_page;
    
    HashMap<String,Integer> hm = new HashMap<String,Integer>();
    {
        hm.put("大一",1);
        hm.put("大二",2);
        hm.put("大三",3);
        hm.put("大四",4);
        hm.put("研究所",5);
    }
    HashMap<String,String> next_page = new HashMap<String,String>();
    {
        next_page.put("大一","大二");
        next_page.put("大二","大三");
        next_page.put("大三","大四");
        next_page.put("大四","研究所");
        next_page.put("研究所","畢業");
    }
    
    College_Life(String pagename,String catname ,int enemy_number) {
        super(pagename,catname,"pic/page/map.png");
        this.enemy_number = enemy_number;
        Level = hm.get(pagename);
        
        player = new Player(catname,gmap);
        pause_page = new Small_Window("暫停",button_1_str);
        fail_page = new Small_Window(false , "當掉",button_2_str);
        win_page = new Small_Window(true ,"歐趴",button_3_str);
        recovering = new Recovering_Hp(30);
        
        pause_page.setBackGroundImage("pic/page/" + catname + "/pause.png");
        win_page.setBackGroundImage("pic/page/" + catname + "/win (" + Level + ").jpg");
        fail_page.setBackGroundImage("pic/page/" + catname + "/lose.png");
        
    }
    abstract void enemy_state_render();
    
    public void render() {
        background(255);
        gmap.drawBackGroundImage();
        if (player.isComplete()) {  
            state = 4;
        }
        switch(state) {
            case 0 : //enemy
                enemy_state_render();  
                if (enemy_dead_number == enemy_number) {
                    state = 1;
                    warning_time = millis();
                }
                break;	
            case 1 : //cutscene
                imageMode(CENTER);
                image(warning,width / 2,height / 2,width,300);
                state = (millis() > warning_time + 3000) ? 2 : 1;
                break;
            case 2 : //boss
                boss_Render();
                player_Render();
                player.bullet_shootCharater(boss ,10);
                player.laser_shootCharater(boss,10);
                state = (boss.isComplete()) ? 5 : 2; 
                break;	
            case 3 : //pause
                pause_page.render();
                break;	
            case 4 : //failed
                fail_page.render();
                fail_page.gpa(player.hp.getLifePercentage());
                break;
            case 5 : //win
                win_page.render();
                win_page.gpa(player.hp.getLifePercentage());
                break;
        }
        smap.render();
        option();
    }
    public void move(int moveInstr) {
        int menu = (moveInstr>>6) & 1;
        CallMenu = (menu == 1) ? true : false; 
        gmap.move(moveInstr , player);
        player.update(moveInstr);
        player.move(gmap);
    }
    void option() {
        switch(state) {
            case 0 :      
                pre_state = 0;  
                callPausePage(3);
                break;	
            case 2:
                pre_state = 2;  
                callPausePage(3);
                break;	
            case 3 :
                if (pause_page.isComplete()) {
                    switch(pause_page.theChoseButton()) {
                        case "繼續" :
                        state = pre_state;
                        break;	
                    case "重新開始" :  
                        PageComplete = true;
                        break;	
                    case "主畫面":
                        chosebut = "主畫面";
                        PageComplete = true;
                        break;
                }
            }
            callPausePage(pre_state);
            break;	
            case 4:
                if (fail_page.isComplete()) {
                    PageComplete = true;
                    if (fail_page.theChoseButton() == "主畫面") {
                        chosebut = "主畫面";
                    }
                }
                break;
            case 5:
                LevelComplete = true;
                if (win_page.isComplete()) {
                    PageComplete = true;
                    switch(win_page.theChoseButton()) {
                        case "下一關":
                        chosebut = next_page.get(chosebut);
                        break;
                    case "主畫面":
                        chosebut = "主畫面";
                        break;
                }
            }
            break; 
        }
    }
    private void callPausePage(int next_state) {
        if (CallMenu && !pressed) {  
            pause_page.reset();
            pressed = true;  
            state = next_state;
        }
        else if (!CallMenu) {
            pressed = false;
        }
    }
    public void player_Render() {
        if (player.hp.isGone()) {
            if (player.crack(gmap)) {
                player.setComplete(true);
            }
        }
        else{
            player.render(gmap);
            player.shooting(gmap);
        }
        recovering.render(gmap,smap);
        recovering.remove(player);
        smap.small_chararcter_Render(player,0);
    } 
    
    void enemy_Generation(ArrayList<Enemy> _enemylist) {
        float distance = 0;
        float xpos = 0 , ypos = 0;
        while(distance < width / 2) {
            xpos = random(gmap.getWidth());
            ypos = random(gmap.getHeigh()); 
            float t_xpos = gmap.getX() + xpos;
            float t_ypos = gmap.getY() + ypos;
            distance = sqrt(pow((t_xpos - player.getX()),2) + pow((t_ypos - player.getY()),2));
        }
        _enemylist.add(new Enemy(new RectObject(xpos , ypos ,100,100)));    
        enemy_generate_times ++;
    }
    
    void enemy_Render(ArrayList<Enemy> _enemylist) {
        for (Enemy enemy : _enemylist) {
            if (enemy.hp.isGone()) {
                if (enemy.crack(gmap)) {
                    enemy.isDistroy = true;
                }
            }
            else{
                enemy.render(gmap);
                enemy.move(player);
                enemy.shooting(gmap , player);
            }
            smap.small_chararcter_Render(enemy,color(255,30,30));
        }
        enemy_Remove(_enemylist);
    }
    void enemy_Remove(ArrayList<Enemy> _enemylist) {
        for (int i = _enemylist.size() - 1; i>= 0; i -= 1) {
            Enemy enemy = _enemylist.get(i);           
            if (enemy.isDistroy ==  true) {
                enemy_dead_number++;
                recovering.generation(enemy);
                _enemylist.remove(enemy);
            }
        }
    }
    public void boss_Render() {
        if (boss.hp.isGone()) {
            if (boss.crack(gmap)) {
                boss.setComplete(true);
            }
        }
        else{
            boss.render(gmap);
            boss.move(player);
            boss.shooting(gmap ,player);
        }
        smap.small_chararcter_Render(boss,color(255,30,30));
    }
    
    // float getLevelPoint() {
    //     return score_point;
// }
    
    private class Recovering_Hp {
        private float recover_value = 10;
        private ArrayList<PVector> coordiante = new ArrayList<PVector>();  
        public Recovering_Hp(float value) {
            recover_value = value;
        }
        void generation(Enemy enemy) {
            coordiante.add(new PVector(enemy.getX(),enemy.getY()));
        }
        void render(GameMap gmap,Small_Map smap) {
            for (PVector Location : coordiante) {
                float x = gmap.getWindowX(Location.x);
                float y = gmap.getWindowY(Location.y);
                noStroke();
                fill(255,0,0);
                beginShape();
                vertex(x - 20, y);
                bezierVertex(x - 20, y - 10, x + 20, y - 5, x - 20, y + 30);
                vertex(x - 20, y);
                bezierVertex(x - 20, y - 10, x - 60, y - 5, x - 20, y + 30);
                endShape();
                smap.small_object_Render(Location.x , Location.y , color(255));
            }
        }
        void remove(Player player) {
            for (int i = coordiante.size() - 1; i>= 0; i -= 1) {
                PVector Location = coordiante.get(i);  
                if (player.distance(player.getX() , player.getY() ,Location.x,Location.y) < 50) {
                    coordiante.remove(Location);
                    player.healing(recover_value);
                }
            } 
        }
        
    }
    
    private class Small_Map{
        private float x,y,w,h;
        private float bigMapWidth , bigMapHeight;
        private PImage map = loadImage("pic/page/small_map.png");
        public Small_Map(RectObject object,GameMap gmap) {
            x = object.x;
            y = object.y;
            w = object.w;
            h = object.h; 
            bigMapWidth = gmap.getWidth();
            bigMapHeight = gmap.getHeigh();
        }
        public void render() {
            imageMode(CORNER);
            image(map ,x,y,w,h);
        }
        public void small_chararcter_Render(Character chararcter,color c_color) {
            float chararcter_x = translateX(chararcter.getX());
            float chararcter_y = translateY(chararcter.getY());
            stroke(0);
            strokeWeight(1);
            fill(c_color);
            ellipse(chararcter_x , chararcter_y , 10,10);
        }
        public void small_object_Render(float _x,float _y,color c_color) {
            float chararcter_x = translateX(_x);
            float chararcter_y = translateY(_y);
            stroke(0);
            strokeWeight(1);
            fill(c_color);
            triangle(chararcter_x, chararcter_y, chararcter_x + 10, chararcter_y + 10, chararcter_x - 10, chararcter_y + 10);
        }
        private float translateX(float _x) {
            return x + w * _x / bigMapWidth;
        }
        private float translateY(float _y) {
            return y + h * _y / bigMapHeight;
        }
    }
    
    public class Small_Window extends page{
        
        private String title_str;
        private final String butt_hovered_imgPath = "pic/button/Hover.png";
        private final String butt_pressed_imgPath = "pic/button/Pressed.png";
        
        private PFont myFont = createFont("標楷體",80);;
        private PImage backgroundImg;
        private Button[] button;
        
        Small_Window(String page,String[] button_str) {
            super(page);
            title_str = page;
            setButtonString(button_str);
        }
        Small_Window(boolean state , String page , String[] button_str) {
            super(page);
            title_str = page;
            setButtonString(button_str);
        }
        void setBackGroundImage(String imgPath) {
            backgroundImg = loadImage(imgPath);
        }
        void setButtonString(String[] button_str) {
            button = new Button[button_str.length];
            for (int i = 0;i < button_str.length;i++) {
                button[i] = new Button(width / 2 , height / 2 + 50 + 90 * i , 200 , 70 , button_str[i]);
                button[i].setImage(butt_hovered_imgPath , butt_pressed_imgPath);
            }
        }
        void reset() {
            chosebut = title_str;
        }
        void render() {
            rectMode(CORNER);
            fill(0,200);
            rect(0,0,width , height);
            imageMode(CENTER);
            image(backgroundImg , width / 2 ,height / 2 , 450,600);
            title(width / 2  , height / 2 - 250);
            option();
        }
        void title(int _x,int _y) {
            textAlign(CENTER,CENTER);
            textFont(myFont);
            fill(0);
            text(title_str,_x - 2,_y - 2);  
            text(title_str,_x + 2,_y - 2);  
            text(title_str,_x - 2,_y + 2);  
            text(title_str,_x + 2,_y + 2);  
            fill(255);
            text(title_str,_x,_y);  
        }
        void gpa(float score_ratio) {
            // score_point = (4.1 * score_ratio);
            String score = "D-";
            if (score_ratio > 0.9) {
                score = "A+";
            }
            else if (score_ratio > 0.85) {
                score = "A";
            }
            else if (score_ratio > 0.8) {
                score = "A-";
            }
            else if (score_ratio > 0.77) {
                score = "B+";
            }
            else if (score_ratio > 0.75) {
                score = "B";
            }
            else if (score_ratio > 0.7) {
                score = "B-";
            }
            else if (score_ratio > 0.6) {
                score = "C+";
            }
            else if (score_ratio > 0.5) {
                score = "C";
            }
            else if (score_ratio > 0.4) {
                score = "C-";
            }
            stroke(0);
            strokeWeight(2);
            fill(255,200);
            rectMode(CENTER);
            rect(width / 2  , height / 2 - 100 , 150,150,10);
            fill(0);
            textAlign(CENTER,CENTER);
            textSize(100);
            text(score,width / 2  , height / 2 - 100);
        }
        void option() {
            Arrays.stream(button).forEach(bb -> bb.render());
            for (int i = 0;i < button.length;i++) {
                if (button[i].isPressed()) {
                    chosebut = button[i].getbuttonContent();
                    PageComplete = true;
                    break;
                }
            }
        }
    }
}
