class Enemy extends Character{
    public float bullet_time = 0;
    public float bullet_cd = 1000;
    public boolean isDistroy = false;
    public String imagePath = "pic/character/enemy/error.png";
    
    private PVector affect;
    public PImage error ;
    Enemy(RectObject object) {
        super(object,100);
        error = loadImage(imagePath);
        setShaking(false);
    }
    Enemy(RectObject object,float life_value, String enemyName) {
        super(object,life_value);
        imagePath = "pic/character/enemy/"+enemyName+".png";
        error = loadImage(imagePath);
        setShaking(false);
    }
    Enemy(RectObject object , String enemyName) {
        super(object,100);
        imagePath = "pic/character/enemy/"+enemyName+".png";
        error = loadImage(imagePath);
        setShaking(false);
    }
    
    void render(GameMap gmap) {
        imageMode(CENTER);
        setMovingSpeed(5);
        gmap.drawImage(error,x,y,w,h);
        hp.render(gmap.getWindowX(x) , gmap.getWindowY(y - h / 2 - 5));
    }
    void move(Player player) {
        distance = distance(player.getX() , player.getY() , getX() , getY());
        if (distance > player.getWidth() / 2 + 50) {
            angle = rotation(player.getX() , player.getY());
            x += cos(angle) * getMovingSpeed();
            y += sin(angle) * getMovingSpeed();
        }
    }
    void shooting(GameMap gmap , Player player) {
        if (millis() > bullet_time + bullet_cd && distance<600) {
            bullet_time = millis();
            bulletlist.add(new Bullet(new RectObject(x,y,50,50) , angle,imagePath));
        }
        for (Bullet bullet : bulletlist) {
            bullet.setSpeed(10);
        }
        bullet_program(gmap);
        bullet_shootCharater(player , 10);
    }
    void bullet_shootCharater(Player player,float bullet_damage) {
        for (Bullet bb : bulletlist) {
            float radians =  distance(player.getX(),player.getY(),bb.getX(),bb.getY());
            if (radians < (player.getWidth() / 2)) {
                player.isHurt(bullet_damage);
                if(affect != null ){
                    player.setAffect((int)affect.x, (int)( millis() + affect.y));
                }
                bb.isDistroy = true;
            } 
        }
        bullet_Remove(bulletlist);
    }
    public void setAffect(int type , int time){
        affect = new PVector(type , time );
    }
}
