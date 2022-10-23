class Constants {
  //Main menu items

  static const List<String> mainMenuChoices = [
    'Clear Recent Guns',
    'Save Recent Guns',
    'Classification Summary',
    'Resources',
    'Help',
  ];

  static const List<String> matchMenuChoices = [
    'Clear Division Data',
    'Track Class',
    'Override Class',
    'Track Best Strings',
    'Show/Hide Today Times',
  ];

  static const List<String> divisions = [
    'Select Division',
    'Rimfire Rifle Open (RFRO)',
    'Rimfire Rifle Irons (RFRI)',
    'Pistol-Caliber Carbine Optic (PCCO)',
    'Pistol-Caliber Carbine Irons (PCCI)',
    'Rimfire Pistol Open (RFPO)',
    'Rimfire Pistol Irons (RFPI)',
    'Open (OPN)',
    'Carry Optics (CO)',
    'Production (PROD)',
    'Limited (LTD)',
    'Single Stack (SS)',
    'Optical Sight Revolver (OSR)',
    'Iron Sight Revolver (ISR)'
  ];

  static String getDivAbbrev(String division) {
    switch (division) {

      case 'Rimfire Rifle Open (RFRO)':
        return 'RFRO';

      case 'Rimfire Rifle Irons (RFRI)':
        return 'RFRI';

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 'PCCO';

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 'PCCI';

      case 'Rimfire Pistol Open (RFPO)':
        return 'RFPO';

      case 'Rimfire Pistol Irons (RFPI)':
        return 'RFPI';

      case 'Open (OPN)':
        return 'OPN';

      case 'Carry Optics (CO)':
        return 'CO';

      case 'Production (PROD)':
        return 'PROD';

      case 'Limited (LTD)':
        return 'LTD';

      case 'Single Stack (SS)':
        return 'SS';

      case 'Optical Sight Revolver (OSR)':
        return 'OSR';

      case 'Iron Sight Revolver (ISR)':
        return 'ISR';
    }

    return '';
  }
  ////////////////////////////Peak Times///////////////////////////////

  //5 to Go (101)
  static double getPeak5(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 12.76;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 13.6;
        break;

      case 'Limited (LTD)':
        return 12.6;
        break;

      case 'Open (OPN)':
        return 11.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.35;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 10.75;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.5;
        break;

      case 'Production (PROD)':
        return 12.83;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 10.6;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.0;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 9.5;
        break;

      case 'Single Stack (SS)':
        return 13.35;
        break;

    }
    return 0.0;
  }

  //Showdown (102)
  static double getPeakShow(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 10.1;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 12.1;
        break;

      case 'Limited (LTD)':
        return 9.6;
        break;

      case 'Open (OPN)':
        return 9.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.6;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.5;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 7.0;
        break;

      case 'Production (PROD)':
        return 10.1;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.85;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.39;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.4;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;
        break;

      case 'Single Stack (SS)':
        return 10.6;
        break;

    }
    return 0.0;
  }
  //Smoke & Hope (103)
  static double getPeakSH(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 9.83;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 10.5;
        break;

      case 'Limited (LTD)':
        return 9.6;
        break;

      case 'Open (OPN)':
        return 9.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.16;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 7.63;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 6.83;
        break;

      case 'Production (PROD)':
        return 10.1;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 7.77;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 6.81;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;
        break;

      case 'Single Stack (SS)':
        return 10.35;
        break;

    }
    return 0.0;
  }

  //Outer Limits (104)
  static double getPeakOL(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 14.0;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 15.85;
        break;

      case 'Limited (LTD)':
        return 13.6;
        break;

      case 'Open (OPN)':
        return 12.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 14.35;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 12.29;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 11.5;
        break;

      case 'Production (PROD)':
        return 14.1;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 13.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 11.5;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 12.0;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 11.0;
        break;

      case 'Single Stack (SS)':
        return 14.85;
        break;

    }
    return 0.0;
  }

  //Accelerator (105)
  static double getPeakAcc(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 11.1;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 13.1;
        break;

      case 'Limited (LTD)':
        return 10.6;
        break;

      case 'Open (OPN)':
        return 10.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.64;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 9.83;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 8.64;
        break;

      case 'Production (PROD)':
        return 11.6;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 9.5;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 9.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 8.33;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 8.5;
        break;

      case 'Single Stack (SS)':
        return 11.85;
        break;

    }
    return 0.0;
  }

  //Pendulum (106)
  static double getPeakPend(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 13.1;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 14.35;
        break;

      case 'Limited (LTD)':
        return 12.6;
        break;

      case 'Open (OPN)':
        return 11.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 13.6;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 11.0;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.06;
        break;

      case 'Production (PROD)':
        return 13.0;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.5;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.23;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.0;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 9.0;
        break;

      case 'Single Stack (SS)':
        return 13.6;
        break;

    }
    return 0.0;
  }

  //Speed Option (107)
  static double getPeakSpeed(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 13.0;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 14.1;
        break;

      case 'Limited (LTD)':
        return 12.6;
        break;

      case 'Open (OPN)':
        return 11.32;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.85;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 10.8;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.5;
        break;

      case 'Production (PROD)':
        return 13.1;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.23;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.83;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.25;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 8.79;
        break;

      case 'Single Stack (SS)':
        return 13.6;
        break;

    }
    return 0.0;
  }

  //Roundabout (108)
  static double getPeakRound(String division) {
    switch (division) {

      case 'Carry Optics (CO)':
        return 10.1;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 11.1;
        break;

      case 'Limited (LTD)':
        return 9.6;
        break;

      case 'Open (OPN)':
        return 8.6;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.6;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 7.86;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 7.5;
        break;

      case 'Production (PROD)':
        return 10.1;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.5;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.27;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.75;
        break;

      case 'Rimfire Rifle Open (RFRO)':
        return 6.85;
        break;

      case 'Single Stack (SS)':
        return 10.6;
        break;

    }
    return 0.0;
  }
}
