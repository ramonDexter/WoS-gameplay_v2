////////////////////////////////////////////////////////////////////////////////
// monsters base definition file ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// monster base class //////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class wosMonsterBase : actor {
	/////////////////////////////////////////
	// usage: W_rewardXP(SpawnHealth());   //
	/*
			TNT1 A 0 W_rewardXP(SpawnHealth()); //
	*/
	/////////////////////////////////////////
	action void W_rewardXP (int rewardXP) {
		let pawn = binderPlayer(target);
		if ( pawn && pawn.player ) {
			pawn.playerXP+=rewardXP;
			//A_Log("Added ", rewardXP, " XP!");
			A_Log(string.format("\c[yellow][ %s%i%s ]", "Received ", rewardXP, " XP!"));
		}
	}
	Default {
		+SHOOTABLE
		+SOLID
	}
}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// monster projectiles /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// laser particle projectile ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class sentinelLaserTracer : FastProjectile {
	const TRACERDURATION	= 1; // tics
	const TRACERLENGTH		= 256.0; // float
	const TRACERSCALE		= 8.0; // float
	const TRACERSTEP		= 0.005; // float
	//const TRACERACTOR		= "laserTracerTrail"; // actor name
	const TRACERSPEED		= 40;

	float x1, y1, z1;
	float x2, y2, z2;
	
	// intentional briticism to avoid conflicts with "color" keyword.
	// modified with strife fitting colors
	static const color colours[] = {
		
		// reversed order
		"db 2b 2b",
		"cb 23 23",
		"bf 1f 1f",
		"af 1b 1b",
		"af 1b 1b",
		"93 13 13"
		// reversed order

		/*"13 3f 0b",
		"23 57 13",
		"37 73 23",
		"4f 8f 37",
		"6b ab 4b",
		"8b c7 67"*/ /* appears twice so a segment of this color is longer
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

	void W_spawnLaserParticleTrail() {
		if (level.frozen || globalfreeze) return;
		
		x1 = pos.x;
		y1 = pos.y;
		z1 = pos.z;
		
		x2 = pos.x + vel.x / GetDefaultSpeed("BlasterTracer") * TRACERLENGTH;
		y2 = pos.y + vel.y / GetDefaultSpeed("BlasterTracer") * TRACERLENGTH;
		z2 = pos.z + vel.z / GetDefaultSpeed("BlasterTracer") * TRACERLENGTH;		
		
		for(float i = 0; i < 1; i += TRACERSTEP) {
			A_SpawnParticle (
				colours[clamp(i * colours.Size(), 0, colours.Size() - 1)],
				SPF_FULLBRIGHT,
				TRACERDURATION,
				TRACERSCALE * (1 - i),
				0,
				pos.x - lerp(x1, x2, i),
				pos.y - lerp(y1, y2, i),
				pos.z - lerp(z1, z2, i),
				0, 0, 0,
				0, 0, 0,
				1.0
			);
			/*A_SpawnItemEx (
				TRACERACTOR,
				pos.x - lerp(x1, x2, i),
				pos.y - lerp(y1, y2, i),
				pos.z - lerp(z1, z2, i),
				0, 0, 0, 0,
				SXF_ABSOLUTEPOSITION
			);	*/		
		}		
	}

	Default {
		Radius 2;
		Height 2;
		Speed TRACERSPEED;
		Damage 1;
		Decal "redShotScorch";        
		SeeSound "weapons/laserProj";
		DeathSound "weapons/lasProjDeath";
		+NOEXTREMEDEATH;
	}
	States {
		Spawn:
			LSTR A 1 Bright W_spawnLaserParticleTrail();
			Loop;
		Death:
			TNT1 A 0 A_AlertMonsters();
			TNT1 AAAAAAAAAAAAAAAAAAAAA 0 A_SpawnParticle ("red", SPF_FULLBRIGHT|SPF_RELATIVE, 15, 2.5, 0, frandom(-1,1),  frandom(-1,1), frandom(-1,1), frandom(-4,4), frandom(-4,4), frandom(-4,4), 0, 0, 0, 1.0, -0.1, 0.05);
			TNT1 AAAAAAAAAAAAAAAAAAAAA 0 A_SpawnParticle ("red", SPF_FULLBRIGHT|SPF_RELATIVE, 15, 1.75, 0, frandom(-0.5,0.5),  frandom(-0.5,0.5), frandom(-0.5,0.5), frandom(-4,4), frandom(-4,4), frandom(-4,4), 0, 0, 0, 1.0, -0.1, 0.025);
			TNT1 A 0 A_SpawnItemEx("lasPisFlashLong", 0, 0, 0, 0);			
			TNT1 A 0 A_SpawnItemEx("laserExplosion", 0, 0, 0, 0);
			TNT1 A 2 Light("BLASTERSHOT2");
			TNT1 A 2 Light("BLASTERSHOT3");
			TNT1 A 2 Light("BLASTERSHOT4");
			TNT1 A 2 Light("BLASTERSHOT5");
			Stop;
	}
}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// base monster bullet tracer projectile ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
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
		+THRUGHOST;
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
// damage type for different types of enemies //////////////////////////////////
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

// monster mauler pojectile ////////////////////////////////////////////////////
// code base by denis belmondo /////////////////////////////////////////////////
class wosMonsterMaulerTracer : FastProjectile {
    const TRACERDURATION	= 1; // tics
	const TRACERLENGTH		= 192.0; // float
	const TRACERSCALE		= 8.0; // float
	const TRACERSTEP		= 0.005; // float
	//const TRACERACTOR		= "wosMonsterMaulerTracerTrail"; // actor name
	const TRACERSPEED		= 90;

