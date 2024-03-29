// Zip Lines by Kevin "Talon1024" Caccamo
// License: GPL v2
// Copyright Kevin Caccamo 2018

/**
 * An endpoint for a zip line
 *
 * The TID of the zip line endpoint defines which zip line it belongs to.
 * Zip line endpoints can require specific items to ascend or descend them.
 *
 * The AscendItem property defines which item is required to ascend the zip line.
 * The DescendItem property defines which item is required to descend the zip line.
 * The VisualEffect property defines the actor to use as the "rope" of the zip line.
 * The InteractionIcon property defines an actor to spawn at the endpoint.
 * The ZippingItem property defines what active zip line item to give to the player.
 * The AscendItemNeededMessage property defines the message to use if the player cannot ascend the zip line without a particular item.
 * The DescendItemNeededMessage property defines the message to use if the player cannot descend the zip line without a particular item.
 * The StartDistance property defines the initial distance from the endpoint when the player gets on the zip line.
 */
class ZipLineEndpoint : SwitchableDecoration
{
	ZipLineEndpoint OtherEndpoint; // Other endpoint of zip line. Must have same TID as this endpoint.
	class<OnZipLine> ZippingItem; // Item that performs the zip line physics logic.
	class<Inventory> AscendItem; // Item required to ascend zip line.
	class<Inventory> DescendItem; // Item required to descend zip line.
	class<Actor> VisualEffect; // Visual effect (To be spawned by A_SpawnActorLine)
	class<Actor> InteractionIcon; // Visual effect that indicates interactability.
	String AscendItemNeededMessage; // Message to player indicating need for ascent item.
	String DescendItemNeededMessage; // Message to player indicating need for descent item.
	double ZipStartDistance; // Initial distance from endpoint when player uses it.
	double VisualZOffset; // Z offset of visual effect.
	int8 ZipDirection; // Direction to other endpoint.
	bool ZipVisualConnectee; // Is this zip line endpoint a connector or connectee?

	// ZipDirection == 0    <-- No height difference - no items needed.
	// ZipDirection == 1    <-- Other endpoint is higher
	// ZipDirection == -1   <-- Other endpoint is lower

	Property DescendItem : DescendItem;
	Property AscendItem : AscendItem;
	Property VisualEffect : VisualEffect;
	Property VisualZOffset : VisualZOffset;
	Property InteractionIcon : InteractionIcon;
	Property ZippingItem : ZippingItem;
	Property AscendItemNeededMessage : AscendItemNeededMessage;
	Property DescendItemNeededMessage : DescendItemNeededMessage;
	Property StartDistance : ZipStartDistance;

	Default {
		//$Category "zscript/zipline"
		// $Sprite ZPLNA0
		// $Title Zip Line Endpoint
		// $Color 13
		Tag "zipline endpoint";
		Radius 16;
		Height 32;
		Activation THINGSPEC_ThingTargets | THINGSPEC_Switch; // THINGSPEC_Activate or Deactivate seems to only allow said thing to be either activated or deactivated for some stupid reason...
		ZipLineEndpoint.VisualEffect "ZipLineVisual";
		ZipLineEndpoint.VisualZOffset 32.0;
		ZipLineEndpoint.InteractionIcon "ProximityInteractionIcon";
		ZipLineEndpoint.ZippingItem "OnZipLine";
		ZipLineEndpoint.AscendItemNeededMessage "$ZIPASCENDITEMNEEDED";
		ZipLineEndpoint.DescendItemNeededMessage "$ZIPDESCENDITEMNEEDED";
		ZipLineEndpoint.StartDistance 16.0;
		+USESPECIAL;
	}

	States
	{
	Spawn:
		ZPLN A 0; // Why doesn't NoDelay work here?
	Init:
		"####" "#" 0 {
			// Spawn interaction icon if defined
			if (InteractionIcon) {
				A_SpawnItemEx(InteractionIcon, 0.0, 0.0, 16.0);
			}

			// Spawn visual effect if defined
			if (VisualEffect && !ZipVisualConnectee) {
				// Set start/end visual effect positions
				vector3 ZipVisualPosA = Pos;
				ZipVisualPosA.Z += VisualZOffset;
				vector3 ZipVisualPosB = OtherEndpoint.Pos;
				ZipVisualPosB.Z += VisualZOffset;

				// Spawn visual effect actors
				A_SpawnActorLine(VisualEffect, ZipVisualPosA, ZipVisualPosB, 40.0);
			}
		}
	Idle:
		"####" "#" -1;
		Stop;
	Active:
		"####" "#" 0 {
			if (OtherEndpoint) {
				if ((ZipDirection == -1 && CanDescend()) ||
					(ZipDirection == 1 && CanAscend()) ||
					 ZipDirection == 0) {

					// Initialize zip line active item
					OnZipLine zipThing = OnZipLine(GiveInventoryType(ZippingItem));
					
					// Set start/finish endpoints
					zipThing.StartEndpoint = self;
					zipThing.FinishEndpoint = OtherEndpoint;
					
					// Set pitch, angle, and direction
					zipThing.ZipLinePitch = PitchTo(OtherEndpoint);
					zipThing.ZipLineAngle = AngleTo(OtherEndpoint, true);
					zipThing.ZipLineDirection = ZipDirection;
					
					// Can player ascend and/or descend?
					zipThing.PCanAscend = CanAscend();
					zipThing.PCanDescend = CanDescend();
					target.AddInventory(zipThing);

					// Put player in front of endpoint to begin with
					target.SetXYZ(Vec3Angle(ZipStartDistance, target.Angle, 0.0, false));
					// Make player face other endpoint
					target.Angle = AngleTo(OtherEndpoint, true);
					target.Pitch = PitchTo(OtherEndpoint);
				}
			}
		}
		Goto Idle;
	Inactive:
		Goto Active; // This works... Somehow.
	}

