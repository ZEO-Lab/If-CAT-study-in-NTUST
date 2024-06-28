class Boss extends Character{
    public float move_angle = 0;
    public float bullet_time_1 = 0;
    public float bullet_level1_count = 0;
    public float bullet_level1_time = 0;
    public float bullet_level1_cd = 500;
    public int bullet_level1_damage = 10;
    
    public float bullet_cd = 1500;
    
    public PImage boss = loadImage("pic/character/enemy/exam.png");
    public Boss_HP boss_hp = new  Boss_HP();
    
    Boss(GameMap gmap,int life_value) {
        super(new RectObject(gmap.getWidth() / 2 , gmap.getHeigh() / 2 , 200 , 200) , life_value);
        setMovingSpeed(1);
    }
    void render(GameMap gmap) {
        imageMode(CENTER);
        gmap.drawImage(boss ,x ,y, w, h);
        boss_hp.render();
    }
    void move(Player player) {
        move_angle =rotation(player.getX(),player.getY()); 
        x += cos(move_angle) * getMovingSpeed();
        y += sin(move_angle) * getMovingSpeed();
    }
    
    void shooting(GameMap gmap ,Player player) {
        level_1(player,3);
        bullet_shootCharater(player , bullet_level1_damage);
        bullet_program(gmap);
    }
    
    void level_1(Player player,int counts) {
        if (millis() > bullet_time_1 + bullet_cd && distance<600) {
            if (bullet_level1_count < counts) {
                if (millis() > bullet_level1_time + bullet_level1_cd) {
                    angle = rotation(player.getX() , player.getY());
                    for (float i = 0;i < 10;i++) {
                        bulletlist.add(new Bullet(new RectObject(x,y,30,30) , angle , color(0,255,0)));
                        angle += 2 * PI / 10;
                    }
                    for (Bullet bullet : bulletlist) {
                        bullet.setSpeed(20);
                    }
                    bullet_level1_count ++;
                    bullet_level1_time =  millis();
                }
            }
            else{
                bullet_time_1 = millis();
            }
        }
        else{
            bullet_level1_count = 0; 
        }
    }
    
    public void set_level1_Bullet_damage(int level1) {
        bullet_level1_damage = level1;
    }
    private class Boss_HP extends HP{
        Boss_HP() {
            super(hp.getLifeValue());
        }
        void render() {
            float current_life = (width - 200) * hp.getLifeValue() / hp.getOriginalLifeValue();
            rectMode(CORNER);
            stroke(0);
            strokeWeight(5);
            fill(255);
            rect(100,height - 100,(width - 200),30,3);
            fill(200,0,0);
            rect(100,height - 100,current_life,30,3);
        }
    }
}

public class Boss_double extends Boss{
    private float bullet_time_2 = 0;
    private float bullet_level2_count = 0;
    private float bullet_level2_time = 0;
    private float bullet_level2_cd = 500;
    public int bullet_level2_damage = 20;
    
    ArrayList<Bullet> bulletlist2 = new ArrayList<Bullet>();
    public Boss_double(GameMap gmap,int life_value) {
        super(gmap,life_value);
    }
    
    void shooting(GameMap gmap ,Player player) {
        level_1(player,3);
        bullet_shootCharater(player , bullet_level1_damage);
        if (hp.getLifePercentage() < 0.5) {
            level_2(player);
            bullet2_shootCharater(player , bullet_level2_damage);
        }
        bullet_program(gmap);
        bullet2_program(gmap);
    }
    