	float x1, y1, z1;
	float x2, y2, z2;
	
	// intentional briticism to avoid conflicts with "color" keyword.
	// modified with strife fitting colors
	static const color colours[] = {
		
		// reversed order
		"6b ab 4b",
		"6b ab 4b",
		"4f 8f 37",
		"37 73 23",
		"23 57 13",
		"13 3f 0b"
		// reversed order

		/*"13 3f 0b",
		"23 57 13",
		"37 73 23",
		"4f 8f 37",
		"6b ab 4b",
		"8b c7 67"*/ /* appears twice so a segment of this color is longer
					than the others. */
	};
	
	// literally just stole this from wikipedia - linear interpolation
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

	void W_SpawnParticleTrail() {
		if (level.frozen || globalfreeze) return;
		
		x1 = pos.x;
		y1 = pos.y;
		z1 = pos.z;
		
		x2 = pos.x + vel.x / GetDefaultSpeed("wosMonsterMaulerTracer") * TRACERLENGTH;
		y2 = pos.y + vel.y / GetDefaultSpeed("wosMonsterMaulerTracer") * TRACERLENGTH;
		z2 = pos.z + vel.z / GetDefaultSpeed("wosMonsterMaulerTracer") * TRACERLENGTH;		
		
		for(float i = 0; i < 1; i += TRACERSTEP) {
			A_SpawnParticle (
				colours[clamp(i * colours.Size(), 0, colours.Size() - 1)],
				SPF_FULLBRIGHT,
				TRACERDURATION,
				TRACERSCALE * (1 - i),
				0,
				pos.x - lerp(x1, x2, i),
				pos.y - lerp(y1, y2, i),
				pos.z - lerp(z1, z2, i),
				0, 0, 0,
				0, 0, 0,
				1.0
			);
			/*A_SpawnItemEx (
				TRACERACTOR,
				pos.x - lerp(x1, x2, i),
				pos.y - lerp(y1, y2, i),
				pos.z - lerp(z1, z2, i),
				0, 0, 0, 0,
				SXF_ABSOLUTEPOSITION
			);*/		
		}		
	}

    Default {		
		Height 2;
		Radius 2;
		Speed TRACERSPEED;
        //DamageFunction (16 * Random(1, 4));
		Damage 1;
        Decal "blueShotScorch";
        SeeSound "weapons/staffprojectile";
		DeathSound "weapons/shotdeath";
		//+BLOODSPLATTER;
		+NOEXTREMEDEATH;
	}
    States {
		Spawn:
			DUMM ABCDEFGHI 1 Bright W_SpawnParticleTrail();
			Loop;
		Death:
			TNT1 A 0 A_SpawnItemEx("BulletPuff");
			TNT1 A 0 A_AlertMonsters();
            TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("greenShotParticle",0,0,0,frandom(-6,6),frandom(-6,6),frandom(-6,6),0,SXF_NOCHECKPOSITION);
			TNT1 A 0 {
				A_SpawnItemEx("staffFlashLong", 0, 0, 0, 0);			
				A_SpawnItemEx("greenShotExplosion", 0, 0, 0, 0);
				A_SpawnItemEx("greenShotDeath", 0, 0, 0, 0);
			}
            TNT1 A 2 Light("BLASTERSHOT2");
            TNT1 A 2 Light("BLASTERSHOT3");
            TNT1 A 2 Light("BLASTERSHOT4");
            TNT1 A 2 Light("BLASTERSHOT5");
            Stop;
	}
}
class wosMonsterMaulerTracerTrail : actor {
	const PTCLDURATION = 1;
	
    Default {
		//Alpha 0.5;
		//RenderStyle "Add";
		//Scale 0.25;
		+NOINTERACTION;
		+NOBLOCKMAP;
        SeeSound "weapons/staffprojectile";
	}
	States {
		Spawn:			
			TNT1 AA 0 {
				A_SpawnParticle (
					"235713", //color1, hexadecimal value or a predefined value such as "Black"
					SPF_FULLBRIGHT|SPF_RELATIVE, //flags
					PTCLDURATION, //lifetime in tics
					0.55, //size, default 1.0
					0, //angle, default 0
					frandom(-1.25,1.25), frandom(-1.25,1.25), frandom(-1.25,1.25), //x/y/z offset, default 0
					0, 0, 0, //velocity x/y/z
					0, 0, 0, //acceleration x/y/z
					1.0, //staralphaf, default 1.0
					-0.1, //fadestep, default -1
					0.25 //sizestep pre tic
				);
			}			
			TNT1 AAA 0 {
				A_SpawnParticle (
					"8fc75f", 
					SPF_FULLBRIGHT|SPF_RELATIVE, 
					PTCLDURATION, 
					0.75, 
					0, 
					frandom(-0.85,0.85), frandom(-0.85,0.85), frandom(-0.85,0.85), 
					0, 0, 0, 
					0, 0, 0, 
					1.0, 
					-0.1, 
					0.05
				);
			}
			TNT1 AA 0 {
				A_SpawnParticle (
					"b7e77f", 
					SPF_FULLBRIGHT|SPF_RELATIVE, 
					PTCLDURATION, 
					0.45, 
					0, 
					frandom(-0.45,0.45), frandom(-0.45,0.45), frandom(-0.45,0.45), 
					0, 0, 0, 
					0, 0, 0, 
					1.0, 
					-0.1, 
					0.025
				);
			}
			TNT1 A -1 A_Jump(256, "Null");
			Stop;
	}
}
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////