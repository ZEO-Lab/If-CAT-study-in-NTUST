class GameMap{
    private  float wid , hei  ;
    private  float LeftSide;
    private  float RightSide;
    private  float TopSide;
    private  float BottomSide;
    
    private PImage backgroundImage;
    private color backgroundColor;
    Translate_Coordinate coordinate = new Translate_Coordinate( -50, -50);
    
    GameMap() { }
    GameMap(color backgroundColor) { 
        wid = 4000;
        hei = 3500;
        this.backgroundColor = backgroundColor;
    }
    GameMap(String mapLocation) { 
        wid = 4000;
        hei = 3500;
        backgroundImage = loadImage(mapLocation);
        Translate_Coordinate.setX( -(wid-width)/2 );
        Translate_Coordinate.setY( -(hei-height)/2 );

    }
    void drawBackGroundImage() {
        imageMode(CORNER);
        image(backgroundImage,Translate_Coordinate.getX(),Translate_Coordinate.getY(),wid,hei);
    }
    void fillBackGround() {
        background(backgroundColor);
    }
    void drawImage(PImage img,float _x,float _y,float _width,float _height) {
        image(img , _x + Translate_Coordinate.getX(),_y + Translate_Coordinate.getY() , _width , _height);
    }
    void fillrect(float _x,float _y,float _width,float _height) {
        rect(_x + Translate_Coordinate.getX() , _y + Translate_Coordinate.getY(),_width,_height);
    }
    void fillellipse(float _x,float _y,float _width,float _height) {
        ellipse(_x + Translate_Coordinate.getX(), _y + Translate_Coordinate.getY(), _width, _height);
    }
    void translation(float _x,float _y) {
        translate(_x + Translate_Coordinate.getX() , _y + Translate_Coordinate.getY());
    }
    void update() {
        LeftSide = Translate_Coordinate.getX();
        RightSide = Translate_Coordinate.getX() + wid;
        TopSide = Translate_Coordinate.getY();
        BottomSide = Translate_Coordinate.getY() + hei;
    }
    void move(int keys,Player player) {
        float speed = player.getMovingSpeed() ;
        float p_x = getWindowX(player.getX());
        float p_y = getWindowY(player.getY());

        boolean isMovingLeft = ((keys & 1) == 1) ? true : false;
        boolean isMovingRight = (((keys>>1) & 1) == 1) ? true : false;
        boolean isMovingUp = (((keys>>2) & 1) == 1) ? true : false;
        boolean isMovingDoen = (((keys>>3) & 1) == 1) ? true : false;

        if ( isMovingRight && (RightSide - speed) >= width && p_x >= width/2) { //move right
            Translate_Coordinate.setX(Translate_Coordinate.getX() - speed);
        }
        if (isMovingLeft && (LeftSide + speed) <= 0 &&  p_x <= width/2) { //move left
            Translate_Coordinate.setX(Translate_Coordinate.getX() + speed);
        } 	
        if (isMovingDoen && (BottomSide - speed) >= height && p_y >= height/2 ) { //move down
            Translate_Coordinate.setY(Translate_Coordinate.getY() - speed);
        } 	
        if (isMovingUp && (TopSide - speed) <= 0 && p_y <= height/2 ) { //move top
            Translate_Coordinate.setY(Translate_Coordinate.getY() + speed);
        }
        update();
    }
    public float getWindowX(float _x){
        return Translate_Coordinate.getX() + _x;
    }
    public float getWindowY(float _y){
        return Translate_Coordinate.getY() + _y;
    }
    public float getX(){
        return Translate_Coordinate.getX();
    }
    public float getY(){
        return Translate_Coordinate.getY();
    }
    public float getWidth(){
        return wid;
    }

    public float getHeigh(){
        return hei;
    }
}
private static class Translate_Coordinate{
    private static float xpos;
    private static float ypos;
    Translate_Coordinate(float _x,float _y) {
        xpos = _x;
        ypos = _y;
    }
    static void setX(float x) {
        xpos = x;
    }
    static void setY(float y) {
        ypos = y;
    }
    static float getX() {
        return xpos;
    }
    static float getY() {
        return ypos;
    }
}
