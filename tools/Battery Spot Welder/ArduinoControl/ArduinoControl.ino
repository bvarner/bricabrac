#include <AceButton.h>
using namespace ace_button;
const int LED_PIN = 5;
const int RELAY_PIN = 8;

const int BUTTON_UP_PIN = 3;
const int BUTTON_DOWN_PIN = 2;
const int BUTTON_TRIGGER_PIN = 4;

const int LED_ON = HIGH;
const int LED_OFF = LOW;

const int RELAY_ON = LOW;
const int RELAY_OFF = HIGH;

unsigned long triggerTime; // in ms

ButtonConfig triggerConfig;

AceButton buttonUp(BUTTON_UP_PIN);
AceButton buttonDown(BUTTON_DOWN_PIN);
AceButton buttonTrigger(&triggerConfig);

void handleEvent(AceButton*, uint8_t, uint8_t);

void setup() {
  triggerTime = 150; // ms
  pinMode(LED_PIN, OUTPUT);
  analogWrite(LED_PIN, delayDuty());
  
  digitalWrite(RELAY_PIN, RELAY_OFF);
  pinMode(RELAY_PIN, OUTPUT);
  
  pinMode(BUTTON_UP_PIN, INPUT_PULLUP);
  pinMode(BUTTON_DOWN_PIN, INPUT_PULLUP);
  pinMode(BUTTON_TRIGGER_PIN, INPUT_PULLUP);

//  triggerConfig.setDebounceDelay(1000);
  
  buttonUp.setEventHandler(handleEvent);
  buttonDown.setEventHandler(handleEvent);

  buttonTrigger.init(BUTTON_TRIGGER_PIN);
  buttonTrigger.setEventHandler(handleEvent);
}

void loop() {
  buttonUp.check();
  buttonDown.check();
  buttonTrigger.check();
}

int delayDuty() {
  // scale triggerTime so that the clamped value (100 to 300) scales between 0 and 255.
  double curPercent = (triggerTime - 100) / 2; // subtract 100 and divide by 2...
  // Apply the percentage.
  return 255 * (curPercent / 100);
}

void handleEvent(AceButton* btn, uint8_t eventType, uint8_t buttonState) {
  switch (eventType) {
    case AceButton::kEventPressed: {
      if (btn == &buttonUp) {
        triggerTime = min(triggerTime + 25, 300);
        if (triggerTime == 300) {
          flash();
        }
        analogWrite(LED_PIN, delayDuty());
      } else if (btn == &buttonDown) {
        triggerTime = max(triggerTime - 25, 100);
        if (triggerTime == 100) {
          flash();
        }
        analogWrite(LED_PIN, delayDuty());
      } else if (btn == &buttonTrigger) {
        digitalWrite(RELAY_PIN, RELAY_ON);
        delay(triggerTime);
        digitalWrite(RELAY_PIN, RELAY_OFF);
      }
      break;
    }
  }
}

void flash() {
    for (int i = 0; i < 3; i++) {
      analogWrite(LED_PIN, 255);
      delay(250);
      analogWrite(LED_PIN, 0);
      delay(250);
    }  
}

