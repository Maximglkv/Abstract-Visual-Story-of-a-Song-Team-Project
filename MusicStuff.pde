//Minim Library
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

//arrays
PVector[][] globe;
float[] lerpedBuffer;

//global variables
float lerpedAverage = 0;
int total = 12;
float n4;
float n6;
int which = 0;

void setup()
{
  //fullscreen mode
  fullScreen(P3D);
  smooth();
  //color model
  colorMode(RGB);

  //load minim library
  minim = new Minim(this);

  //loads song
  player = minim.loadFile("song.mp3", width);

  //plays the song
  //player.play();

  ai = minim.getLineIn(Minim.MONO, width, 44100, 16);
  buffer = player.left;

  lerpedBuffer = new float[buffer.size()];

  //Vector array, +1 so it connects fully or theres a gap in it.
  globe = new PVector[total+1][total+1];
}

void draw()
{
 // noCursor();
  smooth();
  background (0);
  lights();

  strokeWeight(1);

  //for loop
  //top and bottom reactive waves
  for (int i = 0; i < buffer.size(); i ++)
  {
    stroke(map(i, 235, buffer.size(), 0, 0),map(i, 253, buffer.size(), 255, 183), 255);
    lerpedBuffer[i] = lerp(lerpedBuffer[i], buffer.get(i), 0.05f);
    float sample = lerpedBuffer[i] * width * 0.3;
    float sample2 = lerpedBuffer[i] * width * 0.2;

    //old code from example
    // stroke(map(i, 255, buffer.size(), 0, 255), 255, 255);
    // line(i, height / 2 - sample, i, height/2 + sample);

    //top lines
    line(i, height - sample, i, height + sample);
    //bottom lines
    line(i, 0 - sample, i, 0 + sample);
    
    stroke(255,255,255);
    //2nd underneath it
    //top lines
    line(i, height - sample2, i, height + sample2);
    //bottom lines
    line(i, 0 - sample2, i, 0 + sample2);

    //left line
    //line(0, 0 - sample2, 0, height + sample2);
    //right line
    //line(width, 0 - sample2, width, height + sample2);
  }

  //controls size of sphere
  float sum = 400;

  for (int i = 0; i < buffer.size(); i ++)
  {
    sum += abs(buffer.get(i));
  }
  //end of top and bottom reactive waves


  //reactive sphere code starts here
  noStroke();
  fill(map(lerpedAverage, 1, 1, 0, 255), 0, 255);
  float average = sum / buffer.size();
  lerpedAverage = lerp(lerpedAverage, average, .5f);

  //translate used to move sphere to centre of screen
  translate(width / 2, height/2);

  //variable for radius of sphere
  float r = 300;

  for (int i = 0; i < total+1; i++)
  {
    float latitude = map(i, 0, total, 0, PI);

    //for loop
    for (int j = 0; j < total+1; j++)
    {
      //variables + formula, creating a sphere using vectors
      float longitude = map(j, 0, total, 0, TWO_PI);
      float x = r * sin(latitude*lerpedAverage) * cos(longitude);
      float y = r * sin(latitude*lerpedAverage) * sin(longitude);
      float z = r * cos(latitude);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  //for loop to make the vectors connect to each point and form a shape,
  //currently has noFill so won't show until its removed.
  for (int i = 0; i < total; i++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++)
    {
      noFill();
      PVector v1 = globe[i][j];
      stroke(map(i, 235, buffer.size(), 0, 0),map(i, 253, buffer.size(), 255, 183), 255);
      strokeWeight(5);
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
  //reactive sphere code ends here
  
  
  //ellipse and rect shooting out from the middle starts here
  //noStroke needed or its just a bunch of white boxes and ellipses
  noStroke();

  //for loop for repeat ellipse and rect cmds
  for (int i = 0; i < player.bufferSize() - 1; i++)
  {
    //variables + formula
    float angle = sin(i+n4)* 10;
    float angle2 = sin(i+n6)* 300;

    float b = sin(radians(i))*(angle2+30);
    float n = cos(radians(i))*(angle2+30);

    float x3 = sin(radians(i))*(500/angle);
    float y3 = cos(radians(i))*(500/angle);

    //greyer grey
    fill (#BFBFBF, 67, 67);
    ellipse(b, n, player.left.get(i)*10, player.left.get(i)*5);

    //cyan
    fill (#00FFFF);
    ellipse(x3, y3, player.left.get(i)*10, player.left.get(i)*10);

    //white
    fill (#FFFFFF);
    rect(b, n, player.right.get(i)*10, player.left.get(i)*10);

    //white
    fill(#FFFFFF);
    ellipse(x3, y3, player.right.get(i)*10, player.right.get(i)*10);
  }

  //increment values
  n4 += 0.008;
  n6 += 0.04;
  //ellipse and rect shooting out from the middle ends here
}

//start and play button
void keyPressed()
{

  if (keyCode == ' ')
  {
    if ( player.isPlaying() )
    {
      player.pause();
    } else
    {
      player.rewind();
      player.play();
    }
  }
}
//end of start and play button
