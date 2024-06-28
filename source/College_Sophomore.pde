public class College_Sophomore extends College_Freshman{
    
    public College_Sophomore(String catname) {
        super("大二",catname,10);
        boss = new Boss_double(gmap,1000);
    }
    public void enemy_state_render() {
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
