/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items/items.dmi'
	amount = 5
	max_amount = 5
	w_class = 2
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if (!istype(M))
		user << "\red \The [src] cannot be applied to [M]!"
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon) || \
			istype(user, /mob/living/carbon/monkey)) )
		user << "\red You don't have the dexterity to do this!"
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.display_name == "head")
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << "\red You can't apply [src] through [H.head]!"
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << "\red You can't apply [src] through [H.wear_suit]!"
				return 1

		if(affecting.status & LIMB_ROBOT)
			user << "\red This isn't useful at all on a robotic limb.."
			return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			"\blue [M] has been applied with [src] by [user].", \
			"\blue You apply \the [src] to [M]." \
		)
		use(1)

	M.updatehealth()
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "medical gauze"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = "biotech=1"

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.open == 0)
			if(!affecting.bandage())
				user << "\red The wounds on [M]'s [affecting.display_name] have already been bandaged."
				return 1
			else
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message( 	"\blue [user] bandages [W.desc] on [M]'s [affecting.display_name].", \
										"\blue You bandage [W.desc] on [M]'s [affecting.display_name]." )
						//H.add_side_effect("Itch")
					else if (istype(W,/datum/wound/bruise))
						user.visible_message( 	"\blue [user] places bruise patch over [W.desc] on [M]'s [affecting.display_name].", \
										"\blue You place bruise patch over [W.desc] on [M]'s [affecting.display_name]." )
					else
						user.visible_message( 	"\blue [user] places bandaid over [W.desc] on [M]'s [affecting.display_name].", \
										"\blue You place bandaid over [W.desc] on [M]'s [affecting.display_name]." )
				use(1)
		else
			if (H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat burns, infected wounds, and relieve itching in unusual places..."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = "biotech=1"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "\red The wounds on [M]'s [affecting.display_name] have already been salved."
				return 1
			else
				user.visible_message( 	"\blue [user] salves wounds on [M]'s [affecting.display_name].", \
										"\blue You salve wounds on [M]'s [affecting.display_name]." )
				use(1)
		else
			if (H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/bruise_pack/tajaran
	name = "\improper S'rendarr's Hand leaf"
	singular_name = "S'rendarr's Hand leaf"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "shandp"
	heal_brute = 7

/obj/item/stack/medical/ointment/tajaran
	name = "\improper Messa's Tear petals"
	singular_name = "Messa's Tear petals"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "mtearp"
	heal_burn = 7


/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 12
	origin_tech = "biotech=1"

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.open == 0)
			var/bandaged = affecting.bandage()
			var/disinfected = affecting.disinfect()

			if(!(bandaged || disinfected))
				user << "\red The wounds on [M]'s [affecting.display_name] have already been treated."
				return 1
			else
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message( 	"\blue [user] cleans [W.desc] on [M]'s [affecting.display_name] and seals edges with bioglue.", \
										"\blue You clean and seal [W.desc] on [M]'s [affecting.display_name]." )
						//H.add_side_effect("Itch")
					else if (istype(W,/datum/wound/bruise))
						user.visible_message( 	"\blue [user] places medicine patch over [W.desc] on [M]'s [affecting.display_name].", \
										"\blue You place medicine patch over [W.desc] on [M]'s [affecting.display_name]." )
					else
						user.visible_message( 	"\blue [user] smears some bioglue over [W.desc] on [M]'s [affecting.display_name].", \
										"\blue You smear some bioglue over [W.desc] on [M]'s [affecting.display_name]." )
				if (bandaged)
					affecting.heal_damage(heal_brute,0)
				use(1)
		else
			if (H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 12
	origin_tech = "biotech=1"


/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)

		if(affecting.open == 0)
			if(!affecting.salve())
				user << "\red The wounds on [M]'s [affecting.display_name] have already been salved."
				return 1
			else
				user.visible_message( 	"\blue [user] covers wounds on [M]'s [affecting.display_name] with regenerative membrane.", \
										"\blue You cover wounds on [M]'s [affecting.display_name] with regenerative membrane." )
				affecting.heal_damage(0,heal_burn)
				use(1)
		else
			if (H.can_be_operated_on())        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>The [affecting.display_name] is cut open, you'll need more than a bandage!</span>"

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	var/being_applied = FALSE

/obj/item/stack/medical/splint/attack(mob/living/carbon/M, mob/user)
	if(..()) return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/limb/affecting = H.get_limb(user.zone_selected)
		var/limb = affecting.display_name

		if(!(affecting.name in list("l_arm","r_arm","l_leg","r_leg","r_hand","l_hand","r_foot","l_foot","chest","groin","head")))
			user << "<span class='warning'>You can't apply a splint there!</span>"
			return

		if(affecting.status & LIMB_DESTROYED)
			user << "<span class='warning'>[user == M ? "You don't" : "[M] doesn't"] have \a [limb]!</span>"
			return

		if(affecting.status & LIMB_SPLINTED)
			user << "<span class='warning'>[user == M ? "Your" : "[M]'s"] [limb] is already splinted!</span>"
			return

		if (M != user)
			user.visible_message(
			"<span class='warning'>[user] starts to apply [src] to [M]'s [limb].</span>",
			"<span class='notice'>You start to apply [src] to [M]'s [limb], hold still...</span>")
		else
			if((!user.hand && affecting.name == "r_arm") || (user.hand && affecting.name == "l_arm"))
				user << "<span class='warning'>You can't apply a splint to the arm you're using!</span>"
				return
			user.visible_message(
			"<span class='warning'>[user] starts to apply [src] to their [limb].</span>",
			"<span class='notice'>You start to apply [src] to your [limb], hold still...</span>")

		if(affecting.apply_splints(src,user,M)) use(1)//Referenced in external organ helpers.
