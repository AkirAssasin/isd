/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList bots;
String[] metal = {"Zinc", "Aluminium", "Iron(II)", "Iron(III)", "Copper", "Chromium", "Calcium", "Ammonium"};
String[] preci = {"No Precipitates", "Has Precipitates"};
String[] solub = {"Dissolves in Excess", "Does not Dissolve in Excess"};
color[] pcolr = {color(59,70,45), color(64,29,6), color(123,209,221), color(87,100,87), color(255), color(255,100)};

String[] three = {"Concentrate. You have 3 chances, junior.", "Calm down! You still get two tries.", "Don't make a mistake, boy!", "You gon act like an idiot? YOU GON GET FIRED LIKE AN IDIOT!"};

// Metal, Precipitate in NaOH, Dissolve in excess NaOH, Colour of Precipitate in NaOH, Precipitate in (NH3)/(NH4)OH, Dissolve in excess (NH3)/(NH4)OH, Colour of Precipitate in (NH3)/(NH4)OH.

int[] c_zinc = {0, 1, 0, 4, 1, 0, 4};

int[] c_alum = {1, 1, 0, 4, 1, 1, 4};

int[] c_iron_a = {2, 1, 1, 0, 1, 1, 0};

int[] c_iron_b = {3, 1, 1, 1, 1, 1, 1};

int[] c_copp = {4, 1, 1, 2, 1, 1, 2};

int[] c_chro = {5, 1, 0, 3, 1, 0, 3};

int[] c_calc = {6, 1, 1, 4, 0, 0, 5};

int[] c_ammo = {7, 0, 0, 5, 0, 0, 5};

int fails = 0;

float firetime = 0;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    bots = new ArrayList();
    //textFont(myfont);
    bots.add(new Bot());
    bots.add(new Bot());
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};




void draw() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    background(225);
    fill(225);
    stroke(0);
    if (fails >= 3) {firetime += 0.1;}
    translate(random(-firetime,firetime),random(-firetime,firetime));
    for (int i=bots.size()-1; i>=0; i--) {
        Particle b = (Bot) bots.get(i);
        b.draw(i);
        if (b.pass && b.x > width + 300) {
          bots.remove(i);
        }
        if (b.reverse && b.x < -300) {
          bots.remove(i);
        }
    }
    fill(200);
    stroke(200);
    rect(0,height*3/4,width,height/4);
    textAlign(CENTER,CENTER);
    textSize(width/18);
    fill(0,255,0);
    stroke(0,255,0);
    ellipse(width/8,height*3/4 + height/8,width/9,width/9);
    fill(0,100,0);
    stroke(0,100,0);
    text("GO",width/8,height*3/4 + height/8);
    
    translate(width*7/8,height*3/4 + height/8);
    rotate(radians(10));
    fill(150);
    stroke(150);
    rect(width/9*3/4 - 30,-width/9,15,-width/8);
    rect(-width/9*3/4,-width/9,width/9*6/4,width/9 + width/9);
    if (random(1) > 0.1) {fill(248,251,153);} else {fill(75,77,46);}
    ellipse(-width/9*3/4 + 15,-width/9 + 15,15,15);
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(0,0,width/9,width/9);
    rotate(radians(-10));
    fill(255);
    stroke(255);
    triangle(width/18,-width/9 - 15,width/18,-width/9 - 40,width/18 - 15,-width/9 - 40);
    rect(width/18,-width/9 - 40,-three[min(fails,3)].length()*8,-30);
    textAlign(RIGHT,CENTER);
    textSize(15);
    fill(0);
    text(three[min(fails,3)],width/18 - 15,-width/9 - 55);
    translate(-width*7/8,-height*3/4 - height/8);
    
    pwidth = width;
    pheight = height;
    
    Particle b = (Bot) bots.get(0);
    b.viewInfo();
    
    fill(0,255 - (max((firetime - 30),0)*8.5);
    rect(-width,-height,width*2,height*2);
}

