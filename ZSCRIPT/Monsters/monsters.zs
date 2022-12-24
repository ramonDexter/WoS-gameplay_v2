///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// wos monsters defs //////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rebel enemy base class /////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class rebelEnemy : Rebel replaces Rebel {

	// usage: W_rewardXPRebel(SpawnHealth());   //
	action void W_rewardXPRebel (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}

	int gunmag; //
	int searchtimer; //
	bool searched; //
	bool lootmed; //
	bool lootarm; //
	int lootarm2; //
	bool lootgun; //
	int lootgun2; //
	int lootmoney; //
	bool lootrep; //
	string looteqip; Property Equipment : looteqip; //
	int looteqip2; //
    
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		gunmag=30;
		//If(shielded==1){A_SpawnItemEx("LFAcolyteShield",flags: SXF_SETMASTER);}
		If(Random(1,3)==1){lootmed=1;} If(Random(1,8)==1){lootarm=1; lootarm2=Random(15,85);}
		If(Random(1,6)==1){lootgun=1; lootgun2=Random(50,600);} If(Random(1,10)==1){lootrep=1;}
		lootmoney=Random(3,15);
	}

	Override bool Used(Actor user) {
		let pawn = binderPlayer(user);
		If( searched==0 && health<1 && InStateSequence(CurState,ResolveState("Death")) && user is "binderPlayer" && pawn.currentarmor!=4 ) {
			int tosearch = 6 - (2 * pawn.SpeedUpgrade);
			If( searchtimer >= tosearch ) {
				If( lootmed == 1 ){ 
					Actor med = A_DropItem("wosHyposprej"); 
				}
				If( lootarm == 1 ){ 
					Actor arm = A_DropItem("wosLeatherArmor"); 
				}
				If( looteqip == "TARG" ){ 
					Actor trg = A_DropItem("wosTargeter"); 
				}
				While( lootmoney > 0 ) {
					If( lootmoney >= 25 ){ 
						A_DropItem("Gold25"); 
						lootmoney-=25; 
					} Else If( lootmoney >= 10 ){ 
						A_DropItem("Gold10"); 
						lootmoney-=10; 
					} Else If(lootmoney>=1){
						A_DropItem("coin"); 
						lootmoney--;
					}
				}
				If( lootgun == 1 ){ Actor gun = A_DropItem("wosAssaultGun"); }
				Else If( gunmag > 1 ){ Actor mag = A_DropItem("ClipOfBullets",gunmag/2); }
				If( lootrep == 1 ){ Actor rep = A_DropItem("wosArmorShard"); }
				searched = 1;
			} Else {
				A_ChangeVelocity(frandom(-0.5,0.5),frandom(-0.5,0.5));
				A_StartSound("sound/wearClothing");
				searchtimer++;
			}
		}
		Return Super.Used(user);
	}

	Default {
		//$category "Monsters/Heretics"
		//$Title "Heretic"
		
		-Friendly
		
		Tag "Heretic";
	}
	States {
		Spawn:
			HMN1 P 5 A_Look2;
			Loop;
			HMN1 Q 8;
			Loop;
			HMN1 R 8;
			Loop;
			HMN1 ABCDABCD 6 A_Wander;
			Loop;
		See:
			HMN1 AABBCCDD 3 A_Chase;
			Loop;
		Missile:
			HMN1 E 10 A_FaceTarget;
			HMN1 F 5 BRIGHT A_ShootGun;
			HMN1 E 3 A_ShootGun;
			HMN1 F 5 BRIGHT A_ShootGun;
			Goto See;
		Pain:
			HMN1 O 3;
			HMN1 O 3 A_Pain;
			Goto See;
		Death:
			HMN1 G 5;
			HMN1 H 5 A_Scream;
			HMN1 I 3 A_NoBlocking;
			HMN1 J 4;
			HMN1 KLM 3;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			HMN1 N -1;
			Stop;
		XDeath:
			RGIB A 4 A_TossGib;
			RGIB B 4 A_XScream;
			RGIB C 3 A_NoBlocking;
			RGIB DEF 3 A_TossGib;
			RGIB G 3;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			RGIB H 1400;
			Stop;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// rebels /////////////////////////////////////////////////////////////////////////////////////////////////////
class rebelEnemy_spider : rebelEnemy {
	Default {
		//$category "Monsters/WoS"
		//$Title "Spider  ganger"
		-Friendly
		
		Tag "Spider";
		Dropitem "Gold10";
		Dropitem "ClipOfBullets";
	}
	
	
}
class ShieldRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Shield Heretic"
		
		-Friendly
		
		Tag "$TAG_ShieldRebel";//Shield Heretic
		Health 70;
		PainChance 110;
		Speed 8;
		DropItem "AssaultGun";
		DropItem "Shield";
		//Dropitem "randomDrop_02";
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		Obituary "%o got shot down by a shield-wielding rebel.";
	}
	
	States {
		Spawn:
			SREB A 1 A_Look();
			loop;
		See:
			SREB AABBCCDD 3  A_Chase();
			loop;
		Melee:
			SREB E 4 A_FaceTarget();
			SREB G 4 A_CustomMeleeAttack(3*random(1, 6));
			SREB E 25;
			Goto See;
		Missile:
			SREB E 7 A_FaceTarget();
			SREB F 1 Bright A_ShootGun();
			SREB E 2 A_FaceTarget();
			SREB F 1 Bright A_ShootGun();
			SREB E 2 A_FaceTarget();
			SREB F 1 Bright A_ShootGun();
			SREB E 3;
			Goto See;
		Pain:
			SREB G 0 A_SetInvulnerable();
			SREB G 1 A_Pain();
			SREB G 29 A_CentaurDefend();
			SREB G 0 A_UnSetInvulnerable();
			Goto See;
		Death:
			SREB H 4 A_NoBlocking();
			SREB I 4 A_Scream();
			SREB J 4;
			SREB KLMN 3;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			SREB O -1;
			Stop;
		XDeath:
			SREB P 3 A_TossGib();
			SREB Q 0 A_NoBlocking();
			SREB Q 0 A_TossGib();
			SREB Q 3 A_XScream();
			SREB R 3 A_TossGib();
			SREB STUV 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			SREB W -1;
			Stop;
		Burn:
			BURN A 3 Bright A_StartSound("human/imonfire", 2);
			BURN B 3 Bright A_DropFire();
			BURN C 3 Bright A_Wander();
			BURN D 3 Bright A_NoBlocking();
			BURN E 5 Bright A_DropFire();
			BURN FGH 5 Bright A_Wander();
			BURN I 5 Bright A_DropFire();
			BURN JKL 5 Bright A_Wander();
			BURN M 5 Bright A_DropFire();
			BURN NOPQPQ 5 Bright;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			BURN RSTU 7 Bright;
			BURN V -1;
			Stop;
		Disintegrate:
			DISR A 5 A_StartSound("misc/disruptordeath", 2);
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			DISR BC 5;
			DISR D 5 A_NoBlocking();
			DISR EF 5;
			DISR GHIJ 4;
			MEAT D -1;
			Stop;
	}
}
class Shield : actor {
	Default {
		+DROPOFF
		+CORPSE
		+NOTELEPORT
		
		Health 1;		
	}
	
	States {
		Spawn:
			RSLD A 1;
			loop;
		Crash:
			RSLD B 4 A_StartSound("misc/metalhit", 0);
			RSLD C 4;
			RSLD D 1;
			Goto Crash+2;
	}
}

class spider_leader : ShieldRebel {
	Default {
		//$category "Monsters/WoS"
		//$Title "Spider  leader"
		
		Tag "$TAG_spider_leader";//Spider leader
	}
}

class EliteRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Elite Heretic"
		
		-Friendly
		
		Tag "$TAG_EliteRebel";
		Health 95;
		PainChance 140;
		Speed 7;
		DropItem "AssaultGun";
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		//DropItem "ClipofBullets";
		//Dropitem "randomDrop_01";
		Obituary "%o was riddled by an Elite Rebel.";
	}
	
	States {
		Spawn:
			RAVW A 1 A_Look();
			loop;
		See:
			RAVW AABBCCDDAABBCCDDAABBCCDDAABBCCDD 2 A_Chase();
			RAVW A 0 A_Jump(20, "Strafing");
			loop;
		Strafing:
			RAVW AAAABBBBCCCCDDDDAAAABBBBCCCCDDDDAAAABBBBCCCCDDDD 1 A_FastChase();
			loop;
		Melee:
		Missile:
			RAVW E 1 A_FaceTarget();
			RAVW F 2 Bright A_ShootGun();
			RAVW F 2 Bright A_ShootGun();
			RAVW E 1 A_FaceTarget();
			RAVW F 2 Bright A_ShootGun();
			RAVW F 2 Bright A_ShootGun();
			RAVW E 1 A_FaceTarget();
			RAVW F 2 Bright A_ShootGun();
			RAVW F 2 Bright A_ShootGun();
			RAVW E 20;
			RAVW E 0 A_CPosRefire();
			Goto Missile;
		Pain:
			RAVW G 3 A_Pain();
			Goto See;
		Death:
			RAVW H 5 A_Scream();
			RAVW I 5 A_NoBlocking();
			RAVW JKL 4;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			RAVW M -1;
			Stop;
		XDeath:
			RAVW N 3 A_XScream();
			RAVW N 0 A_NoBlocking();
			RAVW OPQRST 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			RAVW U -1;
			Stop;
	}
}
class GrenadeRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Grenade Heretic"
		
		-Friendly
		
		Tag "$TAG_GrenadeRebel";
		Health 90;
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		DamageFactor "RebelGrenade", 0.1;
		DropItem "StrifeGrenadeLauncher";
		Obituary "%o was shot by a Rebel Grenadier.";
		//Dropitem "randomDrop_03";
	}
	
	States {
		Spawn:
			GREB A 1 A_Look();
			loop;
		See:
			GREB AABBCCDD 3 A_Chase();
			loop;
		Melee:
		Missile:
			GREB E 0 A_JumpIfCloser(200, "Gun");
			GREB E 10 A_FaceTarget();
			GREB F 5 Bright A_SpawnProjectile("RebelGrenade");
			GREB E 10 A_FaceTarget();
			GREB F 5 Bright A_SpawnProjectile("RebelGrenade");
			Goto See;
		Gun:
			GREB E 6 A_FaceTarget();
			GREB F 6 Bright A_ShootGun();
			Goto See;
		Pain:
			GREB G 3;
			GREB G 3 A_Pain();
			Goto See;
		Death:
			GREB H 5 A_Scream();
			GREB I 5 A_NoBlocking();
			GREB JKLM 4;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			GREB N -1;
			Stop;
		XDeath:
			GREB O 4 A_TossGib();
			GREB P 4 A_XScream();
			GREB Q 3 A_NoBlocking();
			GREB RSTU 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			GREB V -1;
			Stop;
	}
}
class RebelGrenade : HEGrenade {
	Default {
		BounceCount 3;
		Speed 25;
		DamageType "RebelGrenade";
		Obituary "%o tripped a rebel's grenade.";
	}
}
class MaulerRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Mauler Heretic"
		
		-Friendly
		
		Health 100;
		Tag "$TAG_MaulerRebel";
		AttackSound "templar/shoot";
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		Obituary "%o got mauled by a Mauler Rebel.";
		DropItem "Mauler";
		//Dropitem "randomDrop_04";
	}
	
	States {
		Spawn:
			MRBL A 1 A_Look();
			loop;
		NoAttackSee:
			MRBL AABBCCDDAABBCCDDAABBCCDD 3 A_Chase();
		See:
			MRBL AABBCCDD 3 A_Chase();
			loop;
		Melee:
		Missile:
			MRBL E 35 A_FaceTarget();
			MRBL F 5 Bright A_CustomBulletAttack(11.25, 7, 20, 5*random(1, 3), "MaulerPuff");
			MRBL E 5 A_FaceTarget();
			Goto NoAttackSee;
		Pain:
			MRBL G 3;
			MRBL G 3 A_Pain();
			Goto See;
		Death:
			MRBL H 5 A_Scream();
			MRBL I 5 A_Noblocking();
			MRBL JK 4;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			MRBL L -1;
			Stop;
		XDeath:
			RAVW N 3 A_XScream();
			RAVW N 0 A_NoBlocking();
			RAVW OPQRST 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			RAVW U -1;
			Stop;
	}
}

class tgPowerPlant_hereticCaptain : MaulerRebel {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "tg pp heretic captain"
		
