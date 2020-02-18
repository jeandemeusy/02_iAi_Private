import processing.pdf.*;

void setup() {
  size(960, 600);
  //fullScreen();
  
  //beginRecord(PDF, "collatz.pdf"); // De-commente pour enregistrer en pdf. Regarde plus bas
  background(0);             // couleur du fond
  strokeWeight(1);           // epaisseur d'un trait
  colorMode(HSB, 100);
  
  float len = height/120.0;  // longueur d'un trait
  float angle = 0.15;        // tilt de +angle si valeur pair, sinon -angle
  int max_it = 1000;         // valeur max pour laquelle une sequence est générée
  int n = 0;
  
  for (int i = 1; i < max_it; i++) {
    IntList sequence = new IntList();
    n = i;

    while (n != 1) {
      sequence.append(n);
      n = collatz(n);
    }

    sequence.append(1);

    resetMatrix();
    translate(width/2, height);

    for (int j = sequence.size()-1; j >=0; j--) {
      int value = sequence.get(j);
      if (value % 2 == 0)  rotate( angle);
      else                 rotate(-angle);

      stroke(80.*i/max_it + 10, 80, 100,3);  // couleur en HSV
      line(0, 0, 0, -len);
      translate(0, -len);
    }
  }
  //endRecord(); // De-commente pour enregistrer en pdf.
}

int collatz(int n) {
  if (n % 2 == 0)  return n / 2;
  else             return (n * 3 + 1)/2;
}
