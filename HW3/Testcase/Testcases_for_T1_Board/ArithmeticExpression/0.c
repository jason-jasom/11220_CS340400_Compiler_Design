void codegen();
void codegen()
{
  int a = 1 + 2 * 1; // a = 3
  int b = (a + 3) / 2; // b = 3
  digitalWrite(13, HIGH);
  delay(a * 1000); // delay 3 seconds
  digitalWrite(13, LOW);
  delay(b * 1000); // delay 3 seconds
}