		Tag "$TAG_tgPowerPlant_hereticCaptain";
		Health 222;
		DropItem "SHtgPowerplantKey";
	}
}

class FlamerRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Flamer Heretic"
		
		-Friendly
		
		Health 100;
		Tag "$TAG_FlamerRebel";
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		Obituary "%o got burned to death by a flamethrower rebel.";
		DropItem "Flamethrower";
		//Dropitem "randomDrop_04";
		DamageFactor "Fire", 0.1;
	}
	
	States {
		Spawn:
			FLRB A 1 A_Look();
			loop;
		See:
			FLRB AABBCCDD 3 A_Chase();
			loop;
		Melee:
		Missile:
			FLRB E 0 A_JumpIfCloser(128, "Flamer");
			FLRB E 6 A_FaceTarget();
			FLRB F 6 A_ShootGun();
			Goto See;
		Flamer:
			FLRB E 2 A_FaceTarget();
		FlamerLoop:
			FLRB F 2 Bright A_SpawnProjectile("FlameMissile");
			FLRB F 3 Bright A_FaceTarget();
			FLRB E 0 A_JumpIfCloser(128, "FlamerLoop");
			Goto See;
		Pain:
			FLRB G 3;
			FLRB G 3 A_Pain();
			Goto See;
		Death:
			FLRB H 5 A_ScreamandUnblock();
			FLRB I 5;
			FLRB JK 4;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			FLRB L -1;
			Stop;
		XDeath:
			FLRB M 3 A_NoBlocking();
			FLRB N 3 A_XScream();
			FLRB OPQRS 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			FLRB T -1;
			Stop;
	}
}

class RangerRebel : rebelEnemy {
	Default {
		//$Category "Monsters/Heretics"
		//$Title "Ranger Heretic"
		
		-Friendly
		+LOOKALLAROUND
		
		Tag "$TAG_RangerRebel";
		PainSound "NewRebelPain";
		DeathSound "NewRebelDeath";
		AttackSound "monsters/rifle";
		//Dropitem "randomDrop_01";
	}
	
	States {
		Spawn:
			RANG A 1 A_Look();
			loop;
		See:
			RANG ABCD 6 A_Chase();
			loop;
		Melee:
			RANG E 4 A_CustomMeleeAttack(random(1, 4)*5, "misc/meathit", "misc/swish");
			RANG A 12;
			Goto See;
		Missile:
			RANG E 35 A_FaceTarget();
			RANG F 4 Bright A_CustomBulletAttack(1, 1, 1, random(1, 5)*8);
			RANG E 10 A_FaceTarget();
			Goto See;
		Pain:
			RANG G 6 A_Pain();
			Goto See;
		Death:
			RANG H 4 A_ScreamandUnBlock();
			RANG IJK 4;
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			RANG L -1;
			Stop;
		XDeath:
			CGIB A 3 A_XScream();
			CGIB BCDEFG 3 A_TossGib();
			TNT1 A 0 W_rewardXPRebel(SpawnHealth());
			CGIB H -1;
			Stop;
	}
}

class hereticCaptain : EliteRebel {
	Default {
		//$Title "Heretic Captain"
		
		Tag "$TAG_hereticCaptain";
		Dropitem "leaderskull";
		Health 222;
		//Dropitem "randomDrop_01";
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// spiker trap ////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class spikerTrap : wosMonsterBase {

	void W_TrapAttack() {
		let targ = target;
		if (targ) {
			int damage = random[spikerTrap](1, 8) * 2;
			A_StartSound("Spiders/Attack", CHAN_WEAPON);
			int newdam = targ.DamageMobj (self, self, damage, "Melee");
			targ.TraceBleed (newdam > 0 ? newdam : damage, self);
			
		}
	}

	Default {
		//$Category "Monsters/WoS"
		//$Title "Spiker Trap"
		
		-FRIENDLY
		+FLOORCLIP
		
		Tag "$TAG_spikerTrap";
		Radius 8;
		Height 12;
		Monster;
		Speed 0;
		Health 256;
		Mass 10000;
		PainChance 200;
	
	}
	
	States {
		Spawn:
			TRAP A 1 A_Look();
			Loop;
			
		See:
			TRAP A 1 A_Chase("Melee");
			Loop;
		
		Melee:
			TRAP A 2;
			TRAP B 3 W_TrapAttack();
			TRAP A 2;
			TRAP B 3 W_TrapAttack();
			TRAP A 2;
			TRAP B 3 W_TrapAttack();
			TRAP A 4;
			goto See;
		Death:
			TNT1 A 0 A_SpawnItemEx("dummy_explosion");
            TNT1 A 0 W_rewardXP(SpawnHealth()/8);
			TRAP A -1;
			Stop;
	}
}
class spikerTrapFriendly : spikerTrap {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Spiker Trap friendly"
		+FRIENDLY
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// reikall's voxel sentinel - cool stuff :) ///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class RV_Sentinel : Sentinel {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Sentinel vox"
		+DONTINTERPOLATE
		
	}
	action void W_rewardXPsentinel (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}
	
	States {
		Spawn:
			SEWR W 1 
			{
				A_Look(); 
				A_SpawnItemEx("RV_SentinelBright");
			}
			SEWR WWWWWWWWW 1 A_SpawnItemEx("RV_SentinelBright");
			Loop;
		See:
			SEWR W 1 {
				A_SentinelBob(); 
				A_SpawnItemEx("RV_SentinelBright");
			}
			SEWR WWWWW 1 A_SpawnItemEx("RV_SentinelBright");
			SEWR W 1 {
				A_Chase(); 
				A_SpawnItemEx("RV_SentinelBright");
			}
			SEWR WWWWW 1 A_SpawnItemEx("RV_SentinelBright");
			Loop;
		Missile:
			SEWR X 1 {
				A_FaceTarget(); 
				A_SpawnItemEx("RV_SentinelBright", 0, 0, 8);
			}
			SEWR XXX 1 A_SpawnItemEx("RV_SentinelBright", 0, 0, 8);
			SEWR Y 1 {
				A_SentinelAttack(); 
				A_SpawnItemEx("RV_SentinelBright", 0, 0, 16);
			}
			SEWR YYYYYYY 1 A_SpawnItemEx("RV_SentinelBright", 0, 0, 16);
			SEWR Y 1 {
				A_SentinelRefire(); 
				A_SpawnItemEx("RV_SentinelBright", 0, 0, 16);
			}
			SEWR YYY 1 A_SpawnItemEx("RV_SentinelBright", 0, 0, 16);
			Goto Missile+1;
		Death:
			SEWR D 7 A_Fall();
			SEWR E 8 Bright A_TossGib();
			SEWR F 5 Bright A_Scream();
			SEWR GH 4 Bright A_TossGib();
            TNT1 A 0 W_rewardXPsentinel(SpawnHealth());
			SEWR I 4;
			SEWR J 5;
			Stop;
	}
}
class RV_SentinelBright : actor {
	Default {
		+NOINTERACTION
	}
	
	States {
		Spawn:
			SEWR Z 2 BRIGHT;
			stop;
	}
}*/
class RV_CeilingTurret : CeilingTurret replaces CeilingTurret {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Ceiling Turret vox"
		+DONTINTERPOLATE
	}
	action void W_rewardXPturret (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}
	
	States {
		Spawn:
			TURT A 1 BRIGHT A_TurretLook(); 
			TURT AAAA 1 BRIGHT;
			Loop;
		See:
			TURT A 1 BRIGHT A_Chase();
			TURT A 1 BRIGHT;
			Loop;
		Missile:
		Pain:
			TURT B 4 Slow {
				A_SpawnProjectile("wosMonsterTracer_Acolyte", -1.0, 0, frandom(-8.0, 8.0), 0, frandom(-8.0, 8.0));
				A_StartSound ("monsters/rifle");
			}
			TURT B 4 {
				A_SpawnProjectile("wosMonsterTracer_Acolyte", -1.0);
				A_StartSound ("monsters/rifle");
			}
			TURT D 3 Slow A_SentinelRefire();
			TURT A 4 A_SentinelRefire();
			Loop;
		Death:
			BALL A 6 Bright A_Scream();
			BALL BCDE 6 Bright;
            TNT1 A 0 W_rewardXPturret(SpawnHealth());
			TURT C -1;
			Stop;
	}
}
class RV_TurretBase : actor {
	Default {
		+NOINTERACTION
	}
	
