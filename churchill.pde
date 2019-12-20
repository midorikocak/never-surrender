String words[];

import ddf.minim.*;
import ddf.minim.analysis.*;

Table table;
Minim minim;
AudioPlayer song;
int x, y;

void setup() {
  minim = new Minim(this);
  song = minim.loadFile("speech.mp3", 1024); //<>//
  song.play();

  words = loadStrings("speech.txt");
  table = loadTable("convertcsv.csv", "header");
  size(640, 360);
  background(255);
}

float lyrics(int topShift, float currentTime) {
  fill(0);
  float indent = 20;
  float offset = 20;
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
    word = row.getString("word");
    kerning = row.getFloat("start")*1000 - previousEnd;

    float shift = (kerning / maxKern) * 100;
    if (indent>550 || shift>20) {
      indent = 0;
      offset += 20;
    }

    indent += i == 0 ? 20 : textWidth(previousWord) + shift + 5;
    indent = indent > 640 ? 0 : indent;
    //println(indent);
    textSize(16);
    if (start<currentTime) {
      if (offset>340) {
        offset = 20;
        background(255);
      }
      text(word, indent, offset + topShift);
    }
    i++;
    previousWord = word;
    previousStart = start;
    previousEnd = end;
  }
  return offset;
}

void draw() {

  background(255);

  fill(0);
  textSize(32);
  println(lyrics(0, millis()));
  //text(millis(), width>>1, height>>1);
}
