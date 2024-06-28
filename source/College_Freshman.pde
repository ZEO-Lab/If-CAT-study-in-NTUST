public class College_Freshman extends College_Life{
    private Introduction intro_page = new Introduction();
    public College_Freshman(String levelname,String catname,int enemyNumber) {
        super(levelname,catname,enemyNumber);
    }
    public College_Freshman(String catname) {
        super("大一",catname,5);
        boss = new Boss(gmap,600);
    }
    public void enemy_state_render() {
        if(!intro_page.isComplete()){
            intro_page.render();
        }
        else{
            if (enemy_generate_times < enemy_number) {
                enemy_Generation(enemylist);
            }
            enemy_Render(enemylist);
            player_Render();
            for (Enemy enemy : enemylist) {
                player.bullet_shootCharater(enemy ,10);
                player.laser_shootCharater(enemy,10);
            }
        }
    }
}