	States {
		Spawn:
			TURT X 2 SLOW;
			stop;
	}
}
/*class hackedSentinel : RV_Sentinel {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Hacked Sentinel"
		
		Tag "$TAG_hackedSentinel";
	}
}
class friendSentinel : RV_Sentinel {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Friendly Sentinel"
		
		+FRIENDLY
		
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  zombie mutant /////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class ZombieFodder : wosMonsterBase {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Zombie Fodder"
		
		+FLOORCLIP
		
		Tag "$T_ZOMBIEFODDER";
		Health 55;
		GibHealth 20;
		Radius 20;
		Height 56;
		Speed 10;
		PainChance 256;
		Monster;
		SeeSound "ZombieFodder/sight";
		PainSound "ZombieFodder/pain";
		DeathSound "ZombieFodder/death";
		ActiveSound "ZombieFodder/active";
		Obituary "%o joins the zombies.";
	}
	
	States {
		Spawn:
			ZFOD AB 10 A_Look();
			Loop;
		See:
			ZFOD AABBCCDD 4 A_Chase();
			Loop;
		Melee:
			ZFOD EF 10 A_FaceTarget();
			ZFOD G 8 A_CustomMeleeAttack(random(2,16)*(random(1,2)),"ZombieFodder/Melee");
			Goto See;
		Pain:
			ZFOD H 4;
			ZFOD H 4 A_Pain();
			Goto See;
		Death:
			ZFOD I 7;
			ZFOD J 7 A_Scream();
			ZFOD K 5 A_NoBlocking();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			ZFOD L 5;
			ZFOD M -1;
			Stop;
		XDeath:
			ZFOD N 5;
			ZFOD O 5 A_XScream();
			ZFOD P 5 A_NoBlocking();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			ZFOD QR 5;
			ZFOD S -1;
			Stop;
		Raise:
			ZFOD L 5;
			ZFOD KJI 5;
			Goto See;
	}
}


class ZombFlesh : actor {
	Default {
		+CANBOUNCEWATER
		-NOGRAVITY
		+NOBLOCKMAP 
		//+MISSILE
		
		Radius 4;
		Height 9;
		Health 40;
		Damage (10);
		Speed 35;
		Gravity 0.5;
		Mass 0;
		PROJECTILE;
		ReactionTime 120;
		Seesound "ZFlesh/Throw";
	}
	
	States {
		Spawn:
			ZGIB A 1 A_SpawnItemEx("ZombFleshTrail",0,0,0);
			Loop;
		Death:
			TNT1 B 1 A_StartSound ("ZFlesh/miss", 0);
			Stop;
		XDeath:
			TNT1 B 1 A_StartSound ("ZFlesh/hit", 0);
			Stop;
	}
}

class ZombFleshTrail : actor {
	Default {
		+NOBLOCKMAP
		+NOTELEPORT
		+NOGRAVITY
		
		Health 3;
		Scale 0.8;
		RenderStyle "Translucent";
		Alpha 0.8;
	}
	States {
		Spawn:
			BL0D ABCD 3;
			Stop;
	}
}

class FodderSoul : actor {
	Default {
		+NOBLOCKMAP
		+NOGRAVITY
	}
	
	States {
		Spawn:
			ZFSL ABC 5;
			ZFSL DEFG 9;
			Stop;
	}
}

class fodderGhoul : ZombieFodder {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Ghoul"
		
		Tag "$TAG_fodderGhoul";
		Health 100;
	}
	
	States {
		  Spawn:
			GHUL AB 10 A_Look();
			Loop;
		  See:
			GHUL AABBCCDD 4 A_Chase();
			Loop;
		  Melee:
			GHUL EF 10 A_FaceTarget();
			GHUL G 8 A_CustomMeleeAttack(random(2,16)*(random(1,2)),"ZombieFodder/Melee");
			Goto See;
		  Pain:
			GHUL H 4;
			GHUL H 4 A_Pain();
			Goto See;
		  Death:
			GHUL I 7;
			GHUL J 7 A_Scream();
			GHUL K 5 A_NoBlocking();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			GHUL L 5;
			GHUL M -1;
			Stop;
		  XDeath:
			GHUL N 5;
			GHUL O 5 A_XScream();
			GHUL P 5 A_NoBlocking();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			GHUL QR 5;
			GHUL S -1;
			Stop;
		  Raise:
			GHUL L 5;
			GHUL KJI 5;
			Goto See;
	}	
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mini sentinel //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class MiniSentinel : wosMonsterBase {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Mini Sentinel"
		
		+SPAWNCEILING
		+NOGRAVITY
		+DROPOFF
		+NOBLOOD
		+NOBLOCKMONST
		+INCOMBAT
		+MISSILEMORE
		+LOOKALLAROUND
		+NEVERRESPAWN
		
		Tag "$TAG_MiniSentinel";
		Health 50;
		Painchance 255;
		Speed 7;
		Radius 12;
		Height 26;
		Mass 300;
		MONSTER;
		SeeSound "sentinel/sight";
		DeathSound "sentinel/death";
		ActiveSound "sentinel/active";
		Obituary "%o was vaporized by a mini sentinel";
	}
	
	States {
		Spawn:
			MNDR A 10 A_Look();
			loop;
		See:
			MNDR A 6 A_SentinelBob();
			MNDR A 6 A_Chase();
			loop;
		Missile:
			MNDR A 4 A_FaceTarget();
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX2",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			MNDR A 4 A_FaceTarget();
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX2",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			MNDR A 4 A_FaceTarget();
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX2",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			MNDR B 1 BRIGHT A_SpawnProjectile("SentinelFX1",15,0,0);
			goto see;
		Pain:
			MNDR A 5 A_Pain();
			goto see;
		Death:
			MNDR C 7 BRIGHT A_Fall();
			MNDR D 5 BRIGHT A_Scream();
			MNDR E 5 BRIGHT A_TossGib();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			MNDR F 5 BRIGHT;
			MNDR G 5 BRIGHT A_TossGib();
			MNDR HI 5 BRIGHT;
			stop;
	}
}
class LaserBolt : actor {
	Default {
		+STRIFEDAMAGE
		+NOEXTREMEDEATH
		+SPAWNSOUNDSOURCE
		
		Speed 30;
		Radius 10;
		Height 8;
		Damage 8;
		Projectile;
		RenderStyle "Add";
		DamageType "disentegrate";
		SeeSound "LaserCannon/Fire";
		DeathSound "LaserCannon/End";
		Decal "PlasmaScorchLower";
	}
	
	States {
		Spawn:
			TNT1 A 0;
			TNT1 A 1 ThrustThingZ(0, random (-7, 1), 0, 1);
		Fly:
			TNT1 A 1 A_SpawnItem("LaserBoltTrail");
			Loop;
		Death:
			POW1 FGHIJ 2 bright;
			Stop;
	}
}

class LaserBoltTrail : actor {
	Default {
		+NOINTERACTION
		+CLIENTSIDEONLY

		Renderstyle "Add";
	}
	
	States {
		Spawn:
			SHT1 AB 1 Bright A_FadeOut (0.1);
			Loop;
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// paladin robot //////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class Paladin : wosMonsterBase {
	Default {
		//$Category "Monsters/WoS"
		//$Title "Paladin"
		
		+FLOORCLIP
		+NOBLOOD
		+MISSILEMORE
		
		Tag "$TAG_Paladin";
		obituary "A paladin's laser cannon wiped the smile off of %o's face.";
		health 750;
		radius 32;
		height 96;
		mass 1000;
		speed 8;
		painchance 50;
		scale 0.75;
		painsound "Robot/Pain";
		deathsound "Robot/Death";
		MONSTER;
	}
	
	states {
		Spawn:
			RROB B 10 A_Look();
			loop;
		See:
			RROB A 4 A_Chase();
			RROB A 0 A_StartSound ("Robot/Step", 0);
			RROB AA 4 A_Chase();
			RROB BB 4 A_Chase();
			RROB C 4 A_Chase();
			RROB C 0 A_StartSound ("Robot/Step", 0);
			RROB CC 4 A_Chase();
			RROB BB 4 A_Chase();
			loop;
		Missile:
			RROB D 16 A_FaceTarget();
			RROB D 0 A_StartSound ("Robot/Step", 0);
		Fire:
			RROB D 2 Bright A_SpawnProjectile("LaserBolt", 60, 12, random (-2, 2), 1);
			RROB D 3 A_CposRefire();
			loop;
		Pain:
			RROB E 2;
			RROB E 2 A_Pain();
			goto See;
		Death:
			RROB F 6;
			RROB G 6 A_Scream();
			RROB H 6;
			RROB I 6 A_NoBlocking();
			RROB J 6;
			RROB K 6 A_StartSound ("Robot/Fall", 0);
            TNT1 A 0 W_rewardXP(SpawnHealth());
			RROB L -1;
			stop;
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// binder npc friendly ////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class binderNPC : actor {
	Default {
		//$Category "Other NPCs"
		//$Title "Binder NPC"
		
		+FRIENDLY
		-COUNTKILL
		
		radius 16;
		height 56;		
		Monster;
		Health 120;
		PainChance 250;
		Speed 10;	
		Tag "$TAG_binderNPC";
		Obituary "";
		ATTACKSOUND "grunt/attack";
		SeeSound "rebel/sight";
		PainSound "rebel/pain";
		DeathSound "rebel/death";
		ActiveSound "rebel/active";
	}
	
	States {
		Spawn:
			RNGS A 5 A_Look2();
			Loop;
			RNGS A 8;
			Loop;
			RNGS A 8;
			Loop;
            RNGP ABCDABCD 6 A_Wander();
            Loop;
		See:
			RNGP AABBCCDD 6  A_Chase();
			Loop;
		Missile:
			RNGP E 10 A_FaceTarget();
            RNGP F 12 Bright A_SpawnProjectile("BlasterTracer", 32, 0, 0);
            RNGP F 10 A_SpawnProjectile("BlasterTracer", 32, 0, 0);
			Goto See;	
		Pain:
			RNGP O 4;
			RNGP O 4 A_Pain();
			Goto See;
		Death:
			RNGP G 8;		
			RNGP H 10;
			RNGP I 10 A_PlayerScream();
			RNGP J 10 A_NoBlocking();
			RNGP KLM 10;
			RNGP N -1;
			Stop;
		XDeath:
			RNGP G 8; 		
			RNGP H 10;
			RNGP I 10 A_PlayerScream();
			RNGP J 10 A_NoBlocking();
			RNGP KLM 10;
			RNGP N -1;
			Stop;
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// shooting stalker ///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class shootingStalker : Stalker {
	Default {
		//$category "Monsters/WoS"
		//$Title "shooting stalker"
		+NOGRAVITY
		+DROPOFF
		+NOBLOOD
		+SPAWNCEILING
		+INCOMBAT
		+NOVERTICALMELEERANGE

        Tag "$TAG_shootingStalker";
		Health 60;
		Painchance 40;
		Speed 16;
		Radius 31;
		Height 25;
		Monster;
		MaxDropOffHeight 32;
		MinMissileChance 150;
		SeeSound "stalker/sight";
		AttackSound "stalker/attack";
		PainSound "stalker/pain";
		DeathSound "stalker/death";
		ActiveSound "stalker/active";
		HitObituary "$OB_STALKER";
	}
	action void W_rewardXPstalker (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}

	States {
        Spawn:
            STLK A 1 A_StalkerLookInit;
            Loop;
        LookCeiling:
            STLK A 10 A_Look;
            Loop;
        LookFloor:
            STLK J 10 A_Look;
            Loop;
        See:
            STLK A 1 Slow A_StalkerChaseDecide;
            STLK ABB 3 Slow A_Chase;
            STLK C 3 Slow A_StalkerWalk;
            STLK C 3 Slow A_Chase;
            Loop;
        Melee:
            STLK J 3 Slow A_FaceTarget;
            STLK K 3 Slow A_StalkerAttack;
        Missile:
            STLK C 2 A_StalkerDrop;
            STLK J 3 Slow A_FaceTarget;
            STLK M 3 A_ShootGun();
            STLK J 3 Slow A_FaceTarget;
            STLK M 3 A_ShootGun();
            STLK J 3;
        SeeFloor:
            STLK J 3 A_StalkerWalk;
            STLK KK 3 A_Chase;
            STLK L 3 A_StalkerWalk;
            STLK L 3 A_Chase;
            Loop;
        Pain:
            STLK L 1 A_Pain;
            Goto See;
        Drop:
            STLK C 2 A_StalkerDrop;
            STLK IHGFED 3;
            Goto SeeFloor;
        Death:
            STLK O 4;
            STLK P 4 A_Scream;
            STLK QRST 4;
            STLK U 4 A_NoBlocking;
            TNT1 A 0 W_rewardXPstalker(SpawnHealth());
            STLK VW 4;
            STLK XYZ[ 4 Bright;
            Stop;
	}	
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// acolytes ///////////////////////////////////////////////////////////////////////////////////////////////////
// looting code from Lost Frontier, credits to jarewill ///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Class wosGrenadeBase : Actor {
	int fusetime; property FuseTime : fusetime;
	Default {
		Health 5;
		Speed 1;
		Radius 4;
		Height 4;
		Mass 10;
		Damage 1;
		Projectile;
		-NOGRAVITY
		+STRIFEDAMAGE
		+BOUNCEONACTORS
		+EXPLODEONWATER
		-NOBLOCKMAP; +SOLID;
		+SHOOTABLE; +NOBLOOD;
		MaxStepHeight 4;
		BounceType "Doom";
		BounceFactor 0.5;
		+MTHRUSPECIES;
	}
	Override bool CanCollideWith(Actor other, bool passive) {
		If( passive ) {
			If(other.GetPlayerInput(MODINPUT_BUTTONS)&BT_USE) {
				angle=other.angle;
				A_ChangeVelocity(12,0,6,CVF_RELATIVE|CVF_REPLACE);
				SetStateLabel("Spawn");
			}
		}
		If( other.bMISSILE ){ Return 1; }
		Else{ Return 0; } //Super.CanCollideWith(other,passive);
	}
	Override void Tick() {
		Super.Tick();
		If(InStateSequence(CurState,ResolveState("Spawn"))&&vel.length()<1){SetStateLabel("Death");}
		If(InStateSequence(CurState,ResolveState("Explode"))){A_Stop();}
	}
	Action void B_NadeCountdown() {
		If(Invoker.FuseTime<=0||Invoker.health<=0){SetStateLabel("Explode");}
		If(Invoker.bSHOOTABLE==0){Invoker.bSHOOTABLE=1;}
		Else{Invoker.FuseTime--;}
	}
}
Class wosBulletPuff : StrifePuff {
	States {
        Spawn:
            PUFY A 4 Bright;
            PUFY BCD 4;
            Stop;
	}
}
Class wosBulletSpark : StrifePuff {
	States {
        Spawn:
            POW3 ABCDEFGH 3;
            Stop;
	}
}
Class wosBulletBase : FastProjectile {
	Array<Actor> ShotList;
	int penetration; property Penetration : penetration;
	int BulletDmg; property BulletDmg : BulletDmg;
	Default {
		Radius 2;
		Height 2;
		Decal "BulletChip";
		MissileType "wosBulletDebug";
		MissileHeight 8;
		DamageType "Bullet";
		ProjectileKickback 50;
		+MTHRUSPECIES; 
        +NOEXTREMEDEATH;
	}
	States {
        Spawn:
            TNT1 A 1 A_ChangeVelocity(0,0,-1);
            Loop;
        Death:
            TNT1 A 0 A_AlertMonsters(128);
            TNT1 A 0 A_SpawnItemEx("wosBulletPuff");
            Stop;
        Crash:
            TNT1 A 0 A_AlertMonsters(128);
            TNT1 A 0 A_SpawnItemEx("wosBulletSpark");
            Stop;
        XDeath:
            TNT1 A 0;
            Stop;
	}
	Override int SpecialMissileHit(Actor victim) {
		If(ShotList.Find(victim) == ShotList.Size()) {
			If(victim==Self.target){ Return 1; }
			Else {
				victim.DamageMobj(Self,target,Self.BulletDmg*Random(1,4),"Bullet"); ShotList.Push(victim);
				If(victim.bSHOOTABLE&&!victim.bNOBLOOD){victim.SpawnBlood(self.pos,self.angle,self.BulletDmg);}
				If(Self.Penetration>victim.Mass){Self.Penetration-=(victim.Mass); Return 1;}
				Else{Return 0;}
			}
		}
		Else{ Return 1; }
	}
}
Class wosBulletDebug : Actor {
	Default{
        +NOGRAVITY;
    }
	States {
		Spawn:
			PUFY A 0 NoDelay Bright {If(GetCVar("wos_debug")){A_SetTics(35);}}
			Stop;
	}
}

Class wos542 : wosBulletBase {
	Default {
		Speed 640;
		wosBulletBase.Penetration 150;
		wosBulletBase.BulletDmg 2; //10
		Obituary "%o was shot down by %k's assault rifle.";
	}
}

// base monster fancy projectile ///////////////////////////////////////////////
/*	
	TRACER SYSTEM FOR ZSCRIPT 2.4 | APRIL 7TH 2017
	AUTHOR: (DENIS) BELMONDO
	
	USAGE: make a new class, inherit from soa_monsterTracer and change the properties as
		   you wish.
	
	you may use this in your project. just leave this comment at the top of 
	this script and give credit please! thank you :^)	
*/
class wosMonsterTracer : FastProjectile {

