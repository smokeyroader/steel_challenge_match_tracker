import 'package:flutter/material.dart';

class Constants {
  //Match Tracker basic theme color
  static const Color mtGreen = Color(0xFF00681B);

  //Home screen main menu items
  static const List<String> mainMenuChoices = [
    'Save Recent Guns',
    'Clear Recent/Saved Guns',
    'Classification Summary',
    'App Sounds On/Off',
    'Resources',
    'Help',
    'About',
  ];

//Home screen dropdown list items
  static const List<String> divisions = [
    'Select Division',
    'Carry Optics (CO)',
    'Iron Sight Revolver (ISR)',
    'Limited Optics (LO)',
    'Limited (LTD)',
    'Open (OPN)',
    'Optical Sight Revolver (OSR)',
    'Pistol-Caliber Carbine Irons (PCCI)',
    'Pistol-Caliber Carbine Open (PCCO)',
    'Production (PROD)',
    'Rimfire Pistol Irons (RFPI)',
    'Rimfire Pistol Open (RFPO)',
    'Rimfire Rifle Irons (RFRI)',
    'Rimfire Rifle Open (RFRO)',
    'Single Stack (SS)',
  ];

//Match scoring screen menu items
  static const List<String> matchMenuChoices = [
    'Clear Division Data',
    'Track Class',
    'Override Class',
    'Track Best Strings',
    'Show/Hide Today Times',
  ];

//Function to return abbreviation for the division to be scored
  static String getDivAbbrev(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 'CO';

      case 'Iron Sight Revolver (ISR)':
        return 'ISR';

      case 'Limited Optics (LO)':
        return 'LO';

      case 'Limited (LTD)':
        return 'LTD';

      case 'Open (OPN)':
        return 'OPN';

      case 'Optical Sight Revolver (OSR)':
        return 'OSR';

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 'PCCI';

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 'PCCO';

      case 'Production (PROD)':
        return 'PROD';

      case 'Rimfire Pistol Irons (RFPI)':
        return 'RFPI';

      case 'Rimfire Pistol Open (RFPO)':
        return 'RFPO';

      case 'Rimfire Rifle Irons (RFRI)':
        return 'RFRI';

      case 'Rimfire Rifle Open (RFRO)':
        return 'RFRO';

      case 'Single Stack (SS)':
        return 'SS';
    }

    return '';
  }
  ////////////////////////////Peak Times///////////////////////////////

