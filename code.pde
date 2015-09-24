/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList bots;
String[] metal = {"Zinc", "Aluminium", "Iron(II)", "Iron(III)", "Copper", "Chromium", "Calcium", "Ammonium"};
String[] preci = {"No Precipitates", "Has Precipitates"};
String[] solub = {"Dissolves", "Does not Dissolve"};
String[] pncolr = {"Dirty Green", "Brown", "Blue", "Grey Green", "White", "None"};
color[] pcolr = {color(59,70,45), color(64,29,6), color(123,209,221), color(87,100,87), color(255), color(255,0)};

float decox = 0;
float decoy = 0;

// Metal, Precipitate in NaOH, Dissolve in excess NaOH, Colour of Precipitate in NaOH, Precipitate in (NH3)/(NH4)OH, Dissolve in excess (NH3)/(NH4)OH, Colour of Precipitate in (NH3)/(NH4)OH.

int[] c_zinc = {0, 1, 0, 4, 1, 0, 4};

int[] c_alum = {1, 1, 0, 4, 1, 1, 4};

int[] c_iron_a = {2, 1, 1, 0, 1, 1, 0};

int[] c_iron_b = {3, 1, 1, 1, 1, 1, 1};

int[] c_copp = {4, 1, 1, 2, 1, 1, 2};

int[] c_chro = {5, 1, 0, 3, 1, 0, 3};

int[] c_calc = {6, 1, 1, 4, 0, 0, 5};

int[] c_ammo = {7, 0, 0, 5, 0, 0, 5};

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    bots = new ArrayList();
    //textFont(myfont);
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
    translate(decox,decoy);
    fill(225);
    stroke(0);
    rect(-width,-height,width*3,height*3);
    for (int i=bots.size()-1; i>=0; i--) {
        Particle b = (Bot) bots.get(i);
        b.update(i);
    }
    pwidth = width;
    pheight = height;
    translate(-decox,-decoy);
}

void mousePressed() {
    bots.add(new Bot());
}

void mouseDragged() {
    decox += mouseX - pmouseX;
    decoy += mouseY - pmouseY;
}

class Bot {
    float x;
    float y;
    int id;
    int fid;
    int which;
    boolean notcert;
    boolean ammon;
    int[] choiceval;
    int[] corval;
    int[] wdisp;
    boolean fake;

    Bot() {
      x = random(-width,width*2);
      y = random(-height,height*2);
      choiceval = chance.pick([c_zinc, c_alum, c_iron_a, c_iron_b, c_copp, c_chro, c_calc, c_ammo]);
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

    void update(cid) {
        id = cid;
        
        if (wdisp[3] == corval[3]) {stroke(0);} else {stroke(255,0,0);}
        fill(pcolr[wdisp[3]]);
        rect(x-20,y-20,40,40);
        
        if (which == 5) {
          if (wdisp[6] == corval[6]) {stroke(0);} else {stroke(255,0,0);}
          fill(pcolr[wdisp[6]]);
          ellipse(x,y,20,20);
        }
        
        translate(-decox,-decoy);
        if ((mouseX - decox).between(x-20,x+20) && (mouseY - decoy).between(y-20,y+20)) {
          textAlign(LEFT,TOP);
          textSize(50);    
            
          if (wdisp[0] == corval[0]) {fill(0);} else {fill(255,0,0);}
          text(metal[wdisp[0]],0,0);
            
          textSize(20);
          if (wdisp[1] == corval[1]) {fill(0);} else {fill(255,0,0);}
          text(" - " + preci[wdisp[1]],0,50);
            
          if (wdisp[2] == corval[2]) {fill(0);} else {fill(255,0,0);}
          text(" - " + solub[wdisp[2]],0,70);
            
          textSize(10);
          if (which != 3) {
            text("Tested with Sodium Hydroxide",0,90);
          } else {
            if (ammon) {
              text("Tested with Ammonia",0,90);} else {text("Tested with Ammonium Hydroxide",0,90);}
          }
          if (which == 5) {
            textSize(20);
            if (wdisp[4] == corval[4]) {fill(0);} else {fill(255,0,0);}
            text(" - " + preci[wdisp[4]],0,120);
              
            if (wdisp[5] == corval[5]) {fill(0);} else {fill(255,0,0);}
            text(" - " + solub[wdisp[5]],0,140);

            textSize(10);
            if (ammon) {text("Tested with Ammonia",0,160);} else {text("Tested with Ammonium Hydroxide",0,160);}
            if (notcert) {text("Not enough documents.",0,170);}
          } else {
            textSize(10);
            fill(255,0,0);
            if (notcert) {text("Not enough documents.",0,100);}
          }
        }
        translate(decox,decoy);
    }
}
