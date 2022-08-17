String loadAvatarCharacterById(int characterId) {
  // 'assets/images/icon_steal.png'
  switch (characterId) {
    case 1:
      return  'assets/ninja_nam_avatar.png';

    case 2:
      return   'assets/ninja_nu_avatar.png';
    case 3:
      return  'assets/healer_nam_avatar.png';
    case 4:
      return    'assets/healer_nu_avatar.png';
    case 5:
      return   'assets/thief_nam_avatar.png';
    case 6:
      return  'assets/thief_nu_avatar.png';
    case 7:
      return   'assets/alchemist_nam_avatar.png';
    case 8:
      return 'assets/alchemist_nu_avatar.png';
    case 9:
      return   'assets/princess_avatar.png';
    case 10:
      return   'assets/warrior_nu_avatar.png';
    case 11:
      return   'assets/warrior_nam_avatar.png';
    default:
      return   'assets/princess_avatar.png';
  }
}

String loadCharacterById(int characterId) {
  // 'assets/images/icon_steal.png'
  switch (characterId) {
    case 1:
      return  'assets/ninja_nam.png';
    case 2:
      return   'assets/ninja_nu.png';
    case 3:
      return  'assets/healer_nam.png';
    case 4:
      return    'assets/healer_nu.png';
    case 5:
      return   'assets/thief_nam.png';
    case 6:
      return  'assets/thief_nu.png';
    case 7:
      return   'assets/alchemist_nam.png';
    case 8:
      return 'assets/alchemist_nu.png';
    case 9:
      return   'assets/princess.png';
    case 12:
      return   'assets/warrior_nu.png';
    case 11:
      return   'assets/warrior_nam.png';
    default:
      return   'assets/princess.png';
  }
}