	// Thanks, ZWiki! This one is slightly modified so that the angle and pitch between the two points is taken into account.
	// https://zdoom.org/wiki/A_SpawnActorLine
	action void A_SpawnActorLine(class<Actor> classname, Vector3 pointA, Vector3 pointB, double units = 1)
	{
		// get a vector pointing from A to B
		let pointAB = pointB - pointA;

		// get distance
		let dist = pointAB.Length();

		// normalize it
		pointAB /= dist == 0 ? 1 : dist;

		// get angle and pitch of line
		double lineAngle = atan2(pointB.y - pointA.y, pointB.x - pointA.x);
		double linePitch = atan2(pointA.z - pointB.z, dist);

		// iterate in units of 'units'
		for (double i = 0; i < dist; i += units)
		{
			// we can now use 'pointA + i * pointAB' to
			// get a position that is 'i' units away from
			// pointA, heading in the direction towards pointB
			let position = pointA + i * pointAB;
			Actor spawned = Spawn(classname, position, ALLOW_REPLACE);
			// Set spawned actor's angle and pitch. Useful for flatsprite and 3D model actors.
			spawned.angle = lineAngle;
			spawned.pitch = linePitch;
		}
	}

	ZipLineEndpoint FindOtherEndpoint() {
		// Find other zip line endpoint using ActorIterator
		//ActorIterator iter = ActorIterator.Create(TID, "ZipLineEndpoint");
		ActorIterator iter = Level.CreateActorIterator(TID, "ZipLineEndpoint");
		
		Actor other;
		while (other = iter.Next()) {
			if (other == self) continue;
			// Set other endpoint as visual effet connectee
			ZipLineEndpoint otherEndpoint = ZipLineEndpoint(other);
			otherEndpoint.ZipVisualConnectee = true;
			return otherEndpoint;
		}
		// No other endpoint found!
		Console.Printf("\cRWarning\cC: No other endpoint found for ZipLineEndpoint (TID %d)", TID);
		return null;
	}

	override void PostBeginPlay() {
		// Find other endpoint
		OtherEndpoint = FindOtherEndpoint();

		// Set zip line direction
		ZipDirection = 0;
		if (OtherEndpoint.Pos.z < Pos.z) {
			// Other endpoint is lower.
			ZipDirection = -1;
		} else if (OtherEndpoint.Pos.z > Pos.z) {
			// Other endpoint is higher.
			ZipDirection = 1;
		}
	}

	virtual bool CanDescend() {
		// Always allowed to ascend if straight.
		if (ZipDirection == 0) return true;

		// If zip line requires descent item
		if (DescendItem != null) {
			if (target.FindInventory(DescendItem)) {
				return true;
			// Cannot descend if you don't have the item
			} else {
				A_Print(DescendItemNeededMessage);
				return false;
			}
		}
		// Allow descent if no item required.
		return true;
	}

	// Logic is mostly copy-pasted from CanDescend, with forwards/backwards reversed.
	virtual bool CanAscend() {
		if (ZipDirection == 0) return true;
		if (AscendItem != null) {
			if (target.FindInventory(AscendItem)) {
				return true;
			} else {
				A_Print(AscendItemNeededMessage);
				return false;
			}
		}
		return true;
	}

	// Since there is no PitchTo method of Actor, I had to write one myself.
	double PitchTo(Actor other) {
		double dist = Distance2D(other);
		double vdist = self.Pos.Z - other.Pos.Z;
		return atan2(vdist, dist);
	}
}

/**
 * An effect item that is given to the player while on the zip line, and taken
 * away once the player leaves the zip line.
 * 
 * MinDistance defines the minimum distance to the other zip line endpoint in
 * order for the player to get off. Don't set this too small or else the player
 * won't leave the zip line automatically! 20 is miniscule, so this is 30 by
 * default.
 *
 * ZipLineSpeed defines the default speed for travelling on the zip line.
 * ZipLineAccel defines the rate at which the player changes speed on the zip line
 * MaxSpeed defines the maximum speed for travelling on the zip line.
 */
