#include <AceButton.h>
using namespace ace_button;

const int BUTTON_UP_PIN = 4;
const int BUTTON_DOWN_PIN = 2;
const int BUTTON_TRIGGER_PIN = 7;

const int LED_IND_PIN = 11;
const int LED_STR_1 = 3;
const int LED_STR_2 = 5;
const int LED_STR_3 = 6;
const int LED_STR_4 = 9;
const int LED_STR_5 = 10;

const int RELAY_PIN = 8;

const int LED_ON = 10;
const int LED_OFF = 0;
const int IND_ON = LED_ON / 4;

const int RELAY_ON = LOW;
const int RELAY_OFF = HIGH;

const int MIN_PULSE= 100;
const int MAX_PULSE = 300;

const int IND_STEP = (MAX_PULSE - MIN_PULSE) / 5;
const int PULSE_STEP = 10;

const int IND_FLASH = 150;
const long SAFETY_LOCKOUT = 1500; // ms


unsigned long pulse; // in ms
bool locked;
unsigned long unlockAt; // future time when the SAFETY_LOCKOUT will release.

unsigned long flashStart;
int flashCycle; // Stuck here because stack is costly.
int currentFlashCycle;

ButtonConfig triggerConfig;

AceButton buttonUp(BUTTON_UP_PIN);
AceButton buttonDown(BUTTON_DOWN_PIN);
AceButton buttonTrigger(&triggerConfig);

void handleEvent(AceButton*, uint8_t, uint8_t);

void setup() {
  Serial.begin(9600);
  // Setup indicator flash state.
  flashStart = 0;
  flashCycle = -1;
  currentFlashCycle = -1;

  // Setup Default Pulse
  setPulse(MIN_PULSE + 50);

  // Setup the outputs
  pinMode(LED_STR_1, OUTPUT);
  pinMode(LED_STR_2, OUTPUT);
  pinMode(LED_STR_3, OUTPUT);
  pinMode(LED_STR_4, OUTPUT);
  pinMode(LED_STR_5, OUTPUT);
  
  digitalWrite(RELAY_PIN, RELAY_OFF);
  pinMode(RELAY_PIN, OUTPUT);

  // Setup the inputs
  pinMode(BUTTON_UP_PIN, INPUT_PULLUP);
  pinMode(BUTTON_DOWN_PIN, INPUT_PULLUP);
  pinMode(BUTTON_TRIGGER_PIN, INPUT_PULLUP);

//  triggerConfig.setDebounceDelay(1000);
  
  buttonUp.setEventHandler(handleEvent);
  buttonDown.setEventHandler(handleEvent);

  buttonTrigger.init(BUTTON_TRIGGER_PIN);
  buttonTrigger.setEventHandler(handleEvent);

  // Signal that we're up and ready.
  pinMode(LED_IND_PIN, OUTPUT);
  analogWrite(LED_IND_PIN, IND_ON);

  unlockAt = millis();
  locked = false;
  
  Serial.println("Ready:");
}

void loop() {
  int now = millis();
  if (locked && now > unlockAt) {
    locked = false;
    analogWrite(LED_IND_PIN, IND_ON);
  }
  
  buttonUp.check();
  buttonDown.check();
  if (!locked) {
    buttonTrigger.check();
  }

  if (flashStart != 0) {
    flashCycle = (now - flashStart) / IND_FLASH;
    // -1 = NA, 0 = OFF, 1 = ON, 2 = OFF, 3 = ON, 4 = OFF, 5 = ON, 6 = RESET
    if (flashCycle != currentFlashCycle && flashCycle >= 0 && flashCycle <= 5) {
      switch(flashCycle % 2) {
        case 0: {
          analogWrite(LED_IND_PIN, LED_OFF);
          break;
        }
        case 1: {
          analogWrite(LED_IND_PIN, IND_ON);
          break;
        }
      }
    } else if (flashCycle >= 6) {
      flashStart = 0;
      flashCycle = -1;
      currentFlashCycle = -1;
    }
  }
}

void setPulse(long p) {
  pulse = constrain(p, MIN_PULSE, MAX_PULSE);
  if (pulse == MAX_PULSE || pulse == MIN_PULSE) {
    flashStart = millis();
  }
  Serial.print("Pulse: ");
  Serial.println(pulse);

  Serial.print("Indicators: ");
  Serial.print(getValueForIndicator(1));
  Serial.print(" ");
  Serial.print(getValueForIndicator(2));
  Serial.print(" ");
  Serial.print(getValueForIndicator(3));
  Serial.print(" ");
  Serial.print(getValueForIndicator(4));
  Serial.print(" ");
  Serial.println(getValueForIndicator(5));
  
  
  // calculate the pulse value within range of the given LED.
  // constrain the value between 0 and IND_STEP.
  // Fully lit LEDs will have very high numbers that get constrained.
  // map the resulting constrained value from 0 - LED_ON for the PWM duty cycle.
  analogWrite(LED_STR_1, getValueForIndicator(1));
  analogWrite(LED_STR_2, getValueForIndicator(2));
  analogWrite(LED_STR_3, getValueForIndicator(3));
  analogWrite(LED_STR_4, getValueForIndicator(4));
  analogWrite(LED_STR_5, getValueForIndicator(5));
}

int getValueForIndicator(int led) {
  int value = pulse - (MIN_PULSE + (led - 1) * IND_STEP);
  return map(constrain(value, 0, IND_STEP), 0, IND_STEP, 0, LED_ON);
}

void handleEvent(AceButton* btn, uint8_t eventType, uint8_t buttonState) {
  switch (eventType) {
    case AceButton::kEventPressed: {
      if (btn == &buttonUp) {
        setPulse(pulse + PULSE_STEP);
      } else if (btn == &buttonDown) {
        setPulse(pulse - PULSE_STEP);
      } else if (btn == &buttonTrigger) {
        locked = true;
        analogWrite(LED_IND_PIN, LED_OFF);

        // Fire!
        digitalWrite(RELAY_PIN, RELAY_ON);
        delay(pulse);
        digitalWrite(RELAY_PIN, RELAY_OFF);
        
        unlockAt = millis() + SAFETY_LOCKOUT;
      }
      break;
    }
  }
}