    void level_2(Player player) {
        if (millis() > bullet_time_2 + bullet_cd && distance<600) {
            if (bullet_level2_count < 5) {
                if (millis() > bullet_level2_time + bullet_level2_cd) {
                    angle = rotation(player.getX() , player.getY());
                    float dx = 50 * cos(PI / 2 - angle);
                    float dy = 50 * sin(PI / 2 - angle);
                    bulletlist2.add(new Bullet(new RectObject(x,y,30,30) , angle , color(255,255,0)));
                    bulletlist2.add(new Bullet(new RectObject(x + dx,y - dy,30,30) , angle , color(255,255,0)));
                    bulletlist2.add(new Bullet(new RectObject(x - dx,y + dy,30,30) , angle , color(255,255,0)));
                    bullet_level2_count ++;
                    bullet_level2_time =  millis();
                }
            }
            else{
                bullet_time_2 = millis();
            }
        }
        else{
            bullet_level2_count = 0; 
        }
    }
    void bullet2_program(GameMap gmap) {
        for (Bullet bullet2 : bulletlist2) {
            bullet2.move(); 
            bullet2.OutOfRange(gmap); 
            bullet2.render(gmap); 
        }
        bullet_Remove(bulletlist2);
    }
    void bullet2_shootCharater(Character c1,float bullet_damage) {
        for (Bullet bullet2 : bulletlist2) {
            float radians =  distance(c1.getX(),c1.getY(),bullet2.getX(),bullet2.getY());
            if (radians < (c1.getWidth() / 2)) {
                c1.isHurt(bullet_damage);
                bullet2.isDistroy = true;
            } 
        }
        bullet_Remove(bulletlist2);
    }
    public void set_level2_Bullet_damage(int level2) {
        bullet_level2_damage = level2;
    }
}

public class Boss_Project extends Boss_double {
    private int laser_state = 0;
    private boolean delay_mode = false;
    private boolean laser_mode = false;
    
    private int smoke_time;
    private int smoke_cd = 3000;
    
    private float laser_time = 0;
    private float laser_duration = 3000;
    private float laser_cd = 2000;
    
    PImage boos_level2 = loadImage("pic/character/enemy/boss_project2.png");
    private Project_Laser laser = new Project_Laser();
    private  Delay_Smoke delay_smoke = new Delay_Smoke();
    
    public Boss_Project(GameMap gmap,int life_value) {
        super(gmap,life_value);
        boss = loadImage("pic/character/enemy/boss_project.png");
    }
    void render(GameMap gmap) {
        imageMode(CENTER);
        gmap.drawImage(((hp.getLifePercentage() < 0.5) ? boos_level2 : boss) ,x ,y, w, h);
        boss_hp.render();
        if (hp.getLifePercentage() < 0.7) {
            delay_mode = true;
        }
        if (hp.getLifePercentage() < 0.5) {
            laser_mode = true;
        }
    }
    
    void shooting(GameMap gmap ,Player player) {
        level_2(player);
        bullet2_program(gmap);
        bullet2_shootCharater(player , bullet_level2_damage);
        
        if (delay_mode) {
            delay_smoke.render(gmap);
            delay_smoke.affectPlayer(player);
            if (millis() > smoke_time + smoke_cd) {
                smoke_time = millis();
                delay_smoke.generation(new RectObject(x,y,700,0));
            }
        }
        if (laser_mode) {
            switch(laser_state) {
                case 0 :
                    if (millis() > laser_time + laser_cd) {
                        laser_time = millis();
                        laser_state = 1;
                        laser.reset();	
                    }
                    break;
                case 1:
                    laser.render(x,y,gmap,player);
                    laser_shootCharater(player,20);
                    laser_state = (millis() > laser_time + laser_duration) ? 2 : 1;
                    break;	
                case 2 :
                    laser_time = millis();
                    laser_state = 0;
                    break;	
            }
        }
    }
    
    public void laser_shootCharater(Player player,float laser_damage) {
        float dis = distance(player.getX() , player.getY() , x  ,y);
        float player_angle = rotation(player.getX() , player.getY());
        float vertical_line = dis * sin(laser.getAngle() - player_angle);
        if (laser.isShooting() && dis < 350 && abs(laser.getAngle() - player_angle) < 1 && vertical_line<player.getWidth() / 2) {
            player.isHurt(laser_damage);
        }
    }
    private class Delay_Smoke{
        private float x,y,rad;
        ArrayList<RectObject> smokelist = new ArrayList<RectObject>();
        
