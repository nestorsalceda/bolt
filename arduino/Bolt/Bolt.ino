#include <PololuLedStrip.h>

#define TEMPERATURE_PIN 0
PololuLedStrip<12> ledStrip;

#define LED_COUNT 60
rgb_color colors[LED_COUNT];

String command = "";
String read_colors = "";
boolean enabled = false;

unsigned long previousMillis = 0;
unsigned long interval = 10;

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

void setColor(rgb_color& color)
{
  for(uint16_t i = 0; i < LED_COUNT; i++)
  {
    colors[i] = color;
  }

  ledStrip.write(colors, LED_COUNT);
}

float temperature(int b=3950.0, int r_0=2800, float t_0=298.15)
{
  int v_0 = analogRead(TEMPERATURE_PIN);
  float r = 10000.0;
  float r_t = r * (1023 / float(v_0) - 1);
  float t_kelvin = b / log(r_t / (r_0 * pow(M_E, (-b/t_0))));

  return t_kelvin - 273.15;
}

void spectrum()
{
  unsigned int colours[3];

  colours[0] = 255;
  colours[1] = 0;
  colours[2] = 0;

  for(int decrement = 0; decrement < 3; decrement++) {
    int increment = decrement == 2 ? 0 : decrement + 1;

    for(int i = 0; i < 255; i++) {
      colours[decrement]--;
      colours[increment]++;

      rgb(colours[0], colours[1], colours[2]);
      delay(200);
    }
  }
}

void loop()
{
  if (millis() - previousMillis > interval && Serial.available())
  {
    previousMillis = millis();
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
    else if (command == "temperature?")
    {
      Serial.println(temperature());
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
    else if (command == "spectrum")
    {
      spectrum();
    }
    else
    {
      Serial.println("ERROR: Unknown command " + command);
    }
  }
}

