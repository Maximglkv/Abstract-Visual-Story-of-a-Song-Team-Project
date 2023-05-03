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
float x = 0;

void setup()
{
  fullScreen(P3D);
  
  colorMode(RGB);
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
  background(0);
  
 float halfH = height / 2;
 float halfW = width / 2;

  strokeWeight(1);
  
  for (int i = 0; i < buffer.size(); i ++)
  {

   // stroke(map(i, 0, buffer.size(), 0, 255), 255, 255);
   lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.1f);
    float sample = lerpedBuffer[i] * width * 0.5;
    stroke(map(i, 255, buffer.size(), 0, 255), 255, 255);
    line(i, height / 2 - sample, i, height/2 + sample);
  }
  
  float sum = 1000;
  for (int i = 0; i < buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }

  noStroke();
  fill(map(lerpedAverage, 0, 1, 0, 255), 255, 255);
  float average = sum / buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  
  if (x > width - 10)
  {
    x =  - 10;
  }
    
  ellipse(halfW, halfH, lerpedAverage * halfH, lerpedAverage * halfH);
  
}
