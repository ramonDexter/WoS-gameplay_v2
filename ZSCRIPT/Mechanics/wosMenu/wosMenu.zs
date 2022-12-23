class wos_menuHandler : wos_ZF_Handler {
	wos_RPG_menu link;

	override void buttonClickCommand(wos_ZF_Button caller, name command) {
		if( command == "cmd_accuracy_plus" ) {
			// button action ///////////////////////////////////////////////////
			// raise accuracy one //
			wosEventHandler.SendNetworkEvent("raise_accuracy");
			Menu.MenuSound("menu/choose");
			////////////////////////////////////////////////////////////////////
			// close menu //////////////////////////////////////////////////////
			let curmenu = Menu.GetCurrentMenu();
			if (curmenu != null) curmenu.Close();
			// close menu //////////////////////////////////////////////////////
		}
		else if( command == "cmd_stamina_plus" ) {
			// button action ///////////////////////////////////////////////////
			// raise stamina by one //
			wosEventHandler.SendNetworkEvent("raise_stamina");
			Menu.MenuSound("menu/choose");
			////////////////////////////////////////////////////////////////////
			// close menu //////////////////////////////////////////////////////
			let curmenu = Menu.GetCurrentMenu();
			if (curmenu != null) curmenu.Close();
			// close menu //////////////////////////////////////////////////////
		}
		else if( command  == "cmd_mind_plus" ) {
			// button action ///////////////////////////////////////////////////
			// mindValue by one //
			wosEventHandler.SendNetworkEvent("raise_mind");
			Menu.MenuSound("menu/choose");
			////////////////////////////////////////////////////////////////////
			// close menu //////////////////////////////////////////////////////
			let curmenu = Menu.GetCurrentMenu();
			if (curmenu != null) curmenu.Close();
			// close menu //////////////////////////////////////////////////////
		}
		/*else if( command == "cmd_menu_accept" ) {
			// button action ///////////////////////////////////////////////////
			// apply raised stat //

			////////////////////////////////////////////////////////////////////
			// close menu //////////////////////////////////////////////////////
			let curmenu = Menu.GetCurrentMenu();
			if (curmenu != null) curmenu.Close();
			// close menu //////////////////////////////////////////////////////
		}*/
		else if( command == "cmd_menu_close" ) {
			// close menu //////////////////////////////////////////////////////
			let curmenu = Menu.GetCurrentMenu();
			if (curmenu != null) curmenu.Close();
			// close menu //////////////////////////////////////////////////////
		}
	}
}
class wos_RPG_menu : wos_ZF_GenericMenu {
	wos_menuHandler handler; // handler
	Font smallFont; // font for text
	//let pawn = binderPlayer(CPlayer.mo);//players [consoleplayer].mo;//

	// number holders //
	//int rpgMenu_accuracy_base;
	//int rpgMenu_accuracy_modded;
	//int rpgMenu_stamina_base;
	//int rpgMenu_stamina_modded;
	//int rpgMenu_mind_base;
	//int rpgMenu_mind_modded;

	
	// buttons //
	//wos_ZF_Button rpgMenu_btn_minus_accuracy;
	//wos_ZF_Button rpgMenu_btn_minus_stamina;
	//wos_ZF_Button rpgMenu_btn_minus_mind;
	wos_ZF_Button rpgMenu_btn_plus_accuracy;
	wos_ZF_Button rpgMenu_btn_plus_stamina;
	wos_ZF_Button rpgMenu_btn_plus_mind;
	wos_ZF_Button rpgMenu_btn_accept;
	wos_ZF_Button rpgMenu_btn_exit;
	// labels //
	//wos_ZF_Label accuracyTextLabel;
	//wos_ZF_Label staminaTextLabel;
	//wos_ZF_Label mindTextLabel;

	// images //
	wos_ZF_Image rpgMenu_img_background;
	wos_ZF_Image rpgeMenu_img_foreground;

