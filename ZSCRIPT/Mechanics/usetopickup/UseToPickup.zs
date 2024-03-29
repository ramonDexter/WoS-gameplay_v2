class UseToPickup : StaticEventHandler {
	Font MsgFont;
	int MsgFontHeight;
	String PickUpText;
	TextureID BracketTex;
	private ThinkerIterator PlayerStates, Drawables;
	private Array<Class<Actor> > ClassInfoClasses;
	private Array<U2P_ActorClassInfo> ClassInfo;
	
	override void OnRegister() {
		MsgFont = Font.FindFont('SMALLFONT');
		MsgFontHeight = MsgFont.GetHeight();
		PickUpText = StringTable.Localize("U2P_PickUpText", prefixed: false);
		
		BracketTex = TexMan.CheckForTexture("graphics/u2p/bracket.png", TexMan.Type_Any);
		if (!BracketTex.IsValid())
			ThrowAbortException("Can't find required texture %s!", "UseToPickup/bracket.png");
		
		Drawables = ThinkerIterator.Create('U2P_ItemHighlight');
		PlayerStates = ThinkerIterator.Create('U2P_PlayerState');
		
		ClassInfo.Clear();
		
		U2P_INIFile ini;
		ini.ReadLumpsNamed("UseToPickup.ini");
		ini.MergeByActorClass();
		
		for (let aci = 0, acs = AllActorClasses.Size(); aci < acs; aci++) {
			let ac = AllActorClasses[aci];
			let sec = ini.Section(ac.GetClassName());
			if (!sec)
				continue;
			
			let ci = new("U2P_ActorClassInfo");
			ci.ActorClass = ac;
			ci.Init(sec);
			ClassInfo.Push(ci);
			ClassInfoClasses.Push(ac);
		}
	}
	
	override void WorldLoaded(WorldEvent evt) {
		// If there are any stale or duplicate U2P_PlayerState objects, clean them up now.
		// Warn about duplicates; that's a bug.
		U2P_PlayerState psa[MAXPLAYERS];
		for (let i = 0; i < MAXPLAYERS; i++)
			psa[i] = null;
		
		U2P_PlayerState ps;
		for (PlayerStates.Reinit(); ps = U2P_PlayerState(PlayerStates.Next());) {
			let p = ps.PlayerNum;
			
			if (!playeringame[p]) {
				// This player is no longer in-game. Disconnected during loading, perhaps?
				ps.Destroy();
			}
			else if (psa[p]) {
				Console.Printf("\cgMultiple U2P_PlayerState instances for player number %d! Deleting one of them.", p);
				ps.Destroy();
			}
			else {
				psa[p] = ps;
				ps.Reinit();
			}
		}
		
		U2P_ItemHighlight d;
		for (Drawables.Reinit(); d = U2P_ItemHighlight(Drawables.Next());)
			d.Reinit();
	}
	
	U2P_PlayerState PlayerStateOf(int p) {
		U2P_PlayerState ps;
		for (PlayerStates.Reinit(); ps = U2P_PlayerState(PlayerStates.Next());)
		if (ps.PlayerNum == p)
			return ps;
		
		return null;
	}
	
	override void PlayerEntered(PlayerEvent evt) {
		let p = evt.PlayerNumber;
		
		// Don't apply to bots.
		if (players[p].bot)
			return;
		
		// Find a U2P_PlayerState for this player.
		if (!PlayerStateOf(p))
			// If none exists, create one.
			new('U2P_PlayerState').Init(players[p], p);
	}
	
	override void PlayerDisconnected(PlayerEvent evt) {
		// Find and destroy the U2P_PlayerState for the disconnecting player.
		let ps = PlayerStateOf(evt.PlayerNumber);
		if (ps)
			ps.Destroy();
	}
	
	override void RenderOverlay(RenderEvent evt) {
		if (automapactive || !playeringame[consoleplayer])
			return;
		
		U2P_DrawContext dc;
		dc.InitFromRenderEvent(evt);
		
		Drawables.Reinit();
		U2P_ItemHighlight drawable;
		while (drawable = U2P_ItemHighlight(Drawables.Next()))
		if (drawable.ps.PlayerNum == consoleplayer)
			U2P_ItemHighlight(drawable).Draw(dc);
	}
	
	static clearscope UseToPickup Get() {
		return UseToPickup(StaticEventHandler.Find('UseToPickup'));
	}
	
	clearscope U2P_ActorClassInfo ActorClassInfo(Class<Actor> actorClass) const {
		let idx = ClassInfoClasses.Find(actorClass);
		if (idx != ClassInfoClasses.Size())
			return ClassInfo[idx];
		else
			return null;
	}
	
	override void NetworkProcess(ConsoleEvent evt) {
		if (evt.Name == "UseToPickup_Push") {
			let ps = PlayerStateOf(evt.Player);
			if (ps)
				ps.PushFocusedItem();
			else
				Console.Printf("\cgNo U2P_PlayerState for player %d!", evt.Player);
		}
	}
	
	static const Name CVarNames[] = {
		'usetopickup_enabled',
		'usetopickup_highlight_color',
		'usetopickup_highlight_opacity',
		'usetopickup_highlight_opacity_unfocused',
		'usetopickup_fadeintime',
		'usetopickup_fadeouttime',
		'usetopickup_fulluserange',
		'usetopickup_highlight_range',
		'usetopickup_highlight_range_max',
		'usetopickup_pickupdelay',
		'usetopickup_scanfreq'
	};
	
	override void ConsoleProcess(ConsoleEvent evt) {
		if (evt.Name == 'UseToPickup_ResetAllCVars') {
			for (let i = 0, s = CVarNames.Size(); i < s; i++)
				CVar.FindCVar(CVarNames[i]).ResetToDefault();
		}
		else if (evt.Name == 'UseToPickup_DumpPlayerStates') {
			U2P_PlayerState ps;
			for (PlayerStates.Reinit(); ps = U2P_PlayerState(PlayerStates.Next());)
				Console.Printf(
					"Player %d (%s): phase %d, focused item %s",
					ps.PlayerNum,
					ps.Player.mo? ps.Player.mo.GetClassName() : 'None',
					ps.SelectPhase,
					ps.FocusedItem && ps.FocusedItem.Target?
						ps.FocusedItem.Target.GetClassName()
						: 'None'
				);
		}
	}
}
