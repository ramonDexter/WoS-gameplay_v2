////////////////////////////////////////////////////////////////////////////////
// executor rifle //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class wosPhaestonRifle : wosWeapon {
	Default {
		//$Category "weapons"
		//$Title "Executor Rifle (weapon)"
        +WEAPON.AMMO_OPTIONAL;
        +FLOORCLIP;

        radius 16;
        //height 16;
        Tag "$TAG_PhaestonRifle";
        Inventory.PickupMessage "$FND_PhaestonRifle";
        obituary "$OBI_PhaestonRifle";
        inventory.icon "H_PHST";
        weapon.SlotNumber 2;
		Weapon.SlotPriority 0.2;
		//Weapon.SelectionOrder 400;
        weapon.kickBack 40;
        Mass phaestonWeight;
		wosWeapon.Magazine 48;
		wosWeapon.magazineMax 48;
		wosWeapon.magazineType "ClipOfBullets";
	}
	States {
		Spawn:
			DUMM Z -1;
			Stop;
		Nope:
			DUMM A 1 {
				A_WeaponReady(WRF_NOFIRE); 
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 A_ClearReFire();
			Goto Ready;
		Select:
			DUMM A 1 A_Raise();
			Loop;
		Deselect:
			DUMM A 1 A_Lower();
			Loop;
		Ready:
			DUMM A 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER1|WRF_ALLOWUSER4);
			Loop;
		Fire:
			DUMM A 1 W_CheckAmmo();
			DUMM B 2 Bright W_ShootFireArm2(8, "weapons/executorRifle/Fire");
			DUMM C 1 Bright;
			DUMM D 1 A_Refire();
            goto Ready;
		Reload:
			TNT1 A 0 W_reloadCheck2();
			goto Ready;
		DoReload:
			//DUMM A 2;
			DUMM D 2;
			DUMM EF 2;
			DUMM G 2 A_StartSound("weapons/executorRifle/ReloadPush", 1);
			DUMM HIJ 3;
			DUMM J 10 W_reload2();
			DUMM JIH 3;
			DUMM G 2 A_StartSound("weapons/executorRifle/ReloadRotate", 1);
			DUMM FE 2;
			DUMM A 1;
			goto Ready;

	}
}
// dummy deco objects //////////////////////////////////////////////////////////
class wosPhaestonRifle_dummy1 : actor {
	Default {
		//$Category "Decorations/Wos"
		//$Title "deco executor rifle 01"
		tag "executor rifle";
		radius 10;
		height 8;
		+SOLID
		+USESPECIAL
		+NOGRAVITY
	}
	States {
		Spawn:
			DUMM A -1;
			Stop;
	}
}
class wosPhaestonRifle_dummy2 : actor {
	Default {
		//$Category "Decorations/Wos"
		//$Title "deco executor rifle 02"
		tag "executor rifle";
		radius 10;
		height 8;
		+SOLID
		+USESPECIAL
		+NOGRAVITY
	}
	States {
		Spawn:
			DUMM A -1;
			Stop;
	}
}
class wosPhaestonRifle_dummy3 : actor {
	Default {
		//$Category "Decorations/Wos"
		//$Title "deco executor rifle 03"
		tag "executor rifle";
		radius 10;
		height 8;
		+SOLID
		+USESPECIAL
		+NOGRAVITY
	}
	States {
		Spawn:
			DUMM A -1;
			Stop;
	}
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////