        void generation(RectObject object) {
            x = object.x;
            y = object.y;
            rad = object.w / 2;
            for (float i =-  PI;i <=  PI;i += (2 * PI / 6)) {
                float _x = x + rad * cos(i);
                float _y = y + rad * sin(i);
                smokelist.add(new RectObject(_x,_y,millis() + 2000,0));
            }
        }
        void render(GameMap gmap) {
            fill(200,50,50,100);
            for (RectObject smoke : smokelist) {
                gmap.fillellipse(smoke.x,smoke.y,100,100);
            }
            removeSmoke();
        }
        void affectPlayer(Player player) {
            for (RectObject smoke : smokelist) {
                float dis = player.distance(player.getX(),player.getY() , smoke.x , smoke.y);
                float range = (50 + player.getWidth() * 0.5);
                if (dis <= range && smoke.h ==  0) {
                    player.setAffect(0,millis() + 500);
                    smoke.h = 1;
                }
                if (dis > range) {
                    smoke.h = 0;
                }
            }
        }
        void removeSmoke() {
            for (int i = smokelist.size() - 1; i>= 0; i -= 1) {
                RectObject smoke = smokelist.get(0);           
                if (smoke.w < millis()) {
                    smokelist.remove(smoke);
                }
            }
        }
    }
    private class Project_Laser{
        private int circle_width = 0;
        private int laser_beam_width = 50;
        private int laser_beam_length = 300;
        
        private int laser_state = 0;
        private float laser_angle = 0;
        private boolean Shooting = false;
        
        public void render(float x,float y,GameMap gmap,Player player) {
            rectMode(CORNER);
            noStroke();
            fill(0,255,0);
            pushMatrix();
            gmap.translation(x,y);
            switch(laser_state) {
                case 0:
                    Shooting = false;
                    fill(0,255,0);
                    if (circle_width % 5 > 0) {
                        fill(255,255,255);
                    }
                    circle_width += 3;
                    laser_angle = atan2(player.getY() - y, player.getX() - x);
                    rotate(laser_angle);
                    strokeWeight(2);
                    stroke(0);
                    ellipse(60,0,circle_width,circle_width);
                    laser_state = (circle_width>= 50) ? 1 : 0;
                    break;
                case 1:
                    Shooting = true;
                    rotate(laser_angle);
                    ellipse(60,0,circle_width * 0.5,circle_width);
                    rect(60, -laser_beam_width / 2,laser_beam_length,laser_beam_width);
                    fill(255);
                    float ratio = random(0.6, 0.8);
                    ellipse(60,0,circle_width * 0.5 * ratio,circle_width * ratio);
                    rect(60, -(laser_beam_width * ratio) / 2,laser_beam_length,laser_beam_width * ratio);
                    break;
            }
            popMatrix();
        }
        public void reset() {
            laser_state = 0;
            circle_width = 0;
        }
        public float getAngle() {
            return laser_angle;
        }
        public boolean isShooting() {
            return Shooting;
        }
    }
}

public class Reearch_Institution extends Boss{
    public int state = 0;
    
    private float laser_time = 0;
    private float laser_duration = 3000;
    private float laser_cd = 5000;
    
