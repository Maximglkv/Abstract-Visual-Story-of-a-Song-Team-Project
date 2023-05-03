import peasy.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
AudioBuffer buffer;
AudioInput ai;

PeasyCam cam;

PVector[][] globe;
int total = 20;

float lerpedAverage = 0;
float[] lerpedBuffer;

void setup()
{
  fullScreen(P3D);

  colorMode(HSB);
  //load minim library
  minim = new Minim(this);
  //loads song
  player = minim.loadFile("song.mp3", width);
  //plays the song
  player.play();
  ai = minim.getLineIn(Minim.MONO, width, 44100, 16);
  buffer = player.left;

  lerpedBuffer = new float[buffer.size()];
  
  globe = new PVector[total+1][total+1];
}

void draw()
{
  // noCursor();
  smooth();
  background (0);
  lights();

  //float halfH = height / 2;
  //float halfW = width / 2;

  strokeWeight(1);

  for (int i = 0; i < buffer.size(); i ++)
  {

    stroke(0, map(i, 0, buffer.size(), 0, 255), map(i, 0, buffer.size(), 0, 255));
    lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.05f);
    float sample = lerpedBuffer[i] * width * 0.3;
    float sample2 = lerpedBuffer[i] * height * 10;

    //old code from example
    // stroke(map(i, 255, buffer.size(), 0, 255), 255, 255);
    // line(i, height / 2 - sample, i, height/2 + sample);

    //top lines
    line(i, height - sample, i, height + sample);
    //bottom lines
    line(i, 0 - sample, i, 0 + sample);

    stroke(0, 255, 255);
    //left line
    line(0, 0 - sample2, 0, height + sample2);
    //right line
    line(width, 0 - sample2, width, height + sample2);
  }

  float sum = 1000;
  for (int i = 0; i < buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }

  noStroke();
  fill(map(lerpedAverage, 1, 1, 0, 255), 0, 255);
  float average = sum / buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);

 translate(width / 2, height/2);
 float r = 300;
  for (int i = 0; i < total+1; i++)
  {
    float latitude = map(i, 0, total, 0, PI);
    for (int j = 0; j < total+1; j++)
    {
      float longitude = map(j, 0, total, 0, TWO_PI);
      float x = r * sin(latitude) * cos(longitude);
      float y = r * sin(latitude) * sin(longitude);
      float z = r * cos(latitude);
      globe[i][j] = new PVector(x, y, z);
    }
  }
  for (int i = 0; i < total; i++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++)
    {
      PVector v1 = globe[i][j];
      stroke(255);
      strokeWeight(5);
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}
