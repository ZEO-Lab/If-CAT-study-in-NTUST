public class College_Junior extends College_Life{
    
    public ArrayList<Enemy> enemylist2 = new ArrayList<Enemy>();
    
    public College_Junior(String catname) {
        super("大三",catname,10);
        boss = new Boss_Project(gmap,1000);
    }
    public College_Junior(String levelname,String catname,int enemyNumber) {
        super(levelname,catname,enemyNumber);
    }
    public void enemy_state_render() {
        if (enemy_generate_times < enemy_number) {
            enemy_Generation(enemylist);
            enemy2_Generation();
        }
        enemy_Render(enemylist);
        enemy_Render(enemylist2);
        player_Render();
        for (Enemy enemy : enemylist) {
            player.bullet_shootCharater(enemy ,15);
            player.laser_shootCharater(enemy,15);
        }
        
        for (Enemy enemy2 : enemylist2) {
            player.bullet_shootCharater(enemy2 ,15);
            player.laser_shootCharater(enemy2,15);
        }
    }

    void enemy2_Generation() {
        float distance = 0;
        float xpos = 0 , ypos = 0;
        while(distance < width / 2) {
            xpos = random(gmap.getWidth());
            ypos = random(gmap.getHeigh()); 
            float t_xpos = gmap.getX() + xpos;
            float t_ypos = gmap.getY() + ypos;
            distance = sqrt(pow((t_xpos - player.getX()),2) + pow((t_ypos - player.getY()),2));
        }
        enemylist2.add(new Enemy(new RectObject(xpos , ypos ,100,100),"ppt"));    
        enemy_generate_times ++;
        for(Enemy enemy:enemylist2){
            enemy.setAffect(0,500);
        }
    }
}