	// init //
	override void Init (Menu parent) {
		Vector2 baseRes = (320, 200);

		Super.Init(parent); // Call GenericMenu's 'Init' function to do some required initialization.
		SetBaseResolution(baseRes); // Set our base resolution to 320x200.
		smallFont = "smallfont"; //set font to smallfont
		handler = new("wos_menuHandler");
		handler.link = self;

		//let pawn = binderPlayer(players [consoleplayer].mo);
		// base numbers init //
		//rpgMenu_accuracy_base = pawn.accuracy;
		//rpgMenu_stamina_base = pawn.stamina;
		//rpgMenu_mind_base = pawn.mindValue;


		// background image //
		rpgMenu_img_background = wos_ZF_Image.Create (
			(0, 0), // position
			(320, 200), // size
			"graphics/wosmenu/statMenu_back.png", //image path/name
			wos_ZF_Image.AlignType_TopLeft // alignment options
		);
		rpgMenu_img_background.Pack(mainFrame);
		// foreground image //
		rpgeMenu_img_foreground = wos_ZF_Image.Create (
			(0, 0),
			(320, 200),
			"graphics/wosmenu/statMenu_front.png", 
			wos_ZF_Image.AlignType_TopLeft
		);
		rpgeMenu_img_foreground.Pack(mainFrame);

		// labels //
		/*let labelAccuracyBaseText = String.Format("%i", rpgMenu_accuracy_base);
		let labelStaminaBaseText = String.Format("%i", rpgMenu_stamina_base);
		let labelMindBaseText = String.Format("%i", rpgMenu_mind_base);

		accuracyTextLabel = wos_ZF_Label.Create(
			(158, 110), // position
			( smallfont.StringWidth (labelAccuracyBaseText), smallFont.GetHeight () ), // size
			text: labelAccuracyBaseText, // label text
			fnt: smallfont, // used font
			wrap: false, // Whether to automatically wrap the text or not.
			autoSize: true, // Whether to automatically resize the element based on the text width.
			textColor: Font.CR_YELLOW // The text's colour.
		);
		staminaTextLabel = wos_ZF_Label.Create(
			(158, 121), // position
			( smallfont.StringWidth (labelStaminaBaseText), smallFont.GetHeight () ), //size
			text: labelStaminaBaseText, // label text
			fnt: smallfont, // used font
			wrap: false, // Whether to automatically wrap the text or not.
			autoSize: true, // Whether to automatically resize the element based on the text width.
			textColor: Font.CR_YELLOW // The text's colour.
		);
		mindTextLabel = wos_ZF_Label.Create(
			(158, 132), // position
			( smallfont.StringWidth (labelMindBaseText), smallFont.GetHeight () ), //size
			text: labelMindBaseText, // label text
			fnt: smallfont, // used font
			wrap: false, // Whether to automatically wrap the text or not.
			autoSize: true, // Whether to automatically resize the element based on the text width.
			textColor: Font.CR_YELLOW // The text's colour.
		);*/

		// create button textures //
		// idle //
		let button_plus_idle = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_un_plus.png", true);
		let button_minus_idle = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_un_minus.png", true);
		let button_menu_accept_idle = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_un_yes.png", true);
		let button_menu_close_idle = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_un_no.png", true);
		// hover //
		let button_plus_hover = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_hv_plus.png", true);
		let button_minus_hover = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_hv_minus.png", true);
		let button_menu_accept_hover = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_hv_yes.png", true);
		let button_menu_close_hover = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_hv_no.png", true);
		// pressed //
		let button_plus_click = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_pr_plus.png", true);
		let button_minus_click = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_pr_minus.png", true);
		let button_menu_accept_click = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_pr_yes.png", true);
		let button_menu_close_click = wos_ZF_BoxTextures.CreateSingleTexture("graphics/wosmenu/statbutton_pr_no.png", true);

		

		// add buttons //

		// accuracy //
		rpgMenu_btn_plus_accuracy = wos_ZF_Button.Create(
			( ((baseRes.X - 8.0) / 2.0) + 10, ((baseRes.Y - 8.0) / 2.0) + 11 ), // position
			(8, 8), // size
			text : "",
			cmdHandler : handler,
			command : "cmd_accuracy_plus", // command string for button
			inactive : button_plus_idle,
			hover : button_plus_hover,
			click : button_plus_click,
			fnt : smallfont,
			textScale : 1,
			textColor : Font.CR_WHITE,
			holdInterval : -1,
			wos_ZF_Button.AlignType_Center
		);
		rpgMenu_btn_plus_accuracy.Pack(mainFrame);
		// stamina //
		rpgMenu_btn_plus_stamina = wos_ZF_Button.Create(
			( ((baseRes.X - 8.0) / 2.0) + 10, ((baseRes.Y - 8.0) / 2.0) + 22 ), // position
			(8, 8), // size
			text : "",
			cmdHandler : handler,
			command : "cmd_stamina_plus", // command string for button
			inactive : button_plus_idle,
			hover : button_plus_hover,
			click : button_plus_click,
			fnt : smallfont,
			textScale : 1,
			textColor : Font.CR_WHITE,
			holdInterval : -1,
			wos_ZF_Button.AlignType_Center
		);
		rpgMenu_btn_plus_stamina.Pack(mainFrame);
		// mind //
		rpgMenu_btn_plus_mind = wos_ZF_Button.Create(
			( ((baseRes.X - 8.0) / 2.0) + 10, ((baseRes.Y - 8.0) / 2.0) + 34 ), // position
			(8, 8), // size
			text : "",
			cmdHandler : handler,
			command : "cmd_mind_plus", // command string for button
			inactive : button_plus_idle,
			hover : button_plus_hover,
			click : button_plus_click,
			fnt : smallfont,
			textScale : 1,
			textColor : Font.CR_WHITE,
			holdInterval : -1,
			wos_ZF_Button.AlignType_Center
		);
		rpgMenu_btn_plus_mind.Pack(mainFrame);
		// menu controls //
		/*rpgMenu_btn_accept = wos_ZF_Button.Create(
			( ((baseRes.X - 24.0) / 2.0) + 10, ((baseRes.Y - 11.0) / 2.0) + 60 ), // position
			(24, 11), // size
			cmdHandler : handler,
			command : "cmd_menu_accept", // command string for button
			inactive : button_menu_accept_idle,
			hover : button_menu_accept_hover,
			click : button_menu_accept_click
		);*/
		rpgMenu_btn_exit = wos_ZF_Button.Create(
			( ((baseRes.X - 24.0) / 2.0) + 10, ((baseRes.Y - 11.0) / 2.0) + 72 ), // position
			(24, 11), // size
			text : "",
			cmdHandler : handler,
			command : "cmd_menu_close", // command string for button
			inactive : button_menu_close_idle,
			hover : button_menu_close_hover,
			click : button_menu_close_click,
			fnt : smallfont,
			textScale : 1,
			textColor : Font.CR_WHITE,
			holdInterval : -1,
			wos_ZF_Button.AlignType_Center
		);
		rpgMenu_btn_exit.Pack(mainFrame);

		// play sound on menu open /////////////////////////////////////////////
		Menu.MenuSound("sounds/journalUse");

	}

	/*override void Ticker() {
		
		while ( ( rpgMenu_accuracy_modded != null ) || ( rpgMenu_stamina_modded != null ) || ( rpgMenu_mind_modded != null ) )

		// label for accuracy //
		let labelAccuracyBaseText = String.Format(i:rpgMenu_accuracy_base);
		let labelAccuracyModdedText = String.Format(i:playerAccuracyModded);
		
		// label for stamina //
		let labelStaminaBaseText = String.Format(i:rpgMenu_stamina_base);
		let labelStaminaModdedText = String.Format(i:);
		// label for mind //
		let labelMindBaseText = String.Format(i:rpgMenu_mind_base);
		let labelMindModdedText = String.Format(i:);
	}*/

}