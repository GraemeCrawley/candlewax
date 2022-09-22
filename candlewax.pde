/**
 * Forces (Gravity and Fluid Resistence) with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of multiple force acting on bodies (Mover class)
 * Bodies experience gravity continuously
 * Bodies experience fluid resistance when in "water"
 */

class WaxDroplet {

  // position, velocity, and acceleration 
  PVector position;
  PVector velocity;
  PVector acceleration;

  // Mass is tied to size
  float mass;
  float leftover;
  float coeff_fric;
  float temperature;
  WaxDroplet previous;
  float delay;
  
  
  // A PShape that will group PShapes
  PShape group = createShape(GROUP);
  PShape streamGroup = createShape(GROUP);
  PShape circle;
  PShape triangle;
  float scale_mass;

  WaxDroplet(float m, float x, float y, float d) {
    mass = m;
    coeff_fric = 0.08;
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    temperature = 100;
    previous = null;
    delay = d;
    
    circle = createShape(ELLIPSE, 0, 0, radius, radius);
    triangle = createShape(TRIANGLE, -2.3, 0, 2.3, 0, 0, -7);
    group.addChild(circle);
    group.addChild(triangle);
    scale_mass = scale_factor*mass;
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }
  
  void update(){
    if (delay < 0){
      update_shape();
    } else {
      delay = delay - 0.05;
    }
  }

  void update_shape() {
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // Leave some of the mass behind
    if (mass > 0.05 && velocity.y > 0 && temperature > 0) {
      leftover = velocity.y * 0.001;
      mass = mass - leftover * mass;
      temperature = temperature - 0.01;
      // position changes by velocity
      position.add(velocity);
      
    }
    // We must clear acceleration each frame
    acceleration.mult(0);
    println("Mass: " + mass);
    println("Temp: " + temperature);
    println("Acceleration: " + acceleration);
    println("Velocity: " + velocity);
    println("Position: " + position);
    
    scale_mass = scale_factor*mass;
    
    PShape circle = createShape(ELLIPSE, position.x, position.y, radius*scale_mass*0.9, radius*scale_mass*0.9);
    streamGroup.addChild(circle);    
    shape(streamGroup);
    
  }

  // Draw Mover
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    scale(scale_mass);
    group.setStrokeWeight(2);
    shape(group);
    popMatrix();
    
    
  }

  // Stop at bottom of window
  void checkEdges() {
    if (position.y -10 > height) {
      velocity.y *= -0.9;  // A little dampening when hitting the bottom
      position.y = height;
    }
  }
}

/**
 * Forces (Gravity and Fluid Resistence) with Vectors
 * by Daniel Shiffman.
 *
 * Demonstration of multiple forces acting on bodies.
 * Bodies experience gravity continuously and fluid
 * resistance when in "water".
 */

// moving bodies
int num_drops = 30;
WaxDroplet[] wax_droplets = new WaxDroplet[num_drops];

int r = 100;
int g = 50;
int b = 255;

float mass_min = 0.5;
float mass_max = 4;
float radius = 5;
float scale_factor = 3;
color c = color(50, 50, 255);


void setup() {
  shapeMode(CENTER);
  noStroke();
  fill(c);
  background(0);
  size(600, 800);
  reset();
}

void draw() {
  background(0);
  //println(wax_droplets.length);
  for (WaxDroplet wax_droplet : wax_droplets) {

    // Gravity is scaled by mass here!
    PVector gravity = new PVector(0, 0.005*wax_droplet.mass);
    float viscosity = 0.2*wax_droplet.temperature/(wax_droplet.mass*80);
    PVector friction = new PVector(0, -1 * (wax_droplet.coeff_fric*viscosity));
    //println("Friction: " + friction);
    //println("Gravity: " + gravity);
    // Apply gravity
    wax_droplet.applyForce(friction);
    wax_droplet.applyForce(gravity);

    // Update and display
    wax_droplet.update();
    wax_droplet.display();
    wax_droplet.checkEdges();
  }
  text("click mouse to reset", 10, 30);
}

void mousePressed() {
  reset();
}

// Restart all the Mover objects randomly
void reset() {
  background(0);
  for (int i = 0; i < wax_droplets.length; i++) {
    float channel_width = width/num_drops;
    wax_droplets[i] = new WaxDroplet(random(mass_min, mass_max), random(i*channel_width, channel_width*i+channel_width), -30, random(0,20));
  }
}
