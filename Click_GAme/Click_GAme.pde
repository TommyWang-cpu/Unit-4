import processing.sound.*; 
SoundFile pauseSound;

PImage[] images;
int currentImage = 0;

float x, y;
float vx, vy;

float sizeValue = 100;
float speedValue = 4;

float sizeSliderX = 20, sizeSliderY = 330;
float speedSliderX = 20, speedSliderY = 380;

int score = 0;
int highScore = 0;
int lives = 10;

int gameState = 0; 
// 0 = menu
// 1 = playing
// 2 = game over
// 3 = paused
// 4 = options

void setup() {
  size(600, 500);
  textAlign(CENTER, CENTER);

  images = new PImage[3];
  images[0] = loadImage("DVD.jpg");
  images[1] = loadImage("Chicken.jpg");
  images[2] = loadImage("Apple.jpg");
  
  
  pauseSound = new SoundFile(this, "TheWorld.mp3");

  resetObject();
  
  //minim = new Minim(this);
 //pauseSound = minim.loadFile("TheWorld.mp3");
}

// ---------------- MAIN -----------
void draw() {

  if (gameState == 0) {
    drawMenu();
    return;
  }

  if (gameState == 2) {
    drawGameOver();
    return;
  }

  if (gameState == 3) {
    drawPauseScreen();
    return;
  }
  
  if (gameState == 4){
   imageOptions(); 
   return;
  }

  background(220);

  moveObject();
  drawObject();
  drawGameUI();
  drawPauseButton();

  if (lives <= 0) {
    gameState = 2;
  }
}

// ----------- MENU ----------------
void drawMenu() {
  background(180);

  fill(0);
  textSize(30);
  text("CLICK GAME", width/2, 60);

  imageMode(CENTER);
  image(images[currentImage], width/2, 150, sizeValue, sizeValue);

  fill(100, 200, 100);
  rect(width/2 - 75, 240, 150, 50);
  fill(0);
  textSize(18);
  text("START", width/2, 265);

  fill(100, 150, 255);
  rect(width/2 - 75, 300, 150, 50);
  fill(0);
  text("OPTIONS", width/2, 325);

  fill(200, 100, 100);
  rect(width/2 - 75, 360, 150, 50);
  fill(0);
  text("EXIT", width/2, 385);

  
}

// ------------- GAME -------------
void drawGameUI() {
  fill(0);
  textSize(18);
  text("Score: " + score, width/2, 20);
  text("High Score: " + highScore, width/2, 45);
  text("Lives: " + lives, width/2, 70);
}

void drawPauseButton() {
  fill(255, 200, 0);
  rect(width - 100, 10, 80, 30);
  fill(0);
  textSize(12);
  text("PAUSE", width - 60, 25);
}

void drawObject() {
  imageMode(CENTER);
  image(images[currentImage], x, y, sizeValue, sizeValue);
}

void moveObject() {
  x += vx;
  y += vy;

  if (x < sizeValue/2 || x > width - sizeValue/2) {
    vx *= -1;
    lives--;
  }

  if (y < sizeValue/2 || y > height - sizeValue/2) {
    vy *= -1;
    lives--;
  }
}

// ----------- PAUSE SCREEN -----------
void drawPauseScreen() {
  //background(100);
  fill(100);
  textSize(30);
  text("PAUSED", width/2, height/2 - 20);
  textSize(16);
  text("Click to Resume", width/2, height/2 + 20);
}

// ------------- SLIDER --------------
void drawSlider(float xPos, float yPos, float value, float minV, float maxV, String label, color c) {
  fill(0);
  textSize(12);
  text(label, xPos + 40, yPos - 10);

  fill(200);
  rect(xPos, yPos, 120, 10);

  fill(c);
  rect(xPos, yPos, map(value, minV, maxV, 0, 120), 10);
}

// ----------- MOUSE CLICK -------------
void mousePressed() {

  // MENU
  if (gameState == 0) {

    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 240 && mouseY < 290) {

      gameState = 1;
      vx = speedValue;
      vy = speedValue;
    }

    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 300 && mouseY < 350) {
       gameState = 4;
    }

    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 360 && mouseY < 410) {
      exit();
    }
  }
  
  if (gameState == 4){
    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 300 && mouseY < 350) {
        currentImage = (currentImage + 1) % images.length;
        }
        
    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 360 && mouseY < 410) {
        gameState = 0;
        }
  }

  // GAME CLICK
  if (gameState == 1) {

    // Pause button
    if (mouseX > width - 100 && mouseX < width - 20 &&
        mouseY > 10 && mouseY < 40) {

      gameState = 3;
      pauseSound.play();
      return;
    }

    if (dist(mouseX, mouseY, x, y) < sizeValue/2) {
      score++;
      if (score > highScore) highScore = score;
    }
  }

  // RESUME FROM PAUSE
  if (gameState == 3) {
    gameState = 1;
  }

  // GAME OVER
  if (gameState == 2) {
    restartGame();
    gameState = 0;
  }
}

// ----------- DRAG SLIDERS --------
void mouseDragged() {

  if (gameState != 4) return;

  if (mouseX >= sizeSliderX && mouseX <= sizeSliderX + 120 &&
      mouseY >= sizeSliderY - 5 && mouseY <= sizeSliderY + 15) {

    sizeValue = map(mouseX, sizeSliderX, sizeSliderX + 120, 50, 200);
  }

  if (mouseX >= speedSliderX && mouseX <= speedSliderX + 120 &&
      mouseY >= speedSliderY - 5 && mouseY <= speedSliderY + 15) {

    speedValue = map(mouseX, speedSliderX, speedSliderX + 120, 1, 10);
  }
}



// ------------- RESET -----------
void resetObject() {
  x = width/2;
  y = height/2;

  vx = speedValue;
  vy = speedValue;

  score = 0;
  lives = 10;
}

void restartGame() {
  resetObject();
}

// ------------ GAME OVER ----------------
void drawGameOver() {
  background(50);

  fill(255);
  textSize(30);
  text("GAME OVER", width/2, height/2 - 40);

  textSize(18);
  text("Score: " + score, width/2, height/2);
  text("Click to return", width/2, height/2 + 40);
}    

void imageOptions(){
  background(180);
  
  textSize(18);
  
  fill(100, 150, 255);
  rect(width/2 - 75, 300, 150, 50);
  fill(0);
  text("CHANGE IMAGE", width/2, 325);
  
  fill(200, 100, 100);
  rect(width/2 - 75, 360, 150, 50);
  fill(0);
  text("EXIT", width/2, 385);
  
  imageMode(CENTER);
  image(images[currentImage], width/2, 150, sizeValue, sizeValue);
  
  drawSlider(sizeSliderX, sizeSliderY, sizeValue, 50, 200, "SIZE", color(50,150,255));
  drawSlider(speedSliderX, speedSliderY, speedValue, 1, 10, "SPEED", color(255,100,100));
}
