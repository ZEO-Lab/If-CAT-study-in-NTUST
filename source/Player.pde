class Player extends Character{

    private boolean laser_mode = false;
    
    private boolean isMovingLeft = false;
    private boolean isMovingRight = false;
    private boolean isMovingUp = false;
    private boolean isMovingDoen = false;
    private boolean bb_shoot = false;
    private boolean ll_shoot = false;
    
    private PImage left_cat ,right_cat;
    private PImage left_laser_cat,right_laser_cat;
    
    private RectObject bullet_para = new RectObject(0,1000 , 0,1);
    // bullet_time , bullet_cd , none , coffecient 
    private RectObject laser_para = new RectObject(0,5000 ,1000, 1);
    // laser_time , laser_cd , laser_duration , coffecient
    
    
    private Skill_Bar skill = new Skill_Bar();
    private Laser laser = new Laser();
    private ArrayList<PVector> affectlist = new ArrayList<PVector>();
    
    Player(String catname,GameMap gmap) {
        super(new RectObject(gmap.getWidth() / 2 , gmap.getHeigh() / 2 , 100 , 100) , 200);
        setShaking(true);
        setMovingSpeed(10);
        left_cat = loadImage("pic/character/" + catname + "/left.png");
        right_cat = loadImage("pic/character/" + catname + "/right.png");
        left_laser_cat = loadImage("pic/character/" + catname + "/laser_left.png");
        right_laser_cat = loadImage("pic/character/" + catname + "/laser_right.png");
    }
    void render(GameMap gmap) {
        imageMode(CENTER);
        if (laser_mode) {
            gmap.drawImage((mouseX > gmap.getWindowX(x)) ? right_laser_cat : left_laser_cat , x , y , w , h);
            laser.render(gmap.getWindowX(x), gmap.getWindowY(y) ,(mouseX < gmap.getWindowX(x)));
        }
        else{
            gmap.drawImage((mouseX > gmap.getWindowX(x)) ? right_cat : left_cat , x , y , w , h);
        }
        skill.render();
        for (PVector affect : affectlist) {
            switch(int(affect.x)) {
                case 0:
                    fill(200,0,0,100);
                    gmap.fillellipse(x,y,w,h);
                    break;
                case 1:
                    fill(0,200,0,100);
                    gmap.fillellipse(x,y,w,h);
                    break;
                case 2:
                    fill(0,0,200,100);
                    gmap.fillellipse(x,y,w,h);
                    break;
            }
        }
    }
    void update(int keys) {
        isMovingLeft = ((keys & 1) == 1) ? true : false;
        isMovingRight = (((keys>>1) & 1) == 1) ? true : false;
        isMovingUp = (((keys>>2) & 1) == 1) ? true : false;
        isMovingDoen = (((keys>>3) & 1) == 1) ? true : false;
        bb_shoot = (((keys >> 4) & 1) == 1) ? true : false;
        ll_shoot = (((keys >> 5) & 1) == 1) ? true : false;     
        removeAffect();
    }
    void move(GameMap gmap) {       
        if (isMovingLeft && gmap.getWindowX(x) >= w / 2) {
            x -= getMovingSpeed();
        }
        if (isMovingRight &&  gmap.getWindowX(x) <= width - w / 2) {
            x += getMovingSpeed();
        }
        if (isMovingUp &&  gmap.getWindowY(y) >= h / 2) {
            y -= getMovingSpeed();
        }
        if (isMovingDoen &&  gmap.getWindowY(y) <= height - h / 2) {
            y += getMovingSpeed();
        }
    }
    
    void shooting(GameMap gmap) {
        angle = rotation(mouseX - gmap.getX() ,mouseY - gmap.getY());
        if (bb_shoot && millis() > bullet_para.x + bullet_para.y * bullet_para.h) {
            bullet_para.x = millis();
            bulletlist.add(new Bullet(new RectObject(x,y,50,50) , angle,"pic/google.png"));
        }
        for (Bullet bullet : bulletlist) {
            bullet.setSpeed(30);
        }
        bullet_program(gmap);
        if (ll_shoot && millis() > laser_para.x + laser_para.y*laser_para.h && !laser_mode) {
            laser_para.x = millis();
            laser.reset();
            laser_mode = true;
        }
        else if (laser_mode && millis() > laser_para.x + laser_para.w) {
            laser_para.x = millis();
            laser_mode = false;
        }
    }
    
    public void laser_shootCharater(Character enemy,float laser_damage) {
        if (laser_mode) {
            float dis = distance(enemy.getX() , enemy.getY() , x  ,y);
            float enemy_angle = rotation(enemy.getX() , enemy.getY());
            float vertical_line = dis * sin(laser.getAngle() - enemy_angle);
            if (laser.isShooting() && dis < 350 && abs(laser.getAngle() - enemy_angle) < 1 /*&& vertical_line<enemy.getWidth() / 2*/) {
                enemy.isHurt(laser_damage);
            }
        }
    }
    
    void setAffect(int type ,int time) {
        switch(type) {
            case 0 :
                affectlist.add(new PVector(type,time));
                moving.y = moving.y / 2;
                break;	
            case 1:
                affectlist.add(new PVector(type,time));
                bullet_para.h = bullet_para.h * 2;
                break;
            case 2:
                affectlist.add(new PVector(type,time));
                laser_para.h = laser_para.h * 1.5;
                break;
        }
    }
    void removeAffect() {
        for (int i = affectlist.size() - 1; i>= 0; i -= 1) {
            PVector affect = affectlist.get(i);           
            if (affect.y <=  millis()) {
                switch(int(affect.x)) {
                    case 0 :
                        moving.y = 1;
                        break;	
                    case 1 :
                        bullet_para.h = 1;
                        break;	
                    case 2 :
                        laser_para.h  = 1;
                        break;	
                }
                affectlist.remove(affect);
            }
        }
    }
    
    void healing(float value) {
        hp.heal(value);
    }
    
    private class Laser{
        private int circle_width = 0;
        private int laser_beam_width = 25;
        private int laser_beam_length = 350;
        
        private int laser_state = 0;
        private float laser_angle = 0;
        private boolean Shooting = false;
        private boolean Complete = false;
        
        public void render(float x,float y,boolean left) {
            switch(laser_state) {
                case 0:
                    Complete = false;
                    Shooting = false;
                    fill(0,255,0);
                    if (circle_width % 10 > 0) {
                    }
                    else{
                        fill(255,255,255);
                    }
                    circle_width += 5;
                    ellipse(((left) ? x - 30 : x + 30),y + 50,circle_width,circle_width);
                    laser_state = (circle_width>= 50) ? 1 : 0;
                    break;
                case 1:
                    Shooting = true;
                    rectMode(CORNER);
                    noStroke();
                    fill(0,255,0);
                    laser_angle = atan2(mouseY - y, mouseX - x);
                    pushMatrix();
                    translate(x  ,y);
                    rotate(laser_angle);
                    ellipse(60,0,circle_width * 0.5,circle_width);
                    rect(60, -laser_beam_width / 2,laser_beam_length,laser_beam_width);
                    fill(255);
                    float ratio = random(0.6, 0.8);
                    ellipse(60,0,circle_width * 0.5 * ratio,circle_width * ratio);
                    rect(60, -(laser_beam_width * ratio) / 2,laser_beam_length,laser_beam_width * ratio);
                    popMatrix();
                    break;
            }
        }
        public void reset() {
            laser_state = 0;
            circle_width = 0;
            Complete = true;
        }
        public float getAngle() {
            return laser_angle;
        }
        public boolean isShooting() {
            return Shooting;
        }
        // public boolean isComplete() {
        //     return Complete;
    // }
    }
    
    private class Skill_Bar{
        private float ratio;
        private int row_width = 150 ,row_height = 20;
        private PImage life_icon , bullet_icon , laser_icon;
        
        Skill_Bar() {
            life_icon = loadImage("pic/skill_icon/heart.png");
            bullet_icon = loadImage("pic/skill_icon/google_icon.png");
            laser_icon = loadImage("pic/skill_icon/ChatGPT-Logo.png");
        }
        private void render() {
            rectMode(CORNER);
            stroke(0);
            strokeWeight(1);
            fill(255);
            rect(20,20,250,150,10);
            
            imageMode(CORNER);
            image(life_icon,50,45,30,30);
            image(bullet_icon,50,80,30,30);
            image(laser_icon,50,120,30,30);
            
            strokeWeight(2);
            fill(255);
            rect(100,50,row_width,row_height,5);
            rect(100,90,row_width * 0.8,row_height,5);
            rect(100,130,row_width * 0.8,row_height,5);
            
            fill(255,0,0);
            rect(100,50,row_width * hp.getLifePercentage() ,row_height,5);
            
            ratio = (millis() - bullet_para.x) / bullet_para.y;
            fill((ratio >= 1) ? color(0,200,0) : 0);
            rect(100,90,row_width * 0.8 * ((ratio >= 1) ? 1 : ratio) ,row_height,5);
            
            if (laser_mode) {
                fill(color(255,255,0));
                ratio = (laser_para.x + laser_para.w - millis()) / laser_para.w;
            }
            else{
                ratio = (millis() - laser_para.x) / laser_para.y;
                fill((ratio >= 1) ? color(255,255,0) : 0);
            }
            rect(100,130,row_width * 0.8 * ((ratio >= 1) ? 1 : ratio) ,row_height,5);
        }
    }
}
