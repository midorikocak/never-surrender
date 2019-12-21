String words[]; //<>//
PFont font;

import ddf.minim.*;
import ddf.minim.analysis.*;

Table table;
Minim minim;
AudioPlayer song;
int x, y;

PImage img;


void setup() {
img = loadImage("calm.png");

  font = loadFont("CaslonsEgyptian-Regular-32.vlw");
  textFont(font, 32);
  minim = new Minim(this);
  song = minim.loadFile("speech.mp3", 1024);
  song.play();

  words = loadStrings("speech.txt");
  table = loadTable("convertcsv.csv", "header");
  size(1280, 720);
  background(255, 0, 0);
}

float lyrics(int topShift, float currentTime) {
  fill(255);
  float indent = 160;
  float offset = 160;
  int i = 0;
  println(table.getRowCount() + " total rows in table");

  String previousWord = "";
  String word = "";
  float previousStart = 0;
  float previousEnd = 0;
  float kerning = 0;
  float maxKern = 0;
  float end = 0;
  float start = 0;

  for (TableRow row : table.rows()) {
    start = row.getFloat("start")*1000;
    end = row.getFloat("end")*1000;
    word = row.getString("word");
    kerning = row.getFloat("start")*1000 - previousEnd;
    previousEnd = end;
    maxKern = maxKern <= kerning ? kerning : maxKern;
  }

  previousStart = 0;
  previousEnd = 0;
  previousWord = "";

  println(maxKern);

  for (TableRow row : table.rows()) {


    start = row.getFloat("start")*1000;
    end = row.getFloat("end")*1000;
    word = row.getString("word").toUpperCase();
    kerning = row.getFloat("start")*1000 - previousEnd;

    float shift = (kerning / maxKern) * 100;

    if (indent>800 || shift>20) {
      indent = 160;
      offset += 40;
    } 
    
    indent += i==0 ? 0 : textWidth(previousWord) + shift + 10;

    //println(indent);
    if (start<currentTime) {
      if (offset>600) {
        offset = 200;
        background(255, 0, 0);
      }
      text(word, indent, offset + topShift);
    }
    i++;
    previousWord = word;
    previousStart = start;
    previousEnd = end;
  }
  return indent;
}

void draw() {

  background(255, 0, 0);

  fill(255);

  println(lyrics(0, millis()-650));
  float imgWidth = 600/8;
  float imgHeight = 518/8;
    image(img, width /2 - (imgWidth/2), 50, imgWidth, imgHeight);
  //text(millis(), width>>1, height>>1);
}