    public Shell shell = new Shell(new RectObject(x,y,w,h),300);
    public Shell shell2 = new Shell(new RectObject(x,y,w,h),500);
    private Explosion bomb = new Explosion();
    Reearch_Institution(GameMap gmap,int life_value) {
        super(gmap,life_value);
        bullet_level1_cd = 100;
        boss = loadImage("pic/character/enemy/research_institution.png");
    }
    void render(GameMap gmap) {
        imageMode(CENTER);
        gmap.drawImage(boss ,x ,y, w, h);
        boss_hp.render();
        switch(state) {
            case 0 :
                state = (hp.getLifePercentage() < 0.6) ? 1 : 0;
                break;	
            case 1 :
                if (!shell.hp.isGone()) {
                    shell.update(x,y);
                    shell.render(gmap);
                }
                state = (hp.getLifePercentage() < 0.3) ? 2 : 1;
                break;	
            case 2 :
                if (!shell2.hp.isGone()) {
                    shell2.update(x,y);
                    shell2.render(gmap);
                }
                bomb.render(gmap);
                break;	
        }
    }
    void shooting(GameMap gmap ,Player player) {
        level_1(player,10);
        bullet_program(gmap);
        bullet_shootCharater(player , 10);
        
        if (state ==  2) {
            if (millis() > laser_time + laser_cd) {
                laser_time = millis();
                bomb.reset();
                bomb.generation(new RectObject(x,y,500,0));
            }
            laser_shootCharater(player,20);
        }
    }
    public void laser_shootCharater(Player player,float laser_damage) {
        if (bomb.hitPlayer(player)) {
            player.isHurt(laser_damage);
        }
    }
    void isHurt(float value) {
        switch(state) {
            case 1 :
                if (!shell.hp.isGone()) {
                    shell.isHurt(value);      
                }
                else{
                    hp.damage(value);
                }
                break;	
            case 2 :
                if (!shell2.hp.isGone()) {
                    shell2.isHurt(value);      
                }
                else{
                    hp.damage(value);
                }
                break;	
            default :
                hp.damage(value);
                break;
        }
    }
    void level_1(Player player,int counts) {
        if (millis() > bullet_time_1 + bullet_cd && distance<600) {
            if (bullet_level1_count < counts) {
                if (millis() > bullet_level1_time + bullet_level1_cd) {
                    bulletlist.add(new Bullet(new RectObject(x,y,30,30) , angle , color(0,255,0)));
                    angle += 2 * PI / 10;
                    bullet_level1_count ++;
                    bullet_level1_time =  millis();
                }
                for (Bullet bullet : bulletlist) {
                    bullet.setSpeed(20);
                }
            }
            else{
                bullet_time_1 = millis();
                angle = rotation(player.getX() , player.getY());
            }
        }
        else{
            bullet_level1_count = 0; 
        }
    }
    private class Shell extends Character{
        int red_color = 0;
        private Shell_HP shell_hp;
        Shell(RectObject object,float life_value) {
            super(object,life_value);
            shell_hp = new Shell_HP(life_value);
        }
        void render(GameMap gmap) {
            stroke(red_color,0,255 - red_color);
            strokeWeight(10);
            noFill();
            gmap.fillellipse(x,y,w + 20,h + 20);
            shell_hp.render();
        }
        void update(float xp , float yp) {
            x = xp;
            y = yp;
            red_color = (red_color<= 0) ? 0 : red_color - 5;
        }
        void isHurt(float value) {
            hp.damage(value);
            red_color = 255;
        }
        private class Shell_HP extends HP{
            Shell_HP(float life_value) {
                super(life_value);
            }
            void render() {
                float current_life = (width - 200) * hp.getLifeValue() / hp.getOriginalLifeValue();
                rectMode(CENTER);
                stroke(0);
                strokeWeight(5);
                fill(0,200);
                rect(width / 2,height - 100 + 15,(width - 200),30,3);
                fill(0,0,200);
                rect(width / 2,height - 100 + 15,current_life,30,3);
            }
        }
    }
    private class Explosion {
        
        private float x ,y ,rad;
        private int state = 0;
        private boolean Shooting = false;
        
        private int circle_width = 0;
        private int laser_beam_width = 50;
        private int laser_beam_length = 300;
        
        ArrayList<RectObject> bomblist = new ArrayList<RectObject>();
        
