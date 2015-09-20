/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList bots;
String[] metal = {"Zinc", "Aluminium", "Iron(II)", "Iron(III)", "Copper", "Chromium", "Calcium", "Ammonium"};
String[] preci = {"No Precipitates", "Has Precipitates"};
String[] solub = {"Dissolves", "Does not Dissolve"};
String[] pncolr = {"Dirty Green", "Brown", "Blue", "Grey Green", "White", "None"};
color[] pcolr = {color(59,70,45), color(64,29,6), color(123,209,221), color(87,100,87), color(255), color(255,0)};

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
    for (int i=bots.size()-1; i>=0; i--) {
        Particle b = (Bot) bots.get(i);
        b.update(i);
    }
    pwidth = width;
    pheight = height;
}

void mousePressed() {
    
}

class Bot {
    float x;
    float y;
    int id;
    int fid;
    int[] corval;
    int[] wdisp;
    boolean fake;

    Bot() {
      x = width/2;
      y = height/2;
      corval = chance.pick([c_zinc, c_alum, c_iron_a, c_iron_b, c_copp, c_chro, c_calc, c_ammo]);
      int which = chance.pick([0,3]);
      wdisp = {
          chance.pick([corval[0], 100]), 
          chance.pick([corval[4 - which], 100]),
          chance.pick([corval[5 - which], 100]),
          chance.pick([corval[6 - which], 100])
      
      };
      if (random(1) > 0) {
        fake = true;
        int fakeval = round(random(3));
        int newval = wdisp[fakeval] + round(random(-2,2));
        switch(fakeval) {
            case 0:
              newval = constrain(wdisp[0],0,7);
              break;
            case 1:
              newval = constrain(wdisp[1],0,1);
              break;
            case 2:
              newval = constrain(wdisp[2],0,1);
              break;
            case 3:
              newval = constrain(wdisp[3],0,5);
              break;
        }
        if (newval == wdisp[fakeval]) {fake = false;} else {wdisp[fakeval] = newval;}
      }
    };

    void kill() {

    }

    void update(cid) {
        id = cid;
        x += random(-1,1);
        y += random(-1,1);
        fill(pcolr[wdisp[3]]);
        rect(x-10,y-10,20,20);
        if (fake) {fill(255,0,0);} else {fill(0)};
        if (mouseX.between(x-10,x+10) && mouseY.between(y-10,y+10)) {
          textAlign(LEFT,TOP);
          textSize(50);
          if (wdisp[0] == 100) {
            text(chance.string(),mouseX,mouseY);
          } else {
            text(metal[wdisp[0]],mouseX,mouseY);
          }
          textSize(20);
          if (wdisp[1] == 100) {
            text(chance.string(),mouseX,mouseY + 50);
          } else {
            text("- " + preci[wdisp[1]],mouseX,mouseY + 50);
          }
          textSize(20);
          if (wdisp[2] == 100) {
            text(chance.string(),mouseX,mouseY + 70);
          } else {
            text("- " + solub[wdisp[2]],mouseX,mouseY + 70);
          }
          textSize(20);
          if (wdisp[3] == 100) {
            text(chance.string(),mouseX,mouseY + 90);
          } else {
            text("- " + pncolr[wdisp[3]],mouseX,mouseY + 90);
          }
        }
    }
}
