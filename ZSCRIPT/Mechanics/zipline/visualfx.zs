class ProximityInteractionIcon : Actor
{
	Default {
		-SOLID;
		+NOINTERACTION;
		+FLOATBOB;
	}
	States
	{
	Spawn:
		IICN A 0 NoDelay A_CheckRange(128, "FadeOut");
		IICN A 3 A_FadeTo(0.8, 0.25, false);
		Goto Spawn;
	FadeOut:
		IICN A 3 A_FadeTo(0.0, 0.2, false);
		Goto Spawn;
	}
}

class ZipLineVisual : Actor {
	Default {
		+FLATSPRITE;
		+NOINTERACTION;
		Radius 40;
		Scale 0.5;
	}
	States {/*
		Spawn:
			// Make sure there is no overlap
			ZPLN B 0 NoDelay {
				if (CheckProximity("ZipLineVisual", Radius - 1, 1)) {
					Destroy();
				}
			}
		Idle:
		*/
		Spawn:
			ZPLN B -1;
			Stop;
	}
}