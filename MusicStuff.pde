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
}

void draw()
{
  // noCursor();
  smooth();
  background (0);

  float halfH = height / 2;
  float halfW = width / 2;

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

  ellipse(halfW, halfH, lerpedAverage * halfH, lerpedAverage * halfH);
}
