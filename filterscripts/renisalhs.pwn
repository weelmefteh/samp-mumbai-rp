#include <a_samp>
#include <core>
#include <float>

public OnFilterScriptInit() {
  SetTimer("RotateHostname", 10000, true); // كل 10 ثوانٍ
  print("P:RP's Dynamic Hostname System Started");
  return 1;
}

main()
{
  print("\n*********************************");
  print("      P:RP's Hostnames - Renisal    ");
  print("***********************************\n");
  return 0;
}

forward RotateHostname();
public RotateHostname()
{ 
  new hour, minute, second;
  new year, month, day;
  new weekday[10];

  gettime(hour, minute, second);
  getdate(year, month, day);

  switch (GetWeekDay())
  {
    case 0: format(weekday, sizeof(weekday), "Sun");
    case 1: format(weekday, sizeof(weekday), "Mon");
    case 2: format(weekday, sizeof(weekday), "Tue");
    case 3: format(weekday, sizeof(weekday), "Wed");
    case 4: format(weekday, sizeof(weekday), "Thu");
    case 5: format(weekday, sizeof(weekday), "Fri");
    case 6: format(weekday, sizeof(weekday), "Sat");
  }

  new playerCount = 0;
  for (new i = 0; i < MAX_PLAYERS; i++)
  {
    if(IsPlayerConnected(i)) playerCount++;
  }

  new name[144];
  format(name, sizeof(name), "[ Prospect RP ] | \xF0\x9F\x97\x93 %s | \xF0\x9F\x91\xA5 %d | \xF0\x9F\x93\x85 %02d/%02d/%d | \xE2\x8F\xB0 %02d:%02d:%02d", weekday, playerCount, day, month, year, hour, minute, second);

  new cmd[160];
  format(cmd, sizeof(cmd), "hostname %s", name);
  SendRconCommand(cmd);
  
  return 1;

}