//Function to return peak stage times for the division to be scored

  //Five to Go (101)
  static double getPeak5(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 12.5;

      case 'Iron Sight Revolver (ISR)':
        return 13.5;

      case 'Limited Optics (LO)':
        return 12.25;

      case 'Limited (LTD)':
        return 12.5;

      case 'Open (OPN)':
        return 11.25;

      case 'Optical Sight Revolver (OSR)':
        return 12.25;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 10.75;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 9.5;

      case 'Production (PROD)':
        return 13.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 10.5;

      case 'Rimfire Pistol Open (RFPO)':
        return 8.75;

      case 'Rimfire Rifle Irons (RFRI)':
        return 9.75;

      case 'Rimfire Rifle Open (RFRO)':
        return 9.5;

      case 'Single Stack (SS)':
        return 13.25;
    }
    return 0.0;
  }

  //Showdown (102)
  static double getPeakShow(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 9.75;

      case 'Iron Sight Revolver (ISR)':
        return 12.0;

      case 'Limited Optics (LO)':
        return 9.50;

      case 'Limited (LTD)':
        return 9.5;

      case 'Open (OPN)':
        return 9.5;

      case 'Optical Sight Revolver (OSR)':
        return 10.5;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.5;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 7.0;

      case 'Production (PROD)':
        return 10.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 9.0;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.5;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;

      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;

      case 'Single Stack (SS)':
        return 10.5;
    }
    return 0.0;
  }

  //Smoke & Hope (103)
  static double getPeakSH(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 10.0;

      case 'Iron Sight Revolver (ISR)':
        return 10.5;

      case 'Limited Optics (LO)':
        return 9.50;

      case 'Limited (LTD)':
        return 9.5;

      case 'Open (OPN)':
        return 8.5;

      case 'Optical Sight Revolver (OSR)':
        return 10.0;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 7.75;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 7.0;

      case 'Production (PROD)':
        return 10.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.0;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.0;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;

      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;

      case 'Single Stack (SS)':
        return 10.25;
    }
    return 0.0;
  }

  //Outer Limits (104)
  static double getPeakOL(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 13.75;

      case 'Iron Sight Revolver (ISR)':
        return 15.75;

      case 'Limited Optics (LO)':
        return 13.50;

      case 'Limited (LTD)':
        return 13.5;

      case 'Open (OPN)':
        return 12.5;

      case 'Optical Sight Revolver (OSR)':
        return 14.25;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 12.25;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 11.25;

      case 'Production (PROD)':
        return 14.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 13.0;

      case 'Rimfire Pistol Open (RFPO)':
        return 11.5;

      case 'Rimfire Rifle Irons (RFRI)':
        return 12.0;

      case 'Rimfire Rifle Open (RFRO)':
        return 10.75;

      case 'Single Stack (SS)':
        return 14.75;
    }
    return 0.0;
  }

  //Accelerator (105)
  static double getPeakAcc(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 11.0;

      case 'Iron Sight Revolver (ISR)':
        return 13.0;

      case 'Limited Optics (LO)':
        return 10.75;

      case 'Limited (LTD)':
        return 10.5;

      case 'Open (OPN)':
        return 10.5;

      case 'Optical Sight Revolver (OSR)':
        return 12.75;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 9.5;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 8.75;

      case 'Production (PROD)':
        return 11.5;

      case 'Rimfire Pistol Irons (RFPI)':
        return 9.25;

      case 'Rimfire Pistol Open (RFPO)':
        return 8.5;

      case 'Rimfire Rifle Irons (RFRI)':
        return 9.0;

      case 'Rimfire Rifle Open (RFRO)':
        return 8.5;

      case 'Single Stack (SS)':
        return 11.75;
    }
    return 0.0;
  }

  //Pendulum (106)
  static double getPeakPend(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 12.75;

      case 'Iron Sight Revolver (ISR)':
        return 14.25;

      case 'Limited Optics (LO)':
        return 12.25;

      case 'Limited (LTD)':
        return 12.5;

      case 'Open (OPN)':
        return 11.25;

      case 'Optical Sight Revolver (OSR)':
        return 13.5;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 10.5;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 9.0;

      case 'Production (PROD)':
        return 13.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.0;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.5;

      case 'Rimfire Rifle Irons (RFRI)':
        return 9.75;

      case 'Rimfire Rifle Open (RFRO)':
        return 9.0;

      case 'Single Stack (SS)':
        return 13.5;
    }
    return 0.0;
  }

  //Speed Option (107)
  static double getPeakSpeed(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 13.0;

      case 'Iron Sight Revolver (ISR)':
        return 14.0;

      case 'Limited Optics (LO)':
        return 12.25;

      case 'Limited (LTD)':
        return 12.5;

      case 'Open (OPN)':
        return 11.5;

      case 'Optical Sight Revolver (OSR)':
        return 12.75;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 11.0;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 9.5;

      case 'Production (PROD)':
        return 13.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.0;

      case 'Rimfire Pistol Open (RFPO)':
        return 10.0;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.0;

      case 'Rimfire Rifle Open (RFRO)':
        return 9.0;

      case 'Single Stack (SS)':
        return 13.5;
    }
    return 0.0;
  }

  //Roundabout (108)
  static double getPeakRound(String division) {
    switch (division) {
      case 'Carry Optics (CO)':
        return 9.75;

      case 'Iron Sight Revolver (ISR)':
        return 11.0;

      case 'Limited Optics (LO)':
        return 9.50;

      case 'Limited (LTD)':
        return 9.5;

      case 'Open (OPN)':
        return 8.5;

      case 'Optical Sight Revolver (OSR)':
        return 10.5;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.0;

      case 'Pistol-Caliber Carbine Open (PCCO)':
        return 7.5;

      case 'Production (PROD)':
        return 10.0;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.25;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.5;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;

      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;

      case 'Single Stack (SS)':
        return 10.5;
    }
    return 0.0;
  }
}
