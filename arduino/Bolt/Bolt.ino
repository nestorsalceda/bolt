#include <PololuLedStrip.h>

PololuLedStrip<12> ledStrip;

#define LED_COUNT 60
rgb_color colors[LED_COUNT];

String command = "";
String read_colors = "";
boolean enabled = false;

void setup()
{
  Serial.begin(115200);
  Serial.println("Ready to receive commands.");
  disable();
}

void rgb(byte red, byte green, byte blue)
{
  rgb_color color;
  color.red = red;
  color.green = green;
  color.blue = blue;
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

void loop()
{
  if (Serial.available())
  {
    command = Serial.readStringUntil('\n');
    command.trim();

    if (command == "disable")
    {
      disable();
    }
    else if (command == "enabled?")
    {
      Serial.println(enabled);
    }
    else if (command.startsWith("rgb"))
    {
      read_colors = command.substring(4);
      byte first_comma = read_colors.indexOf(',');
      byte last_comma = read_colors.lastIndexOf(',');

      if (read_colors and first_comma != -1 and last_comma != first_comma)
      {
        byte red = read_colors.substring(0, first_comma).toInt();
        byte green = read_colors.substring(first_comma + 1, last_comma).toInt();
        byte blue = read_colors.substring(last_comma + 1, read_colors.length()).toInt();

        rgb(red, green, blue);
      }
      else
      {
        Serial.println("ERROR: Add RGB colors to command");
      }
    }
    else
    {
      Serial.println("ERROR: Unknown command");
    }
  }
}

