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

  WaxDroplet(float m, float x, float y) {
    mass = m;
    coeff_fric = 0.08;
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    temperature = 100;
    previous = null;
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }

  void update() {
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // Leave some of the mass behind
    if (mass > 0.05 && velocity.y > 0 && temperature > 0) {
      leftover = velocity.y * 0.001;
      mass = mass - leftover * mass;
      temperature = temperature - mass*0.9/temperature*0.6;
      // position changes by velocity
      position.add(velocity);
      
    }
    // We must clear acceleration each frame
    acceleration.mult(0);
    //println("Mass: " + mass);
    //println("Temp: " + temperature);
    //println("Acceleration: " + acceleration);
    //println("Velocity: " + velocity);
    //println("Position: " + position);
    
    WaxDroplet w = new WaxDroplet(mass*0.8, position.x, position.y);
    
    if (previous == null){
      previous = w;
    } else {
      w.previous = previous;
      previous = w;
    }
  }

  // Draw Mover
  void display() {
    stroke(100, 50, 255);
    strokeWeight(2);
    fill(100, 50, 255);
    ellipse(position.x, position.y, mass*10, mass*10);
    triangle(position.x - mass*5, position.y, position.x + mass*5, position.y, position.x, position.y - mass*40);
    if (previous != null){
      previous.display();
    }
  }

  // Bounce off bottom of window
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

// Five moving bodies
int num_drops = 40;
WaxDroplet[] wax_droplets = new WaxDroplet[num_drops];

void setup() {
  size(800, 800);
  background(0);
  reset();
}

void draw() {
  background(0);

  //println(wax_droplets.length);
  for (WaxDroplet wax_droplet : wax_droplets) {

    // Gravity is scaled by mass here!
    PVector gravity = new PVector(0, 0.01*wax_droplet.mass);
    float viscosity = 0.09*wax_droplet.temperature/(wax_droplet.mass*150);
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
  
  fill(255);
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
    wax_droplets[i] = new WaxDroplet(random(0.5, 4), random(i*channel_width, channel_width*i+channel_width), -10);
  }
}