	const TRACERDURATION	= 1; // tics
	const TRACERFANCY		= 0; // fake bool
	const TRACERLENGTH		= 96.0; // float
	const TRACERSCALE		= 4.0; // float
	const TRACERSTEP		= 0.01; // float
	const TRACERFANCYSTEP	= 0.01; // float
	const TRACERACTOR		= "wos_monsterTracerTrail"; // actor name

	float x1, y1, z1;
	float x2, y2, z2;
	
	// intentional briticism to avoid conflicts with "color" keyword.
	static const color colours[] = {
		"9b 5b 13",
		"af 7b 1f",
		"c3 9b 2f",
		"d7 bb 43",
		"ff ff 73",
		"ff ff 73" /* appears twice so a segment of this color is longer
					than the others. */
	};
	
	// literally just stole this from wikipedia
	float lerp(float v0, float v1, float t) {
		return (1 - t) * v0 + t * v1;
	}
	
	override void BeginPlay() {
		// we don't want to lerp into weird coordinates
		x1 = pos.x;
		y1 = pos.y;
		z1 = pos.z;
		
		x2 = pos.x;
		y2 = pos.y;
		z2 = pos.z;
	}
	
	override void Tick() {	
		if (Level.isFrozen()) return;
		
		x1 = pos.x;
		y1 = pos.y;
		z1 = pos.z;
		
		x2 = pos.x + vel.x / GetDefaultSpeed("wosMonsterTracer") * TRACERLENGTH;
		y2 = pos.y + vel.y / GetDefaultSpeed("wosMonsterTracer") * TRACERLENGTH;
		z2 = pos.z + vel.z / GetDefaultSpeed("wosMonsterTracer") * TRACERLENGTH;
		
		if (TRACERFANCY == 0) {
			for(float i = 0; i < 1; i += TRACERSTEP) {
				A_SpawnParticle (
					colours[clamp(i * colours.Size(), 0, colours.Size() - 1)],
					SPF_FULLBRIGHT,
					TRACERDURATION,
					TRACERSCALE * i,
					0,
					(-pos.x) + lerp(x1, x2, i),
					(-pos.y) + lerp(y1, y2, i),
					(-pos.z) + lerp(z1, z2, i),
					0, 0, 0,
					0, 0, 0,
					1.0
				);
			} 
		}
		else {
			for(float i = 0; i < 1; i += TRACERFANCYSTEP) {
				A_SpawnItemEx (
					TRACERACTOR,
					(-pos.x) + lerp(x1, x2, i),
					(-pos.y) + lerp(y1, y2, i),
					(-pos.z) + lerp(z1, z2, i),
					0, 0, 0, 0,
					SXF_ABSOLUTEPOSITION
				);
			}
		}
		Super.Tick();
	}
	Default {
		//Damage (random(5,9));
		DamageType "Bullet";
		Height 1;
		Radius 1;
		Speed 125;
		fastspeed 160;
		+BLOODSPLATTER;
	}
	States {
		Spawn:
			TNT1 A 1;
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("BulletPuff");
		XDeath:
			TNT1 A -1 A_Jump(256, "Null");
			Stop;
	}	
}
class wos_monsterTracerTrail : Actor {
	Default {
		Alpha 0.5;
		RenderStyle "Add";
		Scale 0.25;
		+NOINTERACTION;
	}
	States {
		Spawn:
			PUFF A 2 Bright;
			TNT1 A -1 A_Jump(256, "Null");
			Stop;
	}
}
// damage type for different types of enemies //
class wosMonsterTracer_Acolyte : wosMonsterTracer {
	Default {
		DamageFunction (3*random(1,5));
	}
}
class wosMonsterTracer_Rebel : wosMonsterTracer {
	Default {
		DamageFunction (3*random(5,10));
	}
}
////////////////////////////////////////////////////////////////////////////////

