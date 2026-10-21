#include <Servo.h>

// Pin connections
const int trigPin = 9;
const int echoPin = 10;
const int servoPin = 11;
const int ledPin = 7;
const int buzzerPin = 6;

Servo radarServo;

unsigned long lastAlertTime = 0;
bool alertOn = false;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);

  radarServo.attach(servoPin);
  Serial.begin(9600);
}

void loop() {
  // Scan left to right
  for (int angle = 15; angle <= 165; angle++) {
    scan(angle);
  }

  // Scan right to left
  for (int angle = 165; angle >= 15; angle--) {
    scan(angle);
  }
}

// Move sensor, measure distance, and update alerts
void scan(int angle) {
  radarServo.write(angle);
  delay(40);

  int distance = getDistance();

  // Send angle and distance to Processing
  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");

  updateAlert(distance);
}

// Measure distance using the ultrasonic sensor
int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);

  if (duration == 0) {
    return 50;
  }

  return duration * 0.034 / 2;
}

// Flash LED and beep faster when objects get closer
void updateAlert(int distance) {
  if (distance > 0 && distance < 40) {
    int interval = distance * 6;

    if (millis() - lastAlertTime >= interval) {
      lastAlertTime = millis();
      alertOn = !alertOn;

      digitalWrite(ledPin, alertOn);
      digitalWrite(buzzerPin, alertOn);
    }
  } else {
    alertOn = false;
    digitalWrite(ledPin, LOW);
    digitalWrite(buzzerPin, LOW);
  }
}
