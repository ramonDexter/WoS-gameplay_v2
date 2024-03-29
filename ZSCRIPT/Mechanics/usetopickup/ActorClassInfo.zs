class U2P_ActorClassInfo {
	Class<Actor> ActorClass;
	String Tag;
	bool AlwaysTouchPickup, ForceTag, UsePickupMessageAsTag, UseSpriteDimensions, OverrideRadius, OverrideHeight, OverrideZOffset;
	double Radius, Height, ZOffset;
	
	void Init(U2P_INISection section) {
		Tag = StringTable.Localize(section.Get("Tag"));
		AlwaysTouchPickup = section.GetBool("AlwaysTouchPickup");
		ForceTag = section.GetBool("ForceTag");
		UsePickupMessageAsTag = section.GetBool("UsePickupMessageAsTag");
		UseSpriteDimensions = section.GetBool("UseSpriteDimensions", default: true);
		Radius = section.GetDouble("Radius", default: double.NaN);
		Height = section.GetDouble("Height", default: double.NaN);
		ZOffset = section.GetDouble("ZOffset", default: double.NaN);
		
		// This is a fun little trick. Unlike all other floating-point values, NaN does *not* equal itself, so we can detect whether a value is NaN by comparing it to itself.
		OverrideRadius = Radius == Radius;
		OverrideHeight = Height == Height;
		OverrideZOffset = ZOffset == ZOffset;
	}
}