Class wosAcolyte : Acolyte replaces Acolyte {
	int gunmag;
	int sighttimer;
	int searchtimer;
	bool searched;
	bool lootmed;
	bool lootarm;
	int lootarm2;
	bool lootgun;
	int lootgun2;
	int lootmoney;
	bool lootrep;
	string looteqip; Property Equipment : looteqip;
	int looteqip2;
	bool grenout;
	bool grenon;
	bool wounded;
	int woundtimer;
	int healtimer;
	bool nowound;
	Actor prevtarg;
	bool shielded; Property Shielded : shielded;
	bool healed;
	int noescape;
	Default {
		PainChance "Bleeding", 0;
		Species "wosAcolyte";
	}
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		gunmag=30;
		If(shielded==1){A_SpawnItemEx("wosAcolyteShield",flags: SXF_SETMASTER);}
		If(Random(1,3)==1){lootmed=1;} If(Random(1,8)==1){lootarm=1; lootarm2=Random(15,85);}
		If(Random(1,6)==1){lootgun=1; lootgun2=Random(50,600);} If(Random(1,10)==1){lootrep=1;}
		lootmoney=Random(3,15);
	}
	Override void Tick() {
		Super.Tick();
		If(health>0) {
			If(healed==0) {
				For(let i = BlockThingsIterator.Create(self,1024); i.Next();) {
					Actor other = i.thing;
					If(other==self)
					{Continue;}
					double distance = Distance3D(other);
					If(distance>1024)
					{Continue;}
					If(target!=null&&CheckSight(target))
					{Continue;}
					If(other is "wosAcolyte"&&other.InStateSequence(other.CurState,other.ResolveState("Wound")))
					{
						prevtarg=target;
						target=other;
					}
				}
			}
			If(wounded==1) {
				If(woundtimer>=35) {
					DamageMobj(null,null,1,"Bleeding");
					SpawnBlood((pos.x+random(-8,8),pos.y+random(-8,8),pos.z+16),angle,1);
					woundtimer=0;
				}
				Else{woundtimer++;}
			}
			If(healtimer>0) {
				If(woundtimer>=18){GiveBody(1); healtimer--; woundtimer=0;}
				Else{woundtimer++;}
			}
		}
		If(shielded==0&&sprite==GetSpriteIndex("AGRD")){sprite=GetSpriteIndex("ATRP");}
	}
	Override bool Used(Actor user) {
		let pawn = binderPlayer(user);
		If( searched==0 && health<1 && InStateSequence(CurState,ResolveState("Death")) && user is "binderPlayer" && pawn.currentarmor!=4 ) {
			int tosearch = 6 - (2 * pawn.SpeedUpgrade);
			If( searchtimer >= tosearch ) {
				If( lootmed == 1 ){ 
					Actor med = A_DropItem("wosHyposprej"); 
				}
				If( lootarm == 1 ){ 
					Actor arm = A_DropItem("wosLeatherArmor"); 
				}
				If( looteqip == "TARG" ){ 
					Actor trg = A_DropItem("wosTargeter"); 
				}
				While( lootmoney > 0 ) {
					If( lootmoney >= 25 ){ 
						A_DropItem("Gold25"); 
						lootmoney-=25; 
					} Else If( lootmoney >= 10 ){ 
						A_DropItem("Gold10"); 
						lootmoney-=10; 
					} Else If(lootmoney>=1){
						A_DropItem("coin"); 
						lootmoney--;
					}
				}
				If( lootgun == 1 ){ Actor gun = A_DropItem("wosAssaultGun"); }
				Else If( gunmag > 1 ){ Actor mag = A_DropItem("ClipOfBullets",gunmag/2); }
				If( lootrep == 1 ){ Actor rep = A_DropItem("wosArmorShard"); }
				searched = 1;
			} Else {
				A_ChangeVelocity(frandom(-0.5,0.5),frandom(-0.5,0.5));
				A_StartSound("sound/wearClothing");
				searchtimer++;
			}
		}
		Return Super.Used(user);
	}

	// usage: W_rewardXPacolyte(SpawnHealth());   //	
	action void W_rewardXPacolyte (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}

	States {
		Spawn:
			AGRD A 0 {reactiontime=8;}
			AGRD A 5 A_Look2();
			Loop;
			AGRD B 8 A_ClearShadow();
			Loop;
			AGRD D 8;
			Loop;
			AGRD ABCDABCD 6 A_Wander();
			Loop;
		ShieldDown:
			AGRD A 18;
			AGRD A 0 W_checkMeleeRange(1);
			Goto See;
		See:
			//AGRD A 0 {If(target!=null&&target.health<1){SetStateLabel("See2");}}
			//AGRD A 0 A_CheckRange(1024,"See2");
			//AGRD A 0 A_CheckSight("See2");
			//AGRD A 0 A_Chase(null,null,CHF_DONTMOVE|CHF_DONTTURN);
			AGRD A 0 {
				If(target is "wosAcolyte")
				{sighttimer=0; SetStateLabel("See2");}
				Else If(shielded==0&&health<=30&&healed==0&&noescape<3)
				{bFRIGHTENED=1; speed=14; sighttimer=0; SetStateLabel("RunAway");}
				Else{bFRIGHTENED=0; speed=7;}
			}
			AGRD A 0 A_JumpIfTargetInLOS(1,90,JLOSF_DEADNOJUMP,1024);
			Goto See2;
			AGRD A 0 {A_FaceTarget(); W_checkAlly();}
			AGRD E 4 Slow Fast {sighttimer=140; A_FaceTarget(); If(reactiontime<=0){SetStateLabel("Missile");}Else{reactiontime--;}}
			AGRD A 0 W_checkMeleeRange();
			Loop;
		See2:
			AGRD A 0 {If(sighttimer>0){SetStateLabel("See3");}}
			AGRD A 4 Fast Slow {A_Chase("Melee",null); A_AcolyteBits(); reactiontime=8;}
			AGRD BCD 4 Fast Slow {A_Chase("Melee",null); reactiontime=8;}
			Goto See;
		RunAway:
			AGRD A 0 A_CheckSight("HealUp");
			AGRD A 4 Fast Slow {A_Chase("Melee",null); A_AcolyteBits(); reactiontime=8;}
			AGRD BCD 4 Fast Slow {A_Chase("Melee",null); reactiontime=8;}
			Goto See;
		HealUp:
			AGRD OOOO 8 A_StartSound("misc/swish",CHAN_WEAPON);
			AGRD O 18;
			AGRD OO 8 A_StartSound("misc/meathit",CHAN_VOICE);
			AGRD O 18 W_acolyteHeal(1);
			Goto See;
		See3:
			AGRD E 1 {sighttimer--; reactiontime=8;}
			Goto See;
		SeePain:
			AGRD A 0 {A_FaceTarget(); reactiontime=8;}
			Goto See;
		Missile:
			AGRD E 0 {If(reactiontime>0){SetStateLabel("See");}}
			AGRD E 0 A_FaceTarget();
			AGRD E 0 {If(invoker.gunmag<1){SetStateLabel("Dry");}}
			AGRD A 0 A_CheckRange(512,"Missile2");
			AGRD A 0 A_JumpIf(looteqip=="GASG"&&grenout==0&&Random(1,4)==1,"MissileGren");
			AGRD FEF 3 W_shootGun();
			AGRD A 0 {If(looteqip=="TARG"){SetStateLabel("See");}}
			AGRD A 0 A_SentinelRefire();
			Goto Missile+1;
		Missile2:
			AGRD F 3 W_shootGun(1);
			AGRD E 3;
			Goto See;
		MissileGren:
			AGRD O 16 {A_StartSound("weapons/grenfuse",CHAN_WEAPON); grenon=1;}
			AGRD E 4 W_throwGas();
			Goto See;
		Melee:
			AGRD O 0 A_FaceTarget();
			AGRD O 0 A_JumpIf(target is "wosAcolyte","HealAlly");
			AGRD O 0 A_JumpIf(shielded==0,2);
			AGRD O 4 W_acolytePunch();
			Goto See;
			AGRD PQ 7 A_StopSound(CHAN_WEAPON);
			AGRD R 14 W_acolytePunch();
			Goto See;
		HealAlly:
			AGRD EEEE 8 A_StartSound("misc/swish",CHAN_WEAPON);
			AGRD E 18 {If(Invoker.target.health<1){Invoker.target=Invoker.prevtarg; SetStateLabel("See");}}
			AGRD EE 8 A_StartSound("misc/meathit",CHAN_VOICE);
			AGRD E 18 W_acolyteHeal();
			Goto See;
		Dry:
			AGRD E 1;
			AGRD E 8 A_StartSound("weapons/reload",CHAN_WEAPON);
			AGRD O 18;
			AGRD O 8 {
				A_StartSound("weapons/reload",CHAN_WEAPON);
				//A_SpawnItemEx("wosEmptyClip",0,0,0,0,8.25);
				gunmag=30;
				reactiontime=8;
			}
			AGRD O 12 A_StartSound("weapons/chamber",CHAN_WEAPON);
			Goto See;
		Pain:
			AGRD O 0 {
				If(Invoker.grenon==1) {
					Actor grenade = A_SpawnProjectile("wosGasGrenade");
					grenade.A_ChangeVelocity(0,0,0,CVF_REPLACE);
					Invoker.grenout=1; Invoker.grenon=0;
				}
				If(shielded==0&&health<=30&&healed==0){noescape++;}
			}
			AGRD O 8 Fast Slow {A_Pain(); A_AlertMonsters(96); reactiontime=8;}
			Goto SeePain;
		Wound:
			AGRD G 0 A_JumpIf(Invoker.nowound==1,"Pain");
			AGRD G 4 A_JumpIf(Invoker.wounded==1,7);
			AGRD H 4 {A_Scream(); A_AlertMonsters(256);}
			AGRD I 4;
			AGRD J 3;
			AGRD K 3 {height=16; A_StopSound(CHAN_VOICE);}
			AGRD L 3;
			AGRD M 3 {wounded=1; bINCOMBAT=1;}
			AGRD N 1 A_ChangeVelocity(frandom(-0.05,0.05),frandom(-0.05,0.05));
			Wait;
		WoundEnd:
			AGRD N 1 A_JumpIf(Invoker.health>=10,"Raise");
			Wait;
		Raise:
			AGRD A 0 {height=64; shielded=0;}
			AGRD MLKJ 3;
			AGRD IHG 4;
			Goto See;
		Death:
			AGRD G 4 {If(Invoker.wounded==1){A_NoBlocking(); A_StartSound(DeathSound,CHAN_VOICE,0,0.75); A_AlertMonsters(64); SetStateLabel("DeathEnd");}}
			AGRD H 4 {A_Scream(); A_AlertMonsters(256);}
			AGRD I 4;
			AGRD J 3;
			AGRD K 3 A_NoBlocking();
			AGRD L 3;
			AGRD M 3 A_AcolyteDie();
		DeathEnd:
			//TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
			AGRD N -1;
			Stop;
		Death.Stab:
			AGRD G 4;
			AGRD H 4 {
				A_StartSound(DeathSound,CHAN_VOICE,0,0.75);
				A_AlertMonsters(64);
			}
			Goto Death+2;
		XDeath:
			GIBS A 5 A_NoBlocking();
			GIBS BC 5 A_TossGib();
			GIBS D 4 A_TossGib();
			GIBS E 4 A_XScream();
			GIBS F 4 A_TossGib();
			GIBS GH 4;
			GIBS I 5;
			GIBS J 5 A_AcolyteDie();
			//TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
			GIBS K 5;
			GIBS L 1400;
			GIBS L 1 A_FadeOut(0.02);
			Wait;
		Dummy:
			AGRD A 0; ATRP A 0;
	}
	Action void W_shootGun(bool sniper = 0) {
		If(!(Invoker.target is "wosAcolyte")) {
			If(Invoker.gunmag<1){SetStateLabel("Dry");}
			Else {
				double acc = 8.4;
				If(sniper==1){acc=1.4;}
				If(Invoker.looteqip=="TARG"){acc*=0.5;}
				A_FaceTarget();
				A_SpawnProjectile("wosMonsterTracer_Acolyte",32,0,frandom(-acc,acc),0,frandom(-acc,acc));
				A_StartSound("weapons/assaultgun",CHAN_WEAPON);
				A_AlertMonsters(1024);
				Invoker.reactiontime=8;
				Invoker.gunmag--;
			}
		}
	}
	Action void W_throwGas() {
		If(!(Invoker.target is "wosAcolyte")) {
			A_FaceTarget();
			A_SpawnProjectile("wosGasGrenade");
			A_StartSound("misc/swish",CHAN_WEAPON);
			Invoker.grenout=1; Invoker.grenon=0;
		}
	}
	Action void W_checkAlly() {
		FLineTraceData h;
		LineTrace(angle,1024,pitch,0,32,26,data: h);
		If(h.HitActor!=null&&h.HitActor is "wosAcolyte")
		{SetStateLabel("See2");}
	}
	Action void W_checkMeleeRange(bool counter = 0) {
		FLineTraceData h;
		LineTrace(angle,meleerange,pitch,TRF_THRUSPECIES,32,data: h);
		int react = 4;
		If(Invoker.shielded==0){react=0;}
		If(h.HitActor!=null&&h.HitActor==target&&((counter==0&&Invoker.reactiontime<=0)||counter==1))
		{SetStateLabel("Melee");}
	}
	Action void W_acolytePunch() {
		If(!(Invoker.target is "wosAcolyte")) {
			FLineTraceData h;
			LineTrace(angle,meleerange,pitch,TRF_THRUSPECIES,32,data: h);
			int dam = 3; int rec = 10; int apc = 20;
			If(Invoker.shielded==0){dam=1; rec=5; apc=10;}
			A_CustomMeleeAttack(random[AcolyteMelee](1,5)*dam);
			let hitm = h.HitActor;
			If(hitm!=null&&!(hitm is "wosAcolyteShield")) {
				string soundtoplay;
				If(hitm.bNOBLOOD==1){soundtoplay="misc/metalhit";}
				Else{soundtoplay="misc/meathit";}
				A_StartSound(soundtoplay,CHAN_WEAPON);
				rec-=hitm.mass/50; apc-=hitm.mass/25;
				If(rec<0){rec=0;} If(apc<0){apc=0;}
				hitm.A_Recoil(rec);
				hitm.Angle+=frandom(-apc,apc); hitm.pitch+=frandom(-apc,apc);
				If(pitch<=-90){pitch=-90;} If(pitch>=90){pitch=90;}
			}
			Invoker.reactiontime=8;
		}
	}
	Action void W_acolyteHeal(bool slf = 0) {
		If(slf==0) {
			If(Invoker.target is "wosAcolyte") {
				If(Invoker.target.health>0) {
					let ally = wosAcolyte(target);
					ally.wounded=0;
					ally.healtimer=10;
					ally.bINCOMBAT=0;
					ally.nowound=1;
					ally.SetStateLabel("WoundEnd");
				}
				Invoker.target=Invoker.prevtarg;
				Invoker.healed=1;
			}
		}
		Else {
			Invoker.healtimer=10;
			Invoker.healed=1;
			Invoker.bFRIGHTENED=0;
			Invoker.speed=7;
		}
	}
}
Class wos542a : wos542 {
	Default{-MTHRUSPECIES;}
	Override int SpecialMissileHit(Actor victim) {
		If(victim is "wosAcolyteShield"){Return 1;}
		Else{Return Super.SpecialMissileHit(victim);}
	}
}
Class wosAcolyteShield : Actor {
	Default {
		+SHOOTABLE; 
		+NOBLOOD;
		+DONTTHRUST; 
		+NODAMAGE;
		Radius 22;
		Height 20;
		Mass 200;
	}
	Override void Tick() {
		Super.Tick();
		let acol = wosAcolyte(master);
		If(master==null||master.health<1||acol.shielded==0){Destroy();}
		Else {
			let mf = master.frame;
			If(mf==4||mf==5||mf==14){A_Warp(AAPTR_MASTER,4,0,30,0);}
			Else{A_Warp(AAPTR_MASTER,0,0,0,0);}
		}
	}
	Override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle) {
		If(master!=null&&mod=="Melee2"){master.SetStateLabel("ShieldDown"); master.reactiontime=4;}
		Return Super.DamageMobj(inflictor,source,damage,mod,flags,angle);
	}
	States {
		Spawn:
			TNT1 A 1;
			Loop;
	}
}
Class wosGasGrenade : wosGrenadeBase {
	Default {
		wosGrenadeBase.FuseTime 70;
		Speed 20;
		Obituary "%o choked on one of %k's gas grenades.";
		+ROLLSPRITE; 
		+ROLLCENTER;
		+FORCEXYBILLBOARD;
	}
	States {
		Spawn:
			GASG BBBBCCCC 1 {B_NadeCountdown(); A_SetRoll(roll-2);}
			Loop;
		Death:
			GASG BBBBCCCC 1 B_NadeCountdown();
			Loop;
		Explode:
			GASG B 1 Bright {
				For(int i; i<2; i++) {
					bool spawn1; Actor spawn2;
					[spawn1, spawn2] = A_SpawnItemEx("wosGasObstacle",Random(-32,32),Random(-32,32));
					spawn2.Reactiontime=Random(60,100);
				}
				A_StartSound("weapons/phgrenadeshoot");
			}
			GASG B 175;
			GASG B 1 A_FadeOut(0.02);
			Wait;
	}
}
Class wosGasObstacle : Actor {
	Default {
		Reactiontime 80;
		+NOBLOCKMAP
		+FLOORCLIP
		+NOTELEPORT
		+NODAMAGETHRUST
		+DONTSPLASH
		RenderStyle "Translucent";
		Alpha 0.85;
		Obituary "%o didn't wear protection.";
		DamageType "Gas";
	}
	States {
		Spawn:
			GASC A 2 A_Countdown();
			GASC B 2 A_Explode(4,64);
			GASC C 2 A_Countdown();
			GASC D 2 A_Explode(4,64);
			GASC E 4 A_Countdown();
			GASC F 4 A_Explode(4,64);
			GASC G 4 A_Countdown();
			GASC H 4 A_Explode(4,64);
			Goto Spawn+4;
		Death:
			GASC E 4 A_FadeOut(0.05);
			GASC F 4 {A_Explode(4,64); A_FadeOut(0.05);}
			GASC G 4 A_FadeOut(0.05);
			GASC H 4 {A_Explode(4,64); A_FadeOut(0.05);}
			Loop;
	}
}