void mousePressed() {
    if (dist(mouseX,mouseY,width/8,height*3/4 + height/8) <= width/9) {
      Particle b = (Bot) bots.get(0);
      b.pass = true;
      if (b.fake || b.notcert) {fails += 1;}
      bots.add(new Bot());
    }
    if (dist(mouseX,mouseY,width*7/8,height*3/4 + height/8) <= width/9) {
      Particle b = (Bot) bots.get(0);
      b.reverse = true;
      if (b.fake == false && b.notcert == false) {fails += 1;}
      bots.add(new Bot());
    }
}

void mouseDragged() {
    Particle b = (Bot) bots.get(0);
    if (mouseX.between(b.px - 190, b.px + 190) && mouseY.between(b.py - 150, b.py + 150)) {
      b.px += mouseX - pmouseX;
      b.py += mouseY - pmouseY;
    }
}

class Bot {
    float x;
    float px = width/2;
    float py = -150;
    int which;
    boolean notcert;
    boolean ammon;
    int[] choiceval;
    int[] corval;
    int[] wdisp;
    boolean fake;
    boolean shake;
    float[] rot = new float[3];
    float[] box = new float[3];
    boolean pass = false;
    boolean reverse = false;

    Bot() {
      x = -300;
      choiceval = chance.pick([c_zinc, c_alum, c_iron_a, c_iron_b, c_copp, c_chro, c_calc, c_ammo]);
      rot[0] = 0;
      rot[1] = 0;
      rot[2] = 0;
      box[0] = random(20);
      box[1] = random(20);
      box[2] = random(20);
      notcert = false;
      which = chance.pick([0,3,5]);
      if ((choiceval == c_calc && which == 3) || (choiceval == c_zinc && which == 0) || (choiceval == c_alum && which == 0)) {notcert = true;}
      ammon = chance.pick([true,false]);
      if (which != 5) {
        wdisp = {
            choiceval[0], 
            choiceval[4 - which],
            choiceval[5 - which],
            choiceval[6 - which]
        };
          
        corval = {
            choiceval[0], 
            choiceval[4 - which],
            choiceval[5 - which],
            choiceval[6 - which]
        };
      } else {
        wdisp = choiceval;
        corval = choiceval;
      }
      if (random(1) > 0) {
        fake = true;
        if (which != 5) {int fakeval = chance.pick([0,1,2,3]);} else {int fakeval = chance.pick([0,1,2,3,4,5,6]);}
        wdisp[fakeval] += round(random(-2,2));
        if (fakeval == 0) {
          wdisp[fakeval] = constrain(wdisp[fakeval],0,7);
        } else if (fakeval == 1) {
          wdisp[fakeval] = constrain(wdisp[fakeval],0,1);
        } else if (fakeval == 2) {
          wdisp[fakeval] = constrain(wdisp[fakeval],0,1);
        } else if (fakeval == 3) {
          wdisp[fakeval] = constrain(wdisp[fakeval],0,5);
        }
        if (which == 5) {
          if (fakeval == 4) {
            wdisp[fakeval] = constrain(wdisp[fakeval],0,7);
          } else if (fakeval == 5) {
            wdisp[fakeval] = constrain(wdisp[fakeval],0,1);
          } else if (fakeval == 6) {
            wdisp[fakeval] = constrain(wdisp[fakeval],0,1);
          }
        }
        if (wdisp[fakeval] == corval[fakeval]) {fake = false;}
      }
    };

