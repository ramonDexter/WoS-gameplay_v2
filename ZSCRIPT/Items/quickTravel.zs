////////////////////////////////////////////////////////////////////////////////
// Quick Travel ////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// code by Virathas & ramon.dexter /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
const quickTravelWeight = 35;
class wosQuickTravel : CustomInventory {

	Actor TeleportTarget;

	override bool Use(bool Pickup) {
		TextureID idI_QTDV = TexMan.CheckForTexture("I_QTDV", 0, 0);
		TextureID idI_QTDB = TexMan.CheckForTexture("I_QTDB", 0, 0);
		If (!TeleportTarget) { // place teleport beacon
			self.TeleportTarget = quickTravelBeacon(Owner.Spawn("quickTravelBeacon", Owner.pos));
			self.icon = idI_QTDV;
			//Owner.A_Log("$Beacon_placed");
		} else { // teleport
			//Owner.A_StartSound("");
			Owner.Teleport(TeleportTarget.Pos, Owner.Angle, TF_TELEFRAG);
			self.icon = idI_QTDB;
			TeleportTarget.Destroy();
			TeleportTarget = null;
		}
        return false; // Do not use the item
	}

	Default {
		//$Category "Powerups/WoS"
		//$Title "Quick Travel"		
		-SOLID;
		+INVENTORY.INVBAR;
		+INVENTORY.ALWAYSPICKUP;		
		Tag "$T_QTDEV";
		height 10;
		radius 10;
		//scale 0.5;
		inventory.icon "I_QTDB";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		inventory.InterHubAmount 1;
		inventory.pickupmessage "$F_QTDEV";
		Mass quickTravelWeight;
	}	
	States {
		Spawn:
			DUMM ABCD 6;
			Loop;		
		Use:
			TNT1 A 0;
			Stop;
	}
}
class quickTravelBeacon : actor {
	Default {
		-SOLID;
		-NOGRAVITY;
		+NODAMAGE;
		+NOBLOOD;
		+NODAMAGETHRUST;
		+DONTSPLASH;
		+DONTTHRUST;		
		radius 8;
		height 8;
		scale 0.5;
	}	
	States {
		Spawn:
			DUMM AB 6;
			Loop;		
	}
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////