Class wosAcolyteTan : wosAcolyte replaces AcolyteTan {
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
	}
}
Class wosAcolyteRed : wosAcolyte replaces AcolyteRed {
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
		Health 100;
		Translation 0;
		wosAcolyte.Shielded 1;
	}	
}
Class wosAcolyteRust : wosAcolyte replaces AcolyteRust {
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
		Health 80;
		Translation 1;
		wosAcolyte.Shielded 1;
	}	
}
Class wosAcolyteGray : wosAcolyte replaces AcolyteGray {
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
		Translation 2;
	}
}
Class wosAcolyteDGreen : wosAcolyte replaces AcolyteDGreen {
	Default {
		+MISSILEMORE;
		Translation 3;
	}
}
Class wosAcolyteGold : wosAcolyte replaces AcolyteGold {
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		lootmoney=Random(5,25);
		nowound=1;
	}
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
		Health 120;
		Translation 4;
		wosAcolyte.Shielded 1;
		wosAcolyte.Equipment "GASG";
		DamageFactor "Gas", 0;
		PainChance "Gas", 0;
	}
}
Class wosAcolyteLGreen : wosAcolyte replaces AcolyteLGreen {
	Default {
		Health 60;
		Translation 5;
	}
}
Class wosAcolyteBlue : wosAcolyte replaces AcolyteBlue {
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		looteqip2=Random(50,90);
	}
	Default {
		Health 60;
		Translation "32:63=0:31", "80:95=64:79", "128:143=144:159", "192:192=1:1", "193:223=1:31", "235:239=224:228";
		wosAcolyte.Equipment "TARG";
	}
}
Class wosAcolyteShadow : wosAcolyte replaces AcolyteShadow {
	Default {
		+MISSILEMORE; 
		+MISSILEEVENMORE;
		Health 90;
		wosAcolyte.Shielded 1;
	}
}
Class wosAcolyteToBe : wosAcolyte replaces AcolyteToBe {
	Default {
		Health 61;
		Radius 20;
		Height 56;
		DeathSound "becoming/death";
		-COUNTKILL;
		-ISMONSTER;
	}
	States {
		Spawn:
			ARMR A -1;
			Stop;
		Pain:
			ARMR A -1 A_HideDecepticon;
			Stop;
		Death:
			Goto XDeath;
	}
	void A_HideDecepticon () {
		Door_Close(999, 64);
		if (target != null && target.player != null) {
			SoundAlert (target);
		}
	}
}
Class wosDeadAcolyte : wosAcolyte replaces DeadAcolyte {
	Default{-COUNTKILL;}
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		gunmag=Random(5,25);
	}
	States {
		Spawn:
			AGRD N 0 NoDelay A_Die();
		Death:
			AGRD N 0 A_NoBlocking();
			AGRD N -1;
			Stop;
	}
}
Class wosUniqueAcolyte : wosDeadAcolyte {
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		gunmag=30;
		lootmoney=25;
		lootmed=0; lootarm=0; lootarm2=0;
	}
	Default {Translation 5;}
	States {
		Spawn:
			AGRD N 0 NoDelay A_Die();
		Death:
			AGRD N 0 {A_NoBlocking();}
			AGRD N -1;
			Stop;
	}
}
/*class wosAcolyte : Acolyte replaces Acolyte {
	int gunmag; //
	int searchtimer; //
	bool searched; //
	bool lootmed; //
	bool lootarm; //
	int lootarm2; //
	bool lootgun; //
	int lootgun2; //
	int lootmoney; //
	bool lootrep; //
	string looteqip; Property Equipment : looteqip; //
	int looteqip2; //

	Default {
		Species "wosAcolyte";
	}

	// usage: W_rewardXPacolyte(SpawnHealth());   //	
	action void W_rewardXPacolyte (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}
    
	Override void PostBeginPlay() {
		Super.PostBeginPlay();
		gunmag=30;
		//If(shielded==1){A_SpawnItemEx("LFAcolyteShield",flags: SXF_SETMASTER);}
		If(Random(1,3)==1){lootmed=1;} If(Random(1,8)==1){lootarm=1; lootarm2=Random(15,85);}
		If(Random(1,6)==1){lootgun=1; lootgun2=Random(50,600);} If(Random(1,10)==1){lootrep=1;}
		lootmoney=Random(3,15);
	}

	Override bool Used(Actor user) {
		let pawn = binderPlayer(user);
		If( searched==0 && health<1 && InStateSequence(CurState,ResolveState("Death")) && user is "binderPlayer" && pawn.currentarmor!=4 ) {
			int tosearch = 6 - (2 * pawn.SpeedUpgrade);
			If( searchtimer >= tosearch ) {
				If( lootmed == 1 ){ 
					Actor med = A_DropItem("wosHyposprej"); 
				}
				If( lootarm == 1 ){ 
					Actor arm = A_DropItem("wosLeatherArmor"); 
				}
				If( looteqip == "TARG" ){ 
					Actor trg = A_DropItem("wosTargeter"); 
				}
				While( lootmoney > 0 ) {
					If( lootmoney >= 25 ){ 
						A_DropItem("Gold25"); 
						lootmoney-=25; 
					} Else If( lootmoney >= 10 ){ 
						A_DropItem("Gold10"); 
						lootmoney-=10; 
					} Else If(lootmoney>=1){
						A_DropItem("coin"); 
						lootmoney--;
					}
				}
				If( lootgun == 1 ){ Actor gun = A_DropItem("wosAssaultGun"); }
				Else If( gunmag > 1 ){ Actor mag = A_DropItem("ClipOfBullets",gunmag/2); }
				If( lootrep == 1 ){ Actor rep = A_DropItem("wosArmorShard"); }
				searched = 1;
			} Else {
				A_ChangeVelocity(frandom(-0.5,0.5),frandom(-0.5,0.5));
				A_StartSound("sound/wearClothing");
				searchtimer++;
			}
		}
		Return Super.Used(user);
	}
	States {
		Spawn:
			AGRD A 5 A_Look2;
			Wait;
			AGRD B 8 A_ClearShadow;
			Loop;
			AGRD D 8;
			Loop;
			AGRD ABCDABCD 5 A_Wander;
			Loop;
		See:
			AGRD A 6 Fast Slow A_AcolyteBits;
			AGRD BCD 6 Fast Slow A_Chase;
			Loop;
		Missile:
			AGRD E 8 Fast Slow A_FaceTarget;
			AGRD FE 4 Fast Slow A_ShootGun;
			AGRD F 6 Fast Slow A_ShootGun;
			Goto See;
		Pain:
			AGRD O 8 Fast Slow A_Pain;
			Goto See;
		Death:
			AGRD G 4;
			AGRD H 4 A_Scream();
			AGRD I 4;
			AGRD J 3;
			AGRD K 3 A_NoBlocking();
			AGRD L 3;
			AGRD M 3 A_AcolyteDie();
            //TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
			AGRD N -1;
			Stop;
		XDeath:
			GIBS A 5 A_NoBlocking();
			GIBS BC 5 A_TossGib();
			GIBS D 4 A_TossGib();
			GIBS E 4 A_XScream();
			GIBS F 4 A_TossGib();
			GIBS GH 4;
			GIBS I 5;
			GIBS J 5 A_AcolyteDie();
            //TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
			GIBS K 5;
			GIBS L 1400;
			Stop;
	}
}
class wosAcolyteTan : wosAcolyte replaces AcolyteTan {}
class wosAcolyteRed : wosAcolyte replaces AcolyteRed {
	Default {
		Translation 0;
	}
}
class wosAcolyteRust : wosAcolyte replaces AcolyteRust {
	Default {
		Translation 1;
	}
}
class wosAcolyteGray : wosAcolyte replaces AcolyteGray {
	Default {
		Translation 2;
	}
}
class wosAcolyteDGreen : wosAcolyte replaces AcolyteDGreen {
	Default {
		Translation 3;
	}
}
class wosAcolyteGold : wosAcolyte replaces AcolyteGold {
	Default {
		Translation 4;
	}
}
class wosAcolyteLGreen : wosAcolyte replaces AcolyteLGreen {
	Default {
		Translation 5;
	}
}
class wosAcolyteBlue : wosAcolyte replaces AcolyteBlue {
	Default {
		Translation "32:63=0:31", "80:95=64:79", "128:143=144:159", "192:192=1:1", "193:223=1:31", "235:239=224:228";
	}
}
class wosAcolyteShadow : wosAcolyte replaces AcolyteShadow {}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LOST FRONTIER ACOLYTE //////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*Class LFGrenadeBase : Actor
{
	int fusetime; property FuseTime : fusetime;
	Default
	{
		Health 5;
		Speed 1;
		Radius 4;
		Height 4;
		Mass 10;
		Damage 1;
		Projectile;
		-NOGRAVITY
		+STRIFEDAMAGE
		+BOUNCEONACTORS
		+EXPLODEONWATER
		-NOBLOCKMAP; +SOLID;
		+SHOOTABLE; +NOBLOOD;
		MaxStepHeight 4;
		BounceType "Doom";
		BounceFactor 0.5;
		+MTHRUSPECIES;
	}
	Override bool CanCollideWith(Actor other, bool passive)
	{
		If(passive)
		{
			If(other.GetPlayerInput(MODINPUT_BUTTONS)&BT_USE)
			{
				angle=other.angle;
				A_ChangeVelocity(12,0,6,CVF_RELATIVE|CVF_REPLACE);
				SetStateLabel("Spawn");
			}
		}
		If(other.bMISSILE){Return 1;}
		Else{Return 0;} //Super.CanCollideWith(other,passive);
	}
	Override void Tick()
	{
		Super.Tick();
		If(InStateSequence(CurState,ResolveState("Spawn"))&&vel.length()<1){SetStateLabel("Death");}
		If(InStateSequence(CurState,ResolveState("Explode"))){A_Stop();}
	}
	Action void B_NadeCountdown()
	{
		If(Invoker.FuseTime<=0||Invoker.health<=0){SetStateLabel("Explode");}
		If(Invoker.bSHOOTABLE==0){Invoker.bSHOOTABLE=1;}
		Else{Invoker.FuseTime--;}
	}
}
Class LFBulletPuff : StrifePuff
{
	States
	{
	Spawn:
		PUFY A 4 Bright;
		PUFY BCD 4;
		Stop;
	}
}
Class LFBulletSpark : StrifePuff
{
	States
	{
	Spawn:
		POW3 ABCDEFGH 3;
		Stop;
	}
}
Class LFBulletBase : FastProjectile
{
	Array<Actor> ShotList;
	int penetration; property Penetration : penetration;
	int BulletDmg; property BulletDmg : BulletDmg;
	Default
	{
		Radius 2;
		Height 2;
		Decal "BulletChip";
		MissileType "LFBulletDebug";
		MissileHeight 8;
		DamageType "Bullet";
		ProjectileKickback 50;
		+MTHRUSPECIES; +NOEXTREMEDEATH;
	}
	States
	{
	Spawn:
		TNT1 A 1 A_ChangeVelocity(0,0,-1);
		Loop;
	Death:
		TNT1 A 0 A_AlertMonsters(128);
		TNT1 A 0 A_SpawnItemEx("LFBulletPuff");
		Stop;
	Crash:
		TNT1 A 0 A_AlertMonsters(128);
		TNT1 A 0 A_SpawnItemEx("LFBulletSpark");
		Stop;
	XDeath:
		TNT1 A 0;
		Stop;
	}
	Override int SpecialMissileHit(Actor victim)
	{
		If(ShotList.Find(victim) == ShotList.Size())
		{
			If(victim==Self.target){Return 1;}
			Else
			{
				victim.DamageMobj(Self,target,Self.BulletDmg*Random(1,4),"Bullet"); ShotList.Push(victim);
				If(victim.bSHOOTABLE&&!victim.bNOBLOOD){victim.SpawnBlood(self.pos,self.angle,self.BulletDmg);}
				If(Self.Penetration>victim.Mass){Self.Penetration-=(victim.Mass); Return 1;}
				Else{Return 0;}
			}
		}
		Else{Return 1;}
	}
}
Class LFBulletDebug : Actor
{
	Default{+NOGRAVITY}
	States
	{
	Spawn:
		PUFY A 0 NoDelay Bright {If(GetCVar("lf_debug")){A_SetTics(35);}}
		Stop;
	}
}

Class LF542 : LFBulletBase
{
	Default
	{
		Speed 640;
		LFBulletBase.Penetration 300;
		LFBulletBase.BulletDmg 10;
		Obituary "%o was shot down by %k's assault rifle.";
	}
}
Class LFAcolyte : Acolyte replaces Acolyte
{
	int gunmag;
	int sighttimer;
	int searchtimer;
	bool searched;
	bool lootmed;
	bool lootarm;
	int lootarm2;
	bool lootgun;
	int lootgun2;
	int lootmoney;
	bool lootrep;
	string looteqip; Property Equipment : looteqip;
	int looteqip2;
	bool grenout;
	bool grenon;
	bool wounded;
	int woundtimer;
	int healtimer;
	bool nowound;
	Actor prevtarg;
	bool shielded; Property Shielded : shielded;
	bool healed;
	int noescape;
	Default
	{
		PainChance "Bleeding", 0;
		Species "LFAcolyte";
	}
	Override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		gunmag=30;
		If(shielded==1){A_SpawnItemEx("LFAcolyteShield",flags: SXF_SETMASTER);}
		If(Random(1,3)==1){lootmed=1;} If(Random(1,8)==1){lootarm=1; lootarm2=Random(15,85);}
		If(Random(1,6)==1){lootgun=1; lootgun2=Random(50,600);} If(Random(1,10)==1){lootrep=1;}
		lootmoney=Random(3,15);
	}
	Override void Tick()
	{
		Super.Tick();
		If(health>0)
		{
			If(healed==0)
			{
				For(let i = BlockThingsIterator.Create(self,1024); i.Next();)
				{
					Actor other = i.thing;
					If(other==self)
					{Continue;}
					double distance = Distance3D(other);
					If(distance>1024)
					{Continue;}
					If(target!=null&&CheckSight(target))
					{Continue;}
					If(other is "LFAcolyte"&&other.InStateSequence(other.CurState,other.ResolveState("Wound")))
					{
						prevtarg=target;
						target=other;
					}
				}
			}
			If(wounded==1)
			{
				If(woundtimer>=35)
				{
					DamageMobj(null,null,1,"Bleeding");
					SpawnBlood((pos.x+random(-8,8),pos.y+random(-8,8),pos.z+16),angle,1);
					woundtimer=0;
				}
				Else{woundtimer++;}
			}
			If(healtimer>0)
			{
				If(woundtimer>=18){GiveBody(1); healtimer--; woundtimer=0;}
				Else{woundtimer++;}
			}
		}
		If(shielded==0&&sprite==GetSpriteIndex("AGRD")){sprite=GetSpriteIndex("ATRP");}
	}
	Override bool Used(Actor user) {
		let pawn = binderPlayer(user);
		If( searched==0 && health<1 && InStateSequence(CurState,ResolveState("Death")) && user is "binderPlayer" && pawn.currentarmor!=4 ) {
			int tosearch = 6 - (2 * pawn.SpeedUpgrade);
			If( searchtimer >= tosearch ) {
				If( lootmed == 1 ){ 
					Actor med = A_DropItem("wosHyposprej"); 
				}
				If( lootarm == 1 ){ 
					Actor arm = A_DropItem("wosLeatherArmor"); 
				}
				If( looteqip == "TARG" ){ 
					Actor trg = A_DropItem("wosTargeter"); 
				}
				While( lootmoney > 0 ) {
					If( lootmoney >= 25 ){ 
						A_DropItem("Gold25"); 
						lootmoney-=25; 
					} Else If( lootmoney >= 10 ){ 
						A_DropItem("Gold10"); 
						lootmoney-=10; 
					} Else If(lootmoney>=1){
						A_DropItem("coin"); 
						lootmoney--;
					}
				}
				If( lootgun == 1 ){ Actor gun = A_DropItem("wosAssaultGun"); }
				Else If( gunmag > 1 ){ Actor mag = A_DropItem("ClipOfBullets",gunmag/2); }
				If( lootrep == 1 ){ Actor rep = A_DropItem("wosArmorShard"); }
				searched = 1;
			} Else {
				A_ChangeVelocity(frandom(-0.5,0.5),frandom(-0.5,0.5));
				A_StartSound("sound/wearClothing");
				searchtimer++;
			}
		}
		Return Super.Used(user);
	}

	// usage: W_rewardXPacolyte(SpawnHealth());   //	
	action void W_rewardXPacolyte (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}

	States
	{
	Spawn:
		AGRD A 0 {reactiontime=8;}
		AGRD A 5 A_Look2();
		Loop;
		AGRD B 8 A_ClearShadow();
		Loop;
		AGRD D 8;
		Loop;
		AGRD ABCDABCD 6 A_Wander();
		Loop;
	ShieldDown:
		AGRD A 18;
		AGRD A 0 B_CheckMeleeRange(1);
		Goto See;
	See:
		//AGRD A 0 {If(target!=null&&target.health<1){SetStateLabel("See2");}}
		//AGRD A 0 A_CheckRange(1024,"See2");
		//AGRD A 0 A_CheckSight("See2");
		//AGRD A 0 A_Chase(null,null,CHF_DONTMOVE|CHF_DONTTURN);
		AGRD A 0
		{
			If(target is "LFAcolyte")
			{sighttimer=0; SetStateLabel("See2");}
			Else If(shielded==0&&health<=30&&healed==0&&noescape<3)
			{bFRIGHTENED=1; speed=14; sighttimer=0; SetStateLabel("RunAway");}
			Else{bFRIGHTENED=0; speed=7;}
		}
		AGRD A 0 A_JumpIfTargetInLOS(1,90,JLOSF_DEADNOJUMP,1024);
		Goto See2;
		AGRD A 0 {A_FaceTarget(); B_CheckAlly();}
		AGRD E 4 Slow Fast {sighttimer=140; A_FaceTarget(); If(reactiontime<=0){SetStateLabel("Missile");}Else{reactiontime--;}}
		AGRD A 0 B_CheckMeleeRange();
		Loop;
	See2:
		AGRD A 0 {If(sighttimer>0){SetStateLabel("See3");}}
		AGRD A 4 Fast Slow {A_Chase("Melee",null); A_AcolyteBits(); reactiontime=8;}
		AGRD BCD 4 Fast Slow {A_Chase("Melee",null); reactiontime=8;}
		Goto See;
	RunAway:
		AGRD A 0 A_CheckSight("HealUp");
		AGRD A 4 Fast Slow {A_Chase("Melee",null); A_AcolyteBits(); reactiontime=8;}
		AGRD BCD 4 Fast Slow {A_Chase("Melee",null); reactiontime=8;}
		Goto See;
	HealUp:
		AGRD OOOO 8 A_StartSound("misc/swish",CHAN_WEAPON);
		AGRD O 18;
		AGRD OO 8 A_StartSound("misc/meathit",CHAN_VOICE);
		AGRD O 18 B_AcolyteHeal(1);
		Goto See;
	See3:
		AGRD E 1 {sighttimer--; reactiontime=8;}
		Goto See;
	SeePain:
		AGRD A 0 {A_FaceTarget(); reactiontime=8;}
		Goto See;
	Missile:
		AGRD E 0 {If(reactiontime>0){SetStateLabel("See");}}
		AGRD E 0 A_FaceTarget();
		AGRD E 0 {If(invoker.gunmag<1){SetStateLabel("Dry");}}
		AGRD A 0 A_CheckRange(512,"Missile2");
		AGRD A 0 A_JumpIf(looteqip=="GASG"&&grenout==0&&Random(1,4)==1,"MissileGren");
		AGRD FEF 3 B_ShootGun();
		AGRD A 0 {If(looteqip=="TARG"){SetStateLabel("See");}}
		AGRD A 0 A_SentinelRefire();
		Goto Missile+1;
	Missile2:
		AGRD F 3 B_ShootGun(1);
		AGRD E 3;
		Goto See;
	MissileGren:
		AGRD O 16 {A_StartSound("weapons/grenfuse",CHAN_WEAPON); grenon=1;}
		AGRD E 4 B_ThrowGas();
		Goto See;
	Melee:
		AGRD O 0 A_FaceTarget();
		AGRD O 0 A_JumpIf(target is "LFAcolyte","HealAlly");
		AGRD O 0 A_JumpIf(shielded==0,2);
		AGRD O 4 B_AcolytePunch();
		Goto See;
		AGRD PQ 7 A_StopSound(CHAN_WEAPON);
		AGRD R 14 B_AcolytePunch();
		Goto See;
	HealAlly:
		AGRD EEEE 8 A_StartSound("misc/swish",CHAN_WEAPON);
		AGRD E 18 {If(Invoker.target.health<1){Invoker.target=Invoker.prevtarg; SetStateLabel("See");}}
		AGRD EE 8 A_StartSound("misc/meathit",CHAN_VOICE);
		AGRD E 18 B_AcolyteHeal();
		Goto See;
	Dry:
		AGRD E 1;
		AGRD E 8 A_StartSound("weapons/reload",CHAN_WEAPON);
		AGRD O 18;
		AGRD O 8
		{
			A_StartSound("weapons/reload",CHAN_WEAPON);
			//A_SpawnItemEx("LFEmptyClip",0,0,0,0,8.25);
			gunmag=30;
			reactiontime=8;
		}
		AGRD O 12 A_StartSound("weapons/chamber",CHAN_WEAPON);
		Goto See;
	Pain:
		AGRD O 0
		{
			If(Invoker.grenon==1)
			{
				Actor grenade = A_SpawnProjectile("LFGasGrenade");
				grenade.A_ChangeVelocity(0,0,0,CVF_REPLACE);
				Invoker.grenout=1; Invoker.grenon=0;
			}
			If(shielded==0&&health<=30&&healed==0){noescape++;}
		}
		AGRD O 8 Fast Slow {A_Pain(); A_AlertMonsters(96); reactiontime=8;}
		Goto SeePain;
	Wound:
		AGRD G 0 A_JumpIf(Invoker.nowound==1,"Pain");
		AGRD G 4 A_JumpIf(Invoker.wounded==1,7);
		AGRD H 4 {A_Scream(); A_AlertMonsters(256);}
		AGRD I 4;
		AGRD J 3;
		AGRD K 3 {height=16; A_StopSound(CHAN_VOICE);}
		AGRD L 3;
		AGRD M 3 {wounded=1; bINCOMBAT=1;}
		AGRD N 1 A_ChangeVelocity(frandom(-0.05,0.05),frandom(-0.05,0.05));
		Wait;
	WoundEnd:
		AGRD N 1 A_JumpIf(Invoker.health>=10,"Raise");
		Wait;
	Raise:
		AGRD A 0 {height=64; shielded=0;}
		AGRD MLKJ 3;
		AGRD IHG 4;
		Goto See;
	Death:
		AGRD G 4 {If(Invoker.wounded==1){A_NoBlocking(); A_StartSound(DeathSound,CHAN_VOICE,0,0.75); A_AlertMonsters(64); SetStateLabel("DeathEnd");}}
		AGRD H 4 {A_Scream(); A_AlertMonsters(256);}
		AGRD I 4;
		AGRD J 3;
		AGRD K 3 A_NoBlocking();
		AGRD L 3;
		AGRD M 3 A_AcolyteDie();
	DeathEnd:
		//TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
		AGRD N -1;
		Stop;
	Death.Stab:
		AGRD G 4;
		AGRD H 4
		{
			A_StartSound(DeathSound,CHAN_VOICE,0,0.75);
			A_AlertMonsters(64);
		}
		Goto Death+2;
	XDeath:
		GIBS A 5 A_NoBlocking();
		GIBS BC 5 A_TossGib();
		GIBS D 4 A_TossGib();
		GIBS E 4 A_XScream();
		GIBS F 4 A_TossGib();
		GIBS GH 4;
		GIBS I 5;
		GIBS J 5 A_AcolyteDie();
		//TNT1 A 0 W_rewardXPacolyte(SpawnHealth());
		GIBS K 5;
		GIBS L 1400;
		GIBS L 1 A_FadeOut(0.02);
		Wait;
	Dummy:
		AGRD A 0; ATRP A 0;
	}
	Action void B_ShootGun(bool sniper = 0)
	{
		If(!(Invoker.target is "LFAcolyte"))
		{
			If(Invoker.gunmag<1){SetStateLabel("Dry");}
			Else
			{
				double acc = 5.6;
				If(sniper==1){acc=1.4;}
				If(Invoker.looteqip=="TARG"){acc*=0.5;}
				A_FaceTarget();
				A_SpawnProjectile("LF542a",32,0,frandom(-acc,acc),0,frandom(-acc,acc));
				A_StartSound("weapons/assaultgun",CHAN_WEAPON);
				A_AlertMonsters(1024);
				Invoker.reactiontime=8;
				Invoker.gunmag--;
			}
		}
	}
	Action void B_ThrowGas()
	{
		If(!(Invoker.target is "LFAcolyte"))
		{
			A_FaceTarget();
			A_SpawnProjectile("LFGasGrenade");
			A_StartSound("misc/swish",CHAN_WEAPON);
			Invoker.grenout=1; Invoker.grenon=0;
		}
	}
	Action void B_CheckAlly()
	{
		FLineTraceData h;
		LineTrace(angle,1024,pitch,0,32,26,data: h);
		If(h.HitActor!=null&&h.HitActor is "LFAcolyte")
		{SetStateLabel("See2");}
	}
	Action void B_CheckMeleeRange(bool counter = 0)
	{
		FLineTraceData h;
		LineTrace(angle,meleerange,pitch,TRF_THRUSPECIES,32,data: h);
		int react = 4;
		If(Invoker.shielded==0){react=0;}
		If(h.HitActor!=null&&h.HitActor==target&&((counter==0&&Invoker.reactiontime<=0)||counter==1))
		{SetStateLabel("Melee");}
	}
	Action void B_AcolytePunch()
	{
		If(!(Invoker.target is "LFAcolyte"))
		{
			FLineTraceData h;
			LineTrace(angle,meleerange,pitch,TRF_THRUSPECIES,32,data: h);
			int dam = 3; int rec = 10; int apc = 20;
			If(Invoker.shielded==0){dam=1; rec=5; apc=10;}
			A_CustomMeleeAttack(random[AcolyteMelee](1,5)*dam);
			let hitm = h.HitActor;
			If(hitm!=null&&!(hitm is "LFAcolyteShield"))
			{
				string soundtoplay;
				If(hitm.bNOBLOOD==1){soundtoplay="misc/metalhit";}
				Else{soundtoplay="misc/meathit";}
				A_StartSound(soundtoplay,CHAN_WEAPON);
				rec-=hitm.mass/50; apc-=hitm.mass/25;
				If(rec<0){rec=0;} If(apc<0){apc=0;}
				hitm.A_Recoil(rec);
				hitm.Angle+=frandom(-apc,apc); hitm.pitch+=frandom(-apc,apc);
				If(pitch<=-90){pitch=-90;} If(pitch>=90){pitch=90;}
			}
			Invoker.reactiontime=8;
		}
	}
	Action void B_AcolyteHeal(bool slf = 0)
	{
		If(slf==0)
		{
			If(Invoker.target is "LFAcolyte")
			{
				If(Invoker.target.health>0)
				{
					let ally = LFAcolyte(target);
					ally.wounded=0;
					ally.healtimer=10;
					ally.bINCOMBAT=0;
					ally.nowound=1;
					ally.SetStateLabel("WoundEnd");
				}
				Invoker.target=Invoker.prevtarg;
				Invoker.healed=1;
			}
		}
		Else
		{
			Invoker.healtimer=10;
			Invoker.healed=1;
			Invoker.bFRIGHTENED=0;
			Invoker.speed=7;
		}
	}
}
Class LF542a : LF542
{
	Default{-MTHRUSPECIES;}
	Override int SpecialMissileHit(Actor victim)
	{
		If(victim is "LFAcolyteShield"){Return 1;}
		Else{Return Super.SpecialMissileHit(victim);}
	}
}
Class LFAcolyteShield : Actor
{
	Default
	{
		+SHOOTABLE; +NOBLOOD;
		+DONTTHRUST; +NODAMAGE;
		Radius 22;
		Height 20;
		Mass 200;
	}
	Override void Tick()
	{
		Super.Tick();
		let acol = LFAcolyte(master);
		If(master==null||master.health<1||acol.shielded==0){Destroy();}
		Else
		{
			let mf = master.frame;
			If(mf==4||mf==5||mf==14){A_Warp(AAPTR_MASTER,4,0,30,0);}
			Else{A_Warp(AAPTR_MASTER,0,0,0,0);}
		}
	}
	Override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		If(master!=null&&mod=="Melee2"){master.SetStateLabel("ShieldDown"); master.reactiontime=4;}
		Return Super.DamageMobj(inflictor,source,damage,mod,flags,angle);
	}
	States
	{
	Spawn:
		TNT1 A 1;
		Loop;
	}
}
Class LFGasGrenade : LFGrenadeBase
{
	Default
	{
		LFGrenadeBase.FuseTime 70;
		Speed 20;
		Obituary "%o choked on one of %k's gas grenades.";
		+ROLLSPRITE; +ROLLCENTER;
		+FORCEXYBILLBOARD;
	}
	States
	{
	Spawn:
		GASG BBBBCCCC 1 {B_NadeCountdown(); A_SetRoll(roll-2);}
		Loop;
	Death:
		GASG BBBBCCCC 1 B_NadeCountdown();
		Loop;
	Explode:
		GASG B 1 Bright
		{
			For(int i; i<2; i++)
			{
				bool spawn1; Actor spawn2;
				[spawn1, spawn2] = A_SpawnItemEx("LFGasObstacle",Random(-32,32),Random(-32,32));
				spawn2.Reactiontime=Random(60,100);
			}
			A_StartSound("weapons/phgrenadeshoot");
		}
		GASG B 175;
		GASG B 1 A_FadeOut(0.02);
		Wait;
	}
}
Class LFGasObstacle : Actor
{
	Default
	{
		Reactiontime 80;
		+NOBLOCKMAP
		+FLOORCLIP
		+NOTELEPORT
		+NODAMAGETHRUST
		+DONTSPLASH
		RenderStyle "Translucent";
		Alpha 0.85;
		Obituary "%o didn't wear protection.";
		DamageType "Gas";
	}
	States
	{
	Spawn:
		GASC A 2 A_Countdown();
		GASC B 2 A_Explode(4,64);
		GASC C 2 A_Countdown();
		GASC D 2 A_Explode(4,64);
		GASC E 4 A_Countdown();
		GASC F 4 A_Explode(4,64);
		GASC G 4 A_Countdown();
		GASC H 4 A_Explode(4,64);
		Goto Spawn+4;
	Death:
		GASC E 4 A_FadeOut(0.05);
		GASC F 4 {A_Explode(4,64); A_FadeOut(0.05);}
		GASC G 4 A_FadeOut(0.05);
		GASC H 4 {A_Explode(4,64); A_FadeOut(0.05);}
		Loop;
	}
}

Class LFAcolyteTan : LFAcolyte replaces AcolyteTan
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
	}
}
Class LFAcolyteRed : LFAcolyte replaces AcolyteRed
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
		Health 100;
		Translation 0;
		wosAcolyte.Shielded 1;
	}
	
}
Class LFAcolyteRust : LFAcolyte replaces AcolyteRust
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
		Health 80;
		Translation 1;
		wosAcolyte.Shielded 1;
	}
	
}
Class LFAcolyteGray : LFAcolyte replaces AcolyteGray
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
		Translation 2;
	}
}
Class LFAcolyteDGreen : LFAcolyte replaces AcolyteDGreen
{
	Default
	{
		+MISSILEMORE
		Translation 3;
	}
}
Class LFAcolyteGold : LFAcolyte replaces AcolyteGold
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
		Health 120;
		Translation 4;
		wosAcolyte.Shielded 1;
		wosAcolyte.Equipment "GASG";
		DamageFactor "Gas", 0;
		PainChance "Gas", 0;
	}
	Override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lootmoney=Random(5,25);
		nowound=1;
	}
}
Class LFAcolyteLGreen : LFAcolyte replaces AcolyteLGreen
{
	Default
	{
		Health 60;
		Translation 5;
	}
}
Class LFAcolyteBlue : LFAcolyte replaces AcolyteBlue
{
	Default
	{
		Health 60;
		Translation "32:63=0:31", "80:95=64:79", "128:143=144:159", "192:192=1:1", "193:223=1:31", "235:239=224:228";
		wosAcolyte.Equipment "TARG";
	}
	Override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		looteqip2=Random(50,90);
	}
}
Class LFAcolyteShadow : LFAcolyte replaces AcolyteShadow
{
	Default
	{
		+MISSILEMORE +MISSILEEVENMORE
		Health 90;
		wosAcolyte.Shielded 1;
	}
}
Class LFAcolyteToBe : LFAcolyte replaces AcolyteToBe
{
	Default
	{
		Health 61;
		Radius 20;
		Height 56;
		DeathSound "becoming/death";
		-COUNTKILL
		-ISMONSTER
	}
	States
	{
	Spawn:
		ARMR A -1;
		Stop;
	Pain:
		ARMR A -1 A_HideDecepticon;
		Stop;
	Death:
		Goto XDeath;
	}
	void A_HideDecepticon ()
	{
		Door_Close(999, 64);
		if (target != null && target.player != null)
		{
			SoundAlert (target);
		}
	}
}
Class LFDeadAcolyte : LFAcolyte replaces DeadAcolyte
{
	Default{-COUNTKILL;}
	Override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		gunmag=Random(5,25);
	}
	States
	{
	Spawn:
		AGRD N 0 NoDelay A_Die();
	Death:
		AGRD N 0 A_NoBlocking();
		AGRD N -1;
		Stop;
	}
}
Class LFUniqueAcolyte : LFDeadAcolyte
{
	Override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		gunmag=30;
		lootmoney=25;
		lootmed=0; lootarm=0; lootarm2=0;
	}
	Default {Translation 5;}
	States
	{
	Spawn:
		AGRD N 0 NoDelay A_Die();
	Death:
		AGRD N 0 {A_NoBlocking();}
		AGRD N -1;
		Stop;
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ascension flesh imp ////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class ascImpFlesh : wosMonsterBase {
	Default {
		//$category "Monsters/WoS"
		//$Title "Imp Green"
		Tag "$TAG_ascImpFlesh";
		Obituary "$OBI_ascImpFlesh"; //%o was bitten by a Flesh Imp.
		Health 55;
		Speed 10;
		FastSpeed 20;
		DamageFunction (random(4,8));
		PainChance 144;
  		SeeSound "H2Imp/Sight";
		DeathSound "H2Imp/Death";
		PainSound "H2Imp/Pain";
		meleeSound "H2Imp/Melee";
		Monster;
		radius 16;
		height 32;
		+FloorClip
		+DONTHARMSPECIES
		+Float
		+NoGravity
		+NoTrigger
		+NOTARGETSWITCH
		+PUSHABLE
	}  
  	States {
		Spawn:
			IMP1 J 8 A_Look();
			Loop;
		See:
			IMP1 BBBCCC 2 A_Chase();
			IMP1 C 0 A_StartSound("H2Imp/Wings");
			IMP1 BBBAAA 2 A_Chase();
			Loop;
		Melee:
			IMP1 D 0;
			IMP1 DE 4 A_FaceTarget();
			IMP1 F 4 A_CustomMeleeAttack(random(1,8)*2,"H2Imp/Melee","");
			Goto See;
		FakeMelee:
			IMP1 DE 4 A_FaceTarget();
			IMP1 F 4;
			Goto See;
		Missile:
			IMP1 A 0;
			IMP1 A 0 A_JumpIfCloser(384, 1);
			Goto See;
			IMP1 A 8 A_FaceTarget();
			IMP1 C 0 A_StartSound("H2Imp/Charge");
			IMP1 C 15 A_SkullAttack();
			IMP1 C 0 A_Stop();
			Goto See;
		Pain:
			IMP1 G 2;
			IMP1 G 3 A_Pain();
			Goto See;
		Death:
			IMP1 H 0 { bFLOATBOB = 0; }
			IMP1 H 1 A_Scream();
            TNT1 A 0 W_rewardXP(SpawnHealth());
			IMP1 H 1;
		Crash:
			IMP1 H 0 { bFLOATBOB = 0; }
			IMP1 I 5;
			IMP3 J 5;
			IMP3 K 5 A_NoBlocking();
			IMP3 L -1;
			Stop;
		Idle:
			IMP1 BBBCCC 2 A_Look();
			IMP1 B 0 A_StartSound("H2Imp/Wings");
			IMP1 BBBAAA 2 A_Look();
			Loop;
   	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// heretic loremaster /////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class wosLoremasterHeretic_base : Loremaster {
	Default {
		//$category "Monsters/WoS"
		Tag "Heretic Loremaster";
	}
	States {
		Death:
		PDED A 6;
		PDED B 6 A_Scream();
		PDED C 4;
		PDED D 3 A_Fall();
		PDED E 3;
		PDED FGHIJIJIJKL 3;
		PDED MNOP 3;
		PDED Q 4;
		PDED RS 4;
		PDED T -1;
		Stop;
	}
}
class wosLoremasterHereticLesser : wosLoremasterHeretic_base {
	Default {
		//$Title "heretic loremaster lesser"
		Health 300;
	}
}
class wosLoremasterHereticMaster : wosLoremasterHeretic_base {
	Default {
		//$Title "heretic loremaster master"
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// bog/swamp monster //////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class wosBogMonster : Serpent {
	Default {
		//$Category "Monsters/WoS"
		//$Title "bog monster"
		Tag "Bog Monster";
		Health 80;
		SeeSound "SerpentSight"; //bogmonster/sight
		AttackSound "SerpentAttack"; //bogmonster/attack
		PainSound "SerpentPain"; //bogmonster/pain
		DeathSound "SerpentDeath"; //bogmonster/death
	}
	action void W_rewardXPbogMonster (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}
	States {
		Death:
			SSPT O 4;
			SSPT P 4 A_Scream();
			SSPT Q 4 A_NoBlocking();
            TNT1 A 0 W_rewardXPbogMonster(SpawnHealth());
			SSPT RSTUVWXYZ 4;
			Stop;
		XDeath:
			SSXD A 4;
			SSXD B 4 A_SpawnItemEx("SerpentHead", 0, 0, 45);
			SSXD C 4 A_NoBlocking();
            TNT1 A 0 W_rewardXPbogMonster(SpawnHealth());
			SSXD DE 4;
			SSXD FG 3;
			SSXD H 3 A_SerpentSpawnGibs();
			Stop;
		
	}
}*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////