    void draw(id) {
        if (id == 0) {
          x += (width/2 - x)/50;
        }
        if (id == 1) {
          x += (0 - x)/50;
        }
        if (pass) {
          x += 25;
        }
        if (reverse) {
          x -= 25;
          translate(x,0);
          stroke(249,200,48);
          fill(249,200,48);
          rect(300,height/4,-300,height);
            
          stroke(151,249,231);
          fill(151,249,231);
          rect(200,height/4 + 50,-190,200);
            
          stroke(107);
          fill(107);
          rect(0,height*3/4 - 100,-40,50);
            
          stroke(53,85,17);
          fill(53,85,17);
          rect(300,height*3/4 - 30,-320,height);
          rect(300,height/4 - 10,-50,height);
          rect(100,height*3/4 - 80,-120,height);
            
          stroke(122);
          fill(122);
          rect(-40,height/4 + 100,-20,height);
            
          stroke(116,85,37);
          fill(116,85,37);
          rect(-60 - box[0],height*3/4 - 100,-200,100);
            
          stroke(100,85,37);
          fill(100,85,37);
          rect(-60 - box[1],height*3/4 - 200,-200,100);
            
          stroke(116,90,37);
          fill(116,90,37);
          rect(-60 - box[2],height*3/4 - 300,-200,100);
            
          translate(-x,0);
        } else {
          translate(x,0);
          stroke(249,200,48);
          fill(249,200,48);
          rect(-300,height/4,300,height);
            
          stroke(151,249,231);
          fill(151,249,231);
          rect(-200,height/4 + 50,190,200);
            
          stroke(107);
          fill(107);
          rect(0,height*3/4 - 100,40,50);
            
          stroke(53,85,17);
          fill(53,85,17);
          rect(-300,height*3/4 - 30,320,height);
          rect(-300,height/4 - 10,50,height);
          rect(-100,height*3/4 - 80,120,height);
            
          stroke(122);
          fill(122);
          rect(40,height/4 + 100,20,height);
            
          stroke(116,85,37);
          fill(116,85,37);
          rect(60 + box[0],height*3/4 - 100,200,100);
            
          stroke(100,85,37);
          fill(100,85,37);
          rect(60 + box[1],height*3/4 - 200,200,100);
            
          stroke(116,90,37);
          fill(116,90,37);
          rect(60 + box[2],height*3/4 - 300,200,100);
            
          translate(-x,0);
        }
    }

    void viewInfo() {
      if (x.between(width/4,width*3/4)) {
      if (!pass && !reverse && (py >= height || (mouseX.between(px - 190, px + 190) && mouseY.between(py - 150, py + 150) && mousePressed))) {
        if (shake) {
          shake = false;
          rot[0] = random(-10,5);
          rot[1] = rot[0] + random(-10,10);
          rot[2] = rot[1] + random(-10,10);
        }
      } else {
        py += 45;
        shake = true;
      }
    
      translate(px,py);
        
      fill(pcolr[wdisp[3]]); 
      stroke(pcolr[wdisp[3]]); 
      rotate(radians(rot[2]));
      rect(-190 + rot[1] + rot[2],-150 - rot[1] - rot[2],380,300);
      rotate(-radians(rot[2]));
        
      if (which == 5) {
        fill(pcolr[wdisp[6]]); 
        stroke(pcolr[wdisp[6]]); 
      }
      rotate(radians(rot[1]));
      rect(-190 + rot[1],-150 - rot[1],380,300);
      rotate(-radians(rot[1]));
        
      fill(255,250,225);
      stroke(255,253,253);
      rotate(radians(rot[0]));
      rect(-190,-150,380,300);
        
      textAlign(CENTER,TOP);
      
      fill(0);  
      textSize(50);            
      text(metal[wdisp[0]],0, - 150);
            
      textSize(20);
      text(preci[wdisp[1]],0, - 85);
      text(solub[wdisp[2]],0, - 60);
            
      textSize(10);
      if (which != 3) {
        text("Tested with Sodium Hydroxide (Sample 1)",0, - 40);
      } else {
        if (ammon) {
          text("Tested with Ammonia (Sample 1)",0, - 40);} else {text("Tested with Ammonium Hydroxide (Sample 1)",0, - 40);}
      }
      if (which == 5) {
        fill(0);  
        textSize(20);
        text(preci[wdisp[4]],0, - 25);
        text(solub[wdisp[5]],0, - 5);

        textSize(10); 
        if (ammon) {text("Tested with Ammonia (Sample 2)",0,15);} else {text("Tested with Ammonium Hydroxide (Sample 2)",0,15);}
      }
        
      textSize(10);
      textAlign(RIGHT,BOTTOM);
      fill(0);
      text("Photocopied for ISD Ispection",190,150);
      rotate(-radians(rot[0]));
      translate(-px,-py);
    }
    }
}