        void generation(RectObject object) {
            x = object.x;
            y = object.y;
            rad = object.w / 2;
            for (float i =-  PI;i <=  PI;i += (2 * PI / 6)) {
                float _x = x + rad * cos(i);
                float _y = y + rad * sin(i);
                bomblist.add(new RectObject(_x,_y,millis() + 3000,0));
            }
        }
        void render(GameMap gmap) {
            strokeWeight(1);
            switch(state) {
                case 0:
                    Shooting = false;
                    fill(0,0,255);
                    if (circle_width % 5 > 0) {
                        fill(255,255,255);
                    }
                    circle_width += 3;
                    for (RectObject bomb : bomblist) {
                        gmap.fillellipse(bomb.x,bomb.y,circle_width,circle_width);
                    }
                    state = (circle_width>= 100) ? 1 : 0;
                    break;
                case 1:
                    Shooting = true;
                    for (RectObject bomb : bomblist) {
                        strokeWeight(1);
                        fill(0,0,255);
                        rectMode(CORNER);
                        gmap.fillellipse(bomb.x,bomb.y,circle_width,circle_width);
                        gmap.fillrect(bomb.x - laser_beam_width / 2 , bomb.y - laser_beam_length , laser_beam_width , laser_beam_length);
                        noStroke();
                        fill(255);
                        float ratio = random(0.6, 0.8);
                        gmap.fillellipse(bomb.x,bomb.y,circle_width * ratio,circle_width * ratio);
                        gmap.fillrect(bomb.x - laser_beam_width / 2 * ratio , bomb.y - laser_beam_length , laser_beam_width * ratio , laser_beam_length);
                    }
                    break;
            }            
            removeObject();
        }
        void removeObject() {
            for (int i = bomblist.size() - 1; i>= 0; i -= 1) {
                RectObject bomb = bomblist.get(i);            
                if (bomb.w < millis()) {
                    bomblist.remove(bomb);
                }
            }
        }
        boolean hitPlayer(Player player) {
            for (RectObject bomb : bomblist) {
                if (player.getY() < bomb.y && player.getY() > bomb.y - laser_beam_length && abs(player.getX() - bomb.x) < laser_beam_width / 2 && Shooting) {
                    return true;
                }
            }
            return false;
        }
        public void reset() {
            state = 0;
            circle_width = 0;
        }
        public boolean isShooting() {
            return Shooting;
        }
    }
}

public class Professor extends Reearch_Institution {
    private int fire_size = 0;
    private int fire_range = 600;
    private float fire_angle = -PI;
    private PImage  ring_of_fire = loadImage("pic/character/enemy/Ring_of_flame.png");
    public Professor(GameMap gmap,int life_value) {
        super(gmap ,life_value);
        boss = loadImage("pic/character/enemy/ntust.png");
    }
    void render(GameMap gmap) {
        imageMode(CENTER);
        gmap.drawImage(boss ,x ,y, w, h);
        boss_hp.render();
        // println(state);
        switch(state) {
            case 0 :
                if (!shell.hp.isGone()) {
                    shell.update(x,y);
                    shell.render(gmap);
                }
                state = (hp.getLifePercentage() < 0.6) ? 1 : 0;
                break;	
            case 1 :
                imageMode(CENTER);
                gmap.drawImage(ring_of_fire, x, y, fire_size, fire_size);
                fire_size +=5;
                state = (fire_size >= fire_range) ? 2 : 1;
                break;
            case 2:
                imageMode(CENTER);
                pushMatrix();
                gmap.translation(x  ,y);
                rotate(fire_angle);
                image(ring_of_fire, 0, 0, fire_size, fire_size);
                popMatrix();
                gmap.drawImage(boss ,x ,y, w, h);
                fire_angle = (fire_angle>= PI) ? - PI : fire_angle + (2 * PI / 10);
                state = (hp.getLifePercentage() < 0.3) ? 3 : 2;
                break;
            case 3 :
                if (!shell2.hp.isGone()) {
                    shell2.update(x,y);
                    shell2.render(gmap);
                }
                break;	
        }
    }
    
    void shooting(GameMap gmap ,Player player) {
        level_1(player,((state == 3) ? 30 : 20));
        bullet_program(gmap);
        bullet_shootCharater(player , 10);
        if (state == 2) {
            if (player.distance(x,y,player.getX(),player.getY()) <= fire_range / 2) {
                player.isHurt(10);
            }
        }
    }
    void isHurt(float value) {
        switch(state) {
            case 0 :
                if (!shell.hp.isGone()) {
                    shell.isHurt(value);      
                }
                else{
                    hp.damage(value);
                }
                break;	
            case 2:
                hp.damage(value);
                break;
            case 3 :
                if (!shell2.hp.isGone()) {
                    shell2.isHurt(value);      
                }
                else{
                    hp.damage(value);
                }
                break;	
        }
    }
    
}   
