import 'package:gstudent/character/model/UserCharacter.dart';


UserCharacter CharacterById(int characterId) {
  switch (characterId) {
    case 1:
      return UserCharacter(imageCharacter: 'assets/ninja_nam.png', specialAction: 'assets/images/game_fight_icon.png', specialTitle: 'Phi tiêu', characterId: characterId,classCharacter: "Ninja",totalHp: 250);
    case 2:
      return UserCharacter(imageCharacter: 'assets/ninja_nu.png', specialAction: 'assets/images/game_fight_icon.png', specialTitle: 'Phi tiêu', characterId: characterId,classCharacter: "Ninja",totalHp: 250);
    case 3:
      return UserCharacter(imageCharacter: 'assets/healer_nam.png', specialAction: 'assets/images/icon_knitting_practice.png', specialTitle: 'Luyện đan', characterId: characterId,classCharacter: "Healer",totalHp: 150);
    case 4:
      return UserCharacter(imageCharacter: 'assets/healer_nu.png', specialAction: 'assets/images/icon_knitting_practice.png', specialTitle: 'Luyện đan', characterId: characterId,classCharacter: "Healer",totalHp: 150);
    case 5:
      return UserCharacter(imageCharacter: 'assets/thief_nam.png', specialAction: 'assets/images/icon_steal.png', specialTitle: 'Trộm', characterId: characterId,classCharacter: "Thief",totalHp: 200);
    case 6:
      return UserCharacter(imageCharacter: 'assets/thief_nu.png', specialAction: 'assets/images/icon_steal.png', specialTitle: 'Trộm', characterId: characterId,classCharacter: "Thief",totalHp: 200);
    case 7:
      return UserCharacter(imageCharacter: 'assets/alchemist_nam.png', specialAction: 'assets/images/icon_forge.png', specialTitle: 'Cường hóa', characterId: characterId,classCharacter: "The Alchemist",totalHp: 200);
    case 8:
      return UserCharacter(imageCharacter: 'assets/alchemist_nu.png', specialAction: 'assets/images/icon_forge.png', specialTitle: 'Cường hóa', characterId: characterId,classCharacter: "The Alchemist",totalHp: 200);
    case 9:
      return UserCharacter(imageCharacter: 'assets/princess.png', specialAction: 'assets/images/icon_encourage.png', specialTitle: 'Khích lệ', characterId: characterId,classCharacter: "Royal",totalHp: 150);
    case 12:
      return UserCharacter(imageCharacter: 'assets/warrior_nu.png', specialAction: 'assets/images/icon_defend.png', specialTitle: 'Phòng thủ', characterId: characterId,classCharacter: "Warrior",totalHp: 300);
    case 11:
      return UserCharacter(imageCharacter: 'assets/warrior_nam.png', specialAction: 'assets/images/icon_defend.png', specialTitle: 'Phòng thủ', characterId: characterId,classCharacter: "Warrior",totalHp: 300);
  }
}