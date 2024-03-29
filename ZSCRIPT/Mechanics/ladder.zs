const LADDER_FRICTION = 0.66;

class LadderBase : Actor
{
	Array<Actor> Climbers;
	double ladderheight;
	bool passive;
	bool nomonsters;

	Property LadderHeight:ladderheight; // Height of climbable area
	Property DisallowMonsters:nomonsters; // Can monsters climb the ladder?

	Default
	{
		+NOGRAVITY
		-SOLID
		+NODAMAGE
		+DONTTHRUST
		Height 8;
		Radius 24;
		LadderBase.LadderHeight 132; // Uses custom property vice actual actor height so that the ladder model can be submerged in the ground to make shorter ladders 
		LadderBase.DisallowMonsters False; // Sets variable determining if monsters should be disallowed from using the ladder
	}

	States
	{
		Spawn:
			UNKN A 1;
			Loop;
	}

	override void PostBeginPlay()
	{
		BlockThingsIterator it = BlockThingsIterator.Create(self, 1);

		while (it.Next())
		{
			if (it.thing == self) { continue; } // Ignore itself

			if (it.thing is "LadderBase")
			{ // If there are other ladders immediately above or below, handle setting up transfer logic so that players don't get dropped mid-ladder if there are multiple stacked ladders
				if (Distance2d(it.thing) > 0) { continue; } // Only check ladders that are directly above/below this one

				if (it.thing.pos.z > pos.z && it.thing.pos.z - LadderBase(it.thing).ladderheight <= pos.z) { passive = true; } // This ladder is not the top, so make it decorative only
				else if (it.thing.pos.z < pos.z && pos.z - ladderheight <= it.thing.pos.z) // This ladder is the top, so make its height check logic handle the entire stack
				{
					double heightcheck = pos.z - it.thing.pos.z + LadderBase(it.thing).ladderheight;
					ladderheight = heightcheck > ladderheight ? heightcheck : ladderheight;
				}
			}
		}

		Super.PostBeginPlay();
	}

	override void Tick()
	{
		Super.Tick();

		if (passive) { return; }

		BlockThingsIterator it = BlockThingsIterator.Create(self, 16);

		while (it.Next())
		{
			if ((nomonsters || !it.thing.bIsMonster) && !(it.thing is "PlayerPawn")) { continue; } // Ignore everything except players and monsters

			if (
				(Distance2D(it.thing) > Radius + it.thing.radius || !CheckSight(it.thing)) || // Check if the actor can reach the ladder (horizontal radius check)
				(it.thing.pos.z + it.thing.height < pos.z - ladderheight) || // Z-height check (player below ladder)
				(it.thing.pos.z > pos.z) // Z-height check (player above ladder)
			)
			{
				ResetActor(it.thing);
				continue;
			}

			if (!it.thing.bFly && !it.thing.bFloat) // Only affect things that aren't already flying
			{
				if (Climbers.Find(it.thing) == Climbers.Size()) { Climbers.Push(it.thing); } // Add the actor to the list of climbers if it's not already there

				if (it.thing.bIsMonster) { it.thing.bFloat = True; } // If it's a monster set +FLOAT
				else { it.thing.bFly = True; } // If it's a player, use the fly cheat/powerup
				it.thing.bNoGravity = True;
			}

			if (Climbers.Find(it.thing) < Climbers.Size()) // If the actor is in the climbers list, apply speed/velocity changes
			{
				it.thing.vel.x *= LADDER_FRICTION;
				it.thing.vel.y *= LADDER_FRICTION;
				it.thing.vel.z *= LADDER_FRICTION;
			}
		}
	}

	// Restores the default values of the various flags if the actor was on this ladder
	void ResetActor(Actor mo)
	{
		if (Climbers.Find(mo) != Climbers.Size()) //If the actor was on the list of climbers for this ladder...
		{
			mo.Speed = mo.Default.Speed; // Reset the default values...
			mo.bNoGravity = mo.Default.bNoGravity;
			mo.bFly = mo.Default.bFly;
			mo.bFloat = mo.Default.bFloat;

			Climbers.Delete(Climbers.Find(mo)); // ...and delete if from the climbers list.  
			Climbers.ShrinkToFit(); // Re-shrink the array
		}
	}
}

class TOSLadderYellow : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder yellow"
	}
}
class TOSLadderYellowExtension : TOSLadderYellow {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder yellow extension"
	}
}

class TOSladderWooden : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder wooden"
	}
}
class TOSladderWoodenAttached : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder wooden attached"
	}
}
class TOSladderWoodenMetal : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder wooden metal"
	}
}
class TOSladderWoodenMetalExtension : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder wooden metal extension"
	}
}
class TOSladderWoodenHoles : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder wooden holes"
	}
}
class TOSladderRope01 : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder rope 01"
	}
}
class TOSladderRope02 : LadderBase {
	Default {
		//$Category "ZSCRIPT"
		//$Title "ladder rope 02"
	}
}
/*
class NoMonsterLadder : LadderBase
{
	Default
	{
		LadderBase.DisallowMonsters True;
	}
}
*/