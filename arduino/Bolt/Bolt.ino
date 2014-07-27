#include <PololuLedStrip.h>

PololuLedStrip<12> ledStrip;

#define LED_COUNT 60
rgb_color colors[LED_COUNT];

String command = "";
boolean enabled = false;

void setup()
{
  disable();
  Serial.begin(115200);
  Serial.println("Ready to receive commands.");
}

void loop()
{
  if (Serial.available())
  {
    command = Serial.readStringUntil('\n');
    command.trim();

    if (command == "enable")
    {
      enable();
    }
    else if (command == "disable")
    {
      disable();
    }
    else if (command == "enabled?")
    {
      Serial.write(enabled);
    }
    else
    {
      Serial.write("ERROR: Unknown command");
    }
  }
}

void enable()
{
  rgb_color color;
  color.red = 255;
  color.green = 255;
  color.blue = 255;
  setColor(color);

  enabled = true;
}

void disable()
{
  rgb_color color;
  color.red = 0;
  color.green = 0;
  color.blue = 0;
  setColor(color);

  enabled = false;
}

void setColor(rgb_color& color) {
  for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    colors[i] = color;
  }

  ledStrip.write(colors, LED_COUNT);
}
