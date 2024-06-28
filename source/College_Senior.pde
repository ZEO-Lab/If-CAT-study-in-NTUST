public class College_Senior extends College_Junior{
    
    public College_Senior(String catname) {
        super("大四",catname,5);
        boss = new Reearch_Institution(gmap,1000);
        fail_page = new Small_Window(false , "大五",button_2_str);
        win_page = new Small_Window(true ,"入學許可",button_3_str);
        win_page.setBackGroundImage("pic/page/" + catname + "/win (" + Level + ").jpg");
        fail_page.setBackGroundImage("pic/page/" + catname + "/lose.png");
    }
    public College_Senior(String levelname,String catname,int enemyNumber) {
        super(levelname,catname,enemyNumber);
    }
    public void enemy_state_render() {
        if (enemy_generate_times < enemy_number) {
            enemy2_Generation();
        }
        enemy_Render(enemylist2);
        player_Render();
        for (Enemy enemy2 : enemylist2) {
            player.bullet_shootCharater(enemy2 ,15);
            player.laser_shootCharater(enemy2,15);
        }
    }
}
