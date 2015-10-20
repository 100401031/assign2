
final int GAME_START = 1, GAME_RUN = 2, GAME_LOSE = 3;
int gameState;
int bgX;  //position of background
float shipX, shipY;  //position of the ship
float shipW;  //width of the ship
float shipH;  //height of the ship
float speed = 5;  //speed of the ship
float HP;  //the length of the rectangle of health point
float currentHP;  //current length of the rectangle of health point
float treasureX,treasureY;  // position of treasure
float treasureW;  //width of treasure
float treasureH;  //height of treasure
float treasureD;  //the distance between the ship and treasure
float enemyX, enemyY;  //position of enemy
float enemyW;  //width of enemy
float enemyH;  //height of enemy
float enemyD;  //the distance between the ship and enemy
float enemyDY;  //the y-coordinate distance between the ship and enemy
float enemyACCY;  //the y-coordinate acceleration of enemy
float enemySpeed= 5;  //speed of the enemy
PImage shipImg, bgImg1, bgImg2, hpImg,enemyImg, treasureImg, startBgImg1, startBgImg2, endImg1, endImg2;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;


/*-------------------------------SETUP-------------------------------*/
void setup () {
  size(640, 480) ;
  shipW = 51;
  shipH = 51;
  shipX = height;
  shipY = width/2;
  HP = 210;
  currentHP = HP;
  treasureX = floor(random(0+treasureW,width+1-treasureW));
  treasureY = floor(random(0+treasureH,height+1-treasureH));
  treasureW = 41;
  treasureH = 41;
  enemyW = 61;
  enemyH = 61;
  enemyX = 0;
  enemyY = floor(random(0+enemyH/2,height+1-enemyH/2));
  enemyACCY = 25;
  shipImg = loadImage("img/fighter.png");
  startBgImg1 = loadImage("img/start1.png");
  startBgImg2 = loadImage("img/start2.png");
  bgImg1 = loadImage("img/bg1.png");
  bgImg2 = loadImage("img/bg2.png");
  endImg1 = loadImage("img/end1.png");
  endImg2 = loadImage("img/end2.png");
  hpImg = loadImage("img/hp.png");
  enemyImg = loadImage("img/enemy.png");
  treasureImg = loadImage("img/treasure.png");
  gameState = GAME_START;
}

/*-------------------------------DRAW-------------------------------*/

void draw() {

  switch(gameState){

    
    case GAME_START:
      //background
      if (mouseX >= 208 && mouseX <= 455 && mouseY >= 378 && mouseY<= 414) {
        image(startBgImg1,0,0);
        if (mousePressed == true) {
          currentHP = HP;
          gameState = GAME_RUN;
        }
      }
      else{
        image(startBgImg2,0,0);
      }
    break;


    case GAME_RUN:
      //background
      bgX += 1;
      bgX %= 1280;
      image(bgImg1,bgX, 0);//fisrt bakground
      image(bgImg2,-640+bgX, 0);//second background
      image(bgImg1,-1280+bgX, 0);//third background

      //treasure

      image(treasureImg, treasureX, treasureY);
      
      //collision
      treasureD = sqrt(pow(treasureX-shipX,2)+pow(treasureY-shipY,2));
      if (treasureD < 40){
        if (currentHP < HP) {
           currentHP += HP/10;
        }
        treasureX = random(0, width+1-treasureW/2);
        treasureY = random(0, height+1-treasureH/2);
      }


      //ship
      
      imageMode(CENTER);
      image(shipImg, shipX, shipY);
      
      if (upPressed) {
        shipY -= speed;
      }
      if (downPressed) {
        shipY += speed;
      }
      if (leftPressed) {
        shipX -= speed;
      }
      if (rightPressed) {
        shipX += speed;
      }

      //keep the ship from the borders
      if (shipX+shipW/2 > width) {
        shipX = width-shipW/2;
        rightPressed = false;
      }
      if (shipX-shipW/2 < 0) {
        shipX = 0+shipW/2; 
        leftPressed = false;
      }
      if (shipY+shipH/2 > height) {
        shipY = height - shipH/2;
        downPressed = false;
      }
      if (shipY-shipH/2 < 0) {
        shipY = 0+shipH/2; 
        upPressed = false;
      }


      //enemy

      image(enemyImg, enemyX, enemyY);
      enemyX += enemySpeed;
      enemyX %= 640;
      
      if (enemyX-enemyH/2 == width-enemySpeed) {
      enemyY = random(0+enemyH/2,height+1-enemyH/2);
      }
      
      //let the enemy to chase the ship
      enemyDY = shipY-enemyY;
      enemyY += enemyDY/enemyACCY;

      //collision
      enemyD = sqrt(pow(enemyX-shipX,2)+pow(enemyY-shipY,2));
      if (enemyD < 53){
        if (currentHP > HP/10) {
          currentHP -= HP/5;
        }
        else if (currentHP > 0){
          currentHP -= HP/10;
        }
        enemyX = 0;
        enemyY = random(0+enemyH/2,height+1-enemyH/2);
      }
  




      //HP

      fill(#FF0000);
      rect(20, 20,currentHP, 31, 20);
      imageMode(CORNER);
      image(hpImg, 20, 20);
      if (currentHP == 0) {
      gameState = GAME_LOSE;  //lose
      }
    break;


    case GAME_LOSE:
    //background
    if (mouseX >= 210 && mouseX <= 434 && mouseY >= 312 && mouseY<= 348) {
      image(endImg1,0,0);
        if (mousePressed == true) {
          gameState = GAME_START;
        }
    }
    else{
      image(endImg2,0,0);
    }
    break;
  }

}

/*-------------------------------KEY-------------------------------*/

void keyPressed() {

  if (key == CODED) {
    switch(keyCode) {
      case UP:
      if (shipY-shipH/2 > 0) {
        upPressed = true;
      }
      break;
      
      case DOWN:
      if (shipY+shipH/2 < height) {
        downPressed = true;
      }
      break;
      
      case LEFT:
      if (shipX-shipW/2 > 0) {
        leftPressed = true;
      }
      break;
      
      case RIGHT:
        if (shipX+shipW/2 < width) {
          rightPressed = true;
        }
      break;
      
    }
  }
}


void keyReleased() {
  
  if (key == CODED) {
    
    switch(keyCode) {
      case UP:
      upPressed = false;
      break;
      case DOWN:
      downPressed = false;
      break;
      case LEFT:
      leftPressed = false;
      break;
      case RIGHT:

      rightPressed = false;

      break;
      
    }
  }
}
