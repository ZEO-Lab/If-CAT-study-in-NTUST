abstract class Character{
    public float bullet_damage = 10;
    private boolean characterComplete = false;
    private int second;
    private String crack_state = "initialize";
    
    private float _x,_y;//default x, y for shaking
    public float x,y,w,h;
    public float distance,angle;    
    public boolean isShake;
    
    public HP hp;
    public PVector moving = new PVector(10 , 1);
    public ArrayList<Bullet> bulletlist  = new ArrayList<Bullet>();
    private confetti[] cc = new confetti[10];
    Character() {
        hp =  new HP(200);
    }
    Character(float life) {
        x = 0;
        y = 0;
        w = 10;
        h = 10;
        hp = new HP(life);
    }
    Character(RectObject object,float life) {
        x = object.x;
        y = object.y;
        w = object.w;
        h = object.h;
        _x = x;
        _y = y;
        hp = new HP(life);
    }
    float getX() {return x;}
    float getY() {return y;}
    float getWidth() {return w;}
    float getHeigh() {return h;}
    void setShaking(boolean state) {
        isShake = state;
    }
    
    abstract void render(GameMap gmap);
    void shooting() {}; 
    void isHurt(float value) {
        hp.damage(value);
    }
    public void setMovingSpeed(int speed) {
        moving.x = speed;
    }
    public float getMovingSpeed() {
        return  moving.x * moving.y;
    }
    void bullet_program(GameMap gmap) {
        for (Bullet bb : bulletlist) {
            bb.move(); 
            bb.OutOfRange(gmap); 
            bb.render(gmap); 
        }
        bullet_Remove(bulletlist);
    }
    void bullet_shootCharater(Character c1,float bullet_damage) {
        for (Bullet bb : bulletlist) {
            float radians =  distance(c1.getX(),c1.getY(),bb.getX(),bb.getY());
            if (radians < (c1.getWidth() / 2)) {
                c1.isHurt(bullet_damage);
                bb.isDistroy = true;
            } 
        }
        bullet_Remove(bulletlist);
    }
    void bullet_Remove(ArrayList<Bullet> _bulletlist) {
        for (int i = _bulletlist.size() - 1; i>= 0; i -= 1) {
            Bullet bb = _bulletlist.get(i);  
            if (bb.isDistroy ==  true) {
                _bulletlist.remove(bb);
            }
        }
    }
    boolean crack(GameMap gmap) {
        int counter = 0;
        switch(crack_state) {
            case "initialize" :
                _x = x;
                _y = y; 
                for (int i = 0; i < cc.length; i++) {
                    cc[i] = new confetti(gmap.getWindowX(x),gmap.getWindowY(y));
                }
                second = millis();
                crack_state = (isShake) ? "shack" : "crack";
                break;	
            case "shack":
                x = random(_x - 2,_x + 2);
                y = random(_y - 2,_y + 2);
                render(gmap);
                crack_state = (millis()>= second + 1000) ? "crack" : "shack";
                break;
            case "crack":
                for (confetti c : cc) {
                    c.show();
                    counter = (c.outOfRange()) ? counter + 1 : counter;
                }
                return counter ==  10;
        }
        return false;
    }
    float distance(float e_x,float e_y,float c_x,float c_y) {
        return sqrt(pow((e_x - c_x),2) + pow((e_y - c_y),2));
    }
    float rotation(float targetX,float targetY) {
        return atan2(targetY - y, targetX - x);  
    }
    void setComplete(boolean state) {
        characterComplete = state;
    }
    boolean isComplete() {
        return characterComplete;
    }
}
class Bullet{
    private float x,y;
    private float w,h;
    private float angle;
    private int bullet_speed = 15; 
    private int bullet_moving_time = 0; 
    private int bullet_color = color(255,255,10); 
    
    boolean isDistroy = false;
    
    private PImage bullet_Image;
    
    Bullet(RectObject object,float rotation,String imgPath) {
        x = object.x;
        y = object.y;
        w = object.w;
        h = object.h;
        angle = rotation;
        bullet_Image = loadImage(imgPath);
        bullet_moving_time = millis();
    }
    Bullet(RectObject object,float rotation,color bullet_color) {
        x = object.x;
        y = object.y;
        w = object.w;
        h = object.h;
        angle = rotation;
        this.bullet_color = bullet_color;
        bullet_moving_time = millis();
    }
    void setSpeed(int speed) {
        bullet_speed = speed;
    }
    void setImage(String imgPath) {
        bullet_Image = loadImage(imgPath);
    }
    float getX() {return x;}
    float getY() {return y;}
    float getWidth() {return w;}
    float getHeigh() {return h;}
    void render(GameMap gmap) {
        if (bullet_Image == null) {
            stroke(0);
            strokeWeight(1);
            fill(bullet_color);
            gmap.fillellipse(x , y , w , h);
        }
        else{
            imageMode(CENTER);
            gmap.drawImage(bullet_Image,x,y,w,h);      
        }
    }
    
    void move() {
        x += cos(angle) * bullet_speed;
        y += sin(angle) * bullet_speed;  
    }
    boolean OutOfRange(GameMap gmap) {
        int times = millis() - bullet_moving_time;
        // if (y < gmap.getY() || y > gmap.getHeigh() || x < gmap.getX() || x > gmap.getWidth() || times > 2000) {
        if (times > 1500) {
            isDistroy = true;
        }
        return isDistroy;
    }
}
public class HP{
    private float original_life_value;
    private float life_value;
    HP(float life_value) {
        original_life_value = life_value;
        this.life_value = life_value;
        }
    void render(float x,float y) {
        float current_life = 40 * life_value / original_life_value;
        rectMode(CENTER);
        stroke(0);
        strokeWeight(1);
        fill(255);
        rect(x ,y,40,15);
        rectMode(CORNER);
        fill(color(227,23,13));
        rect(x - 20  , y - 7.5 , current_life ,15);
        }
    void heal(float value) {
        life_value = ((life_value + value)>original_life_value) ? original_life_value : life_value + value;
        }
    void damage(float attack_value) { 
        life_value = ((life_value - attack_value)<0) ? 0 : life_value - attack_value;
        }
    boolean isGone() {return(life_value <=  0);} 
    float getLifePercentage() {return life_value / original_life_value;}
    float getLifeValue() {return life_value;}
    float getOriginalLifeValue() {return original_life_value;}
    }

private class confetti{
    private float x,y;
    private float xspeed,yspeed;
    confetti(float _x, float _y) {
        x = _x;
        y = _y;
        burst();
        }
    void  burst() { 
        xspeed = random( -10,10);
        yspeed = random( -10,10);
        }
    void update() {
        x += xspeed;
        y += yspeed;
        yspeed += 1;
        }
    void show() {
        fill(0);
        if (!outOfRange()) {
            update();
            circle(x,y,10);
            }
        }
    boolean outOfRange() {
        boolean out = ((x<= -10) || (x>= width + 10) || (y<= -10) || (y>= height + 10)) ? true : false;
        return out;
        }
    }