class OnZipLine : Inventory {
	ZipLineEndpoint StartEndpoint; // Endpoint the player started from
	ZipLineEndpoint FinishEndpoint; // Endpoint the player will finish at
	double MinFinishDistance; // Minimum distance to finish endpoint
	double ZipLineAngle; // Angle of start endpoint to finish endpoint
	double ZipLinePitch; // Pitch of zip line
	double ZipLineSpeed; // Speed of zip line
	double ZipLineMaxSpeed; // Max speed players can traverse zip lines
	double ZipLineAccel; // Rate at which player can change speed on zip line
	bool LeftStart; // Is the player far enough from the starting point?
	bool PCanAscend; // Can the player ascend the zip line?
	bool PCanDescend; // Is the player allowed to descend the zip line?
	int8 ZipLineDirection; // 0 = no height diff, 1 = up, -1 = down

	Property MinDistance: MinFinishDistance;
	Property ZipLineSpeed: ZipLineSpeed;
	Property ZipLineAccel: ZipLineAccel;
	Property MaxSpeed: ZipLineMaxSpeed;

	Default {
		Inventory.MaxAmount 1;
		OnZipLine.MinDistance 30.0;
		OnZipLine.ZipLineSpeed 5.0;
		OnZipLine.ZipLineAccel 0.3;
		OnZipLine.MaxSpeed 9.0;
		+INVENTORY.UNDROPPABLE;
	}

	override void BeginPlay() {
		LeftStart = false;
	}

	/*
	Notes about forwardmove and sidemove:
	forwardmove - positive = forward, negative = backward, bounds = -12800, 12800
	sidemove - positive = right, negative = left, bounds = -12800, 12800
	upmove - positive = up, negative = down, bounds = -768, 768
	*/
	// Get zip line acceleration
	virtual double GetAccel(int forwardmove, int sidemove) {
		// AngleFactors - how much the rider's angle affects acceleration.
		double FwdAngleFactor = cos(Owner.Angle - ZipLineAngle);
		double SideAngleFactor = sin(Owner.Angle - ZipLineAngle);

		// InputFactors - how much the input affects acceleration.
		double FwdInputFactor = forwardmove / 12800.0;
		double SideInputFactor = sidemove / 12800.0;
		
		return ZipLineAccel * (FwdAngleFactor * FwdInputFactor + SideAngleFactor * SideInputFactor);
	}

	override void DoEffect() {
		// Check if player has left start
		if (!LeftStart && Owner.Distance3D(StartEndpoint) > MinFinishDistance) {
			LeftStart = true;
		}

		// Zip line control logic
		// Only allow player control after leaving start point
		if (Owner.Player && LeftStart) {

			// Drop from zip line when player crouches
			if (Owner.Player.cmd.buttons & BT_CROUCH != 0) {
				Destroy();
				return;
			}

			// Accelerate or decelerate
			ZipLineSpeed += GetAccel(Owner.Player.cmd.forwardmove, Owner.Player.cmd.sidemove);
			// Ensure speed is within bounds
			// Going straight
			if (ZipLineDirection == 0) {
				// Clamp speed within min/max boundary
				if (ZipLineSpeed > ZipLineMaxSpeed) {
					ZipLineSpeed = ZipLineMaxSpeed;
				}
				else if (ZipLineSpeed < -ZipLineMaxSpeed) {
					ZipLineSpeed = -ZipLineMaxSpeed;
				}
			// Going up
			} else if (ZipLineDirection == 1) {
				// Going forwards = ascending
				if (ZipLineSpeed > 0) {
					if (PCanAscend) {
						// Don't go above max speed
						if (ZipLineSpeed > ZipLineMaxSpeed) {
							ZipLineSpeed = ZipLineMaxSpeed;
						}
					// Don't move if cannot ascend
					} else {
						ZipLineSpeed = 0;
					}
				}
				// Negative speed = going backwards = descending
				if (ZipLineSpeed < 0) {
					if (PCanDescend) {
						// Don't go below min speed
						if (ZipLineSpeed < -ZipLineMaxSpeed) {
							ZipLineSpeed = -ZipLineMaxSpeed;
						}
					// Don't move if cannot descend
					} else {
						ZipLineSpeed = 0;
					}
				}
			// Going down
			// Logic is mostly copy-pasted from the previous block, but with the backwards/forwards reversed. I don't know if there's a cleaner way to do this, but if there is, please let me know.
			} else if (ZipLineDirection == -1) {
				if (ZipLineSpeed > 0) {
					if (PCanDescend) {
						if (ZipLineSpeed > ZipLineMaxSpeed) {
							ZipLineSpeed = ZipLineMaxSpeed;
						}
					} else {
						ZipLineSpeed = 0;
					}
				}
				if (ZipLineSpeed < 0) {
					if (PCanAscend) {
						if (ZipLineSpeed < -ZipLineMaxSpeed) {
							ZipLineSpeed = -ZipLineMaxSpeed;
						}
					} else {
						ZipLineSpeed = 0;
					}
				}
			}
		}

		// Set owner's velocity
		Owner.Vel3DFromAngle(ZipLineSpeed, ZipLineAngle, ZipLinePitch);

		// Only allow leaving zip line after leaving start
		if (LeftStart) {
			// If player is close enough to one of the endpoints, leave the zip line.
			if (Owner.Distance3D(StartEndpoint) < MinFinishDistance || 
				Owner.Distance3D(FinishEndpoint) < MinFinishDistance) {
				Destroy();
			}
		}
	}
}
