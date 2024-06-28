public class College_Graduate extends College_Senior{
    public String[] button_3_str = {"主畫面" };
    private int boss_width = 0 ;

    PImage ntust = loadImage("pic/character/enemy/ntust.png");
    public ArrayList<Enemy> enemylist3 = new ArrayList<Enemy>();
    
    public College_Graduate(String catname) {
        super("研究所",catname,5);
        boss = new Professor(gmap,1200);
        fail_page = new Small_Window(false , "當兵",button_2_str);
        win_page = new Small_Window(true ,"畢業證書",button_3_str);
        win_page.setBackGroundImage("pic/page/" + catname + "/win (" + Level + ").jpg");
        fail_page.setBackGroundImage("pic/page/" + catname + "/lose.png");
        
    }
    public College_Graduate(String levelname,String catname,int enemyNumber) {
        super(levelname,catname,enemyNumber);
    }
    public void enemy_state_render() {
        if (enemy_generate_times < enemy_number) {
            enemy3_Generation();
        }
        enemy_Render(enemylist3);
        for (Enemy enemy3 : enemylist3) {
            player.bullet_shootCharater(enemy3 ,15);
            player.laser_shootCharater(enemy3,15);
        }
    }
    public void render() {
        background(255);
        gmap.drawBackGroundImage();
        smap.render();
        if (player.isComplete()) {  
            state = 4;
        }
        player_Render();
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
                gmap.drawImage(ntust,gmap.getWidth() / 2 , gmap.getHeigh()/2,boss_width,boss_width);
                boss_width += 5;
                state = (boss_width >= 200 ) ? 2 : 1; 
                break;
            case 2 : //boss
                boss_Render();
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
        option();
    }
    
    void enemy3_Generation() {
        float distance = 0;
        float xpos = 0 , ypos = 0;
        while(distance < width / 2) {
            xpos = random(gmap.getWidth());
            ypos = random(gmap.getHeigh()); 
            float t_xpos = gmap.getX() + xpos;
            float t_ypos = gmap.getY() + ypos;
            distance = sqrt(pow((t_xpos - player.getX()),2) + pow((t_ypos - player.getY()),2));
        }
        enemylist3.add(new Enemy(new RectObject(xpos , ypos ,100,100),300,"paper"));    
        enemy_generate_times ++;
        for (Enemy enemy : enemylist3) {
            enemy.setAffect(1,2000);
        }
    }
}
