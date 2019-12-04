class Constants {
  //Main menu items

  static const List<String> mainMenuChoices = <String>[
    'Clear Recent Guns',
    'Save Recent Guns',
    'Classification Summary',
    'Resources',
    'Help',
  ];

  static const List<String> matchMenuChoices = <String>[
    'Clear Division Data',
    'Track Class',
    'Override Class',
    'Track Best Strings',
    'Show/Hide Today Times',
  ];

  static const List<String> divisions = <String>[
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

  static double getPeak5(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 9.5;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.0;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.5;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 11.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.0;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 10.5;
        break;

      case 'Open (OPN)':
        return 11.5;
        break;

      case 'Carry Optics (CO)':
        return 13.0;
        break;

      case 'Production (PROD)':
        return 13.0;
        break;

      case 'Limited (LTD)':
        return 12.5;
        break;

      case 'Single Stack (SS)':
        return 13.25;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.25;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 13.5;
        break;
    }
    return 0.0;
  }

  static double getPeakShow(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 7.0;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.5;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.5;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 9.0;
        break;

      case 'Open (OPN)':
        return 9.5;
        break;

      case 'Carry Optics (CO)':
        return 10.0;
        break;

      case 'Production (PROD)':
        return 10.0;
        break;

      case 'Limited (LTD)':
        return 9.5;
        break;

      case 'Single Stack (SS)':
        return 10.5;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.5;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 12.0;
        break;
    }
    return 0.0;
  }

  static double getPeakSH(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.5;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 7.0;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.0;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.0;
        break;

      case 'Open (OPN)':
        return 8.5;
        break;

      case 'Carry Optics (CO)':
        return 10.0;
        break;

      case 'Production (PROD)':
        return 10.0;
        break;

      case 'Limited (LTD)':
        return 9.5;
        break;

      case 'Single Stack (SS)':
        return 10.25;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.0;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 10.5;
        break;
    }
    return 0.0;
  }

  static double getPeakOL(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 11.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 12.0;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 11.5;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 12.5;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 11.5;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 13.0;
        break;

      case 'Open (OPN)':
        return 12.5;
        break;

      case 'Carry Optics (CO)':
        return 14.0;
        break;

      case 'Production (PROD)':
        return 14.0;
        break;

      case 'Limited (LTD)':
        return 13.5;
        break;

      case 'Single Stack (SS)':
        return 14.75;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 14.25;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 15.75;
        break;
    }
    return 0.0;
  }

  static double getPeakAcc(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 8.5;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 9.0;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 8.75;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 10.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 8.5;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 9.5;
        break;

      case 'Open (OPN)':
        return 10.5;
        break;

      case 'Carry Optics (CO)':
        return 11.0;
        break;

      case 'Production (PROD)':
        return 11.5;
        break;

      case 'Limited (LTD)':
        return 10.5;
        break;

      case 'Single Stack (SS)':
        return 11.75;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.75;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 13.0;
        break;
    }
    return 0.0;
  }

  static double getPeakPend(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 9.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.0;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.25;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 11.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 9.5;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.5;
        break;

      case 'Open (OPN)':
        return 11.5;
        break;

      case 'Carry Optics (CO)':
        return 13.0;
        break;

      case 'Production (PROD)':
        return 13.0;
        break;

      case 'Limited (LTD)':
        return 12.5;
        break;

      case 'Single Stack (SS)':
        return 13.5;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 13.5;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 14.25;
        break;
    }
    return 0.0;
  }

  static double getPeakSpeed(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 9.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 10.25;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 9.5;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 11.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 10.0;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 11.0;
        break;

      case 'Open (OPN)':
        return 11.5;
        break;

      case 'Carry Optics (CO)':
        return 13.0;
        break;

      case 'Production (PROD)':
        return 13.0;
        break;

      case 'Limited (LTD)':
        return 12.5;
        break;

      case 'Single Stack (SS)':
        return 13.5;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 12.75;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 14.0;
        break;
    }
    return 0.0;
  }

  static double getPeakRound(String division) {
    switch (division) {
      case 'Rimfire Rifle Open (RFRO)':
        return 7.0;
        break;

      case 'Rimfire Rifle Irons (RFRI)':
        return 7.75;
        break;

      case 'Pistol-Caliber Carbine Optic (PCCO)':
        return 7.5;
        break;

      case 'Pistol-Caliber Carbine Irons (PCCI)':
        return 8.0;
        break;

      case 'Rimfire Pistol Open (RFPO)':
        return 7.5;
        break;

      case 'Rimfire Pistol Irons (RFPI)':
        return 8.5;
        break;

      case 'Open (OPN)':
        return 8.5;
        break;

      case 'Carry Optics (CO)':
        return 10.0;
        break;

      case 'Production (PROD)':
        return 10.0;
        break;

      case 'Limited (LTD)':
        return 9.5;
        break;

      case 'Single Stack (SS)':
        return 10.5;
        break;

      case 'Optical Sight Revolver (OSR)':
        return 10.5;
        break;

      case 'Iron Sight Revolver (ISR)':
        return 11.0;
        break;
    }
    return 0.0;
  }
}
