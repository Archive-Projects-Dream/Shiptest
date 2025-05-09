//space cash//
//Faster. Stronger. Able to form variable amounts of infinite size. Icon based on matrix transformations.

//Code borrowed from baycode by way of Eris.

/obj/item/spacecash
	name = "coin?"
	desc = "If you can see this, please make a bug report. If you're a mapper, use the bundle subtype!"
	icon = 'icons/obj/economy.dmi'
	icon_state = "credit0"
	throwforce = 1
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/value = 0
	grind_results = list(/datum/reagent/iron = 10)

/obj/item/spacecash/Initialize(mapload, amount)
	. = ..()
	if(amount)
		value = amount
	update_appearance()
	SSeconomy.physical_money += value

/obj/item/spacecash/proc/adjust_value(amount)
	value += amount
	SSeconomy.physical_money += amount
	update_appearance()

/obj/item/spacecash/proc/transfer_value(amount, obj/item/spacecash/target)
	amount = clamp(amount, 0, value)
	value -= amount
	target.value += amount
	target.update_appearance()

	if(value == 0)
		qdel(src)
		return

	update_appearance()

/obj/item/spacecash/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/bundle/bundle
		if(istype(W, /obj/item/spacecash/bundle))
			bundle = W
		else
			var/obj/item/spacecash/cash = W
			bundle = new (loc)
			bundle.value = cash.value
			cash.value = 0
			user.dropItemToGround(cash)
			qdel(cash)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dropItemToGround(src)
			H.dropItemToGround(bundle)
			H.put_in_hands(src)
			H.put_in_hands(bundle)
		to_chat(user, span_notice("You add [value] credits worth of money to the bundle.<br>It now holds [bundle.value + value] credits."))
		bundle.transfer_value(bundle.value, src)

/obj/item/spacecash/Destroy()
	SSeconomy.physical_money -= value
	value = 0 // Prevents money from be duplicated anytime.//I'll trust eris on this one
	return ..()

/obj/item/spacecash/bundle
	icon_state = "credit20"

/obj/item/spacecash/bundle/update_appearance()
	icon_state = "nothing"
	cut_overlays()
	var/remaining_value = value
	var/iteration = 0
	var/coins_only = TRUE
	var/list/coin_denominations = list(10, 5, 1)
	var/list/banknote_denominations = list(1000, 500, 200, 100, 50, 20)
	for(var/i in banknote_denominations)
		while(remaining_value >= i && iteration < 50)
			remaining_value -= i
			iteration++
			var/image/banknote = image('icons/obj/economy.dmi', "credit[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			banknote.transform = M
			overlays += banknote
			coins_only = FALSE

	if(remaining_value)
		for(var/i in coin_denominations)
			while(remaining_value >= i && iteration < 50)
				remaining_value -= i
				iteration++
				var/image/coin = image('icons/obj/economy.dmi', "credit[i]")
				var/matrix/M = matrix()
				M.Translate(rand(-6, 6), rand(-4, 8))
				coin.transform = M
				overlays += coin

	if(coins_only)
		if(value == 1)
			name = "one credit coin"
			desc = "Heavier then it looks."
			drop_sound = 'sound/items/handling/coin_drop.ogg'
			pickup_sound =  'sound/items/handling/coin_pickup.ogg'
		else
			name = "[value] credits"
			desc = "Heavier than they look."
			gender = PLURAL
			drop_sound = 'sound/items/handling/coin_drop.ogg'
			pickup_sound =  'sound/items/handling/coin_pickup.ogg'
	else
		if(value <= 3000)
			name = "[value] credits"
			gender = NEUTER
			desc = "Some cold, hard cash."
			drop_sound = 'sound/items/handling/dosh_drop.ogg'
			pickup_sound =  'sound/items/handling/dosh_pickup.ogg'
		else
			name = "[value] credits"
			gender = NEUTER
			desc = "That's a lot of dosh."
			drop_sound = 'sound/items/handling/dosh_drop.ogg'
			pickup_sound =  'sound/items/handling/dosh_pickup.ogg'
	return ..()

/obj/item/spacecash/bundle/attack_self()
	var/cashamount = input(usr, "How many credits do you want to take? (0 to [value])", "Take Money", 20) as num
	cashamount = round(clamp(cashamount, 0, value))
	if(!cashamount)
		return

	else if(!Adjacent(usr))
		to_chat(usr, span_warning("You need to be in arm's reach for that!"))
		return

	var/obj/item/spacecash/bundle/bundle = new(usr.loc)
	transfer_value(cashamount, bundle)
	usr.put_in_hands(bundle)
	update_appearance()

/obj/item/spacecash/bundle/AltClick(mob/living/user)
	var/cashamount = input(user, "How many credits do you want to take? (0 to [value])", "Take Money", 20) as num
	cashamount = round(clamp(cashamount, 0, value))
	if(!cashamount)
		return

	else if(!Adjacent(user))
		to_chat(user, span_warning("You need to be in arm's reach for that!"))
		return

	adjust_value(-cashamount)
	if(!value)
		user.dropItemToGround(src)
		qdel(src)

	var/obj/item/spacecash/bundle/bundle = new(user.loc, cashamount)
	user.put_in_hands(bundle)

/obj/item/spacecash/bundle/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src)
		if(value == 0)//may prevent any edge case duping
			qdel(src)
			return
		adjust_value(-1)
		user.put_in_hands(new /obj/item/spacecash/bundle(loc, 1))
		update_appearance()
	else
		. = ..()

/obj/item/spacecash/bundle/get_item_credit_value()//used for vendors and ids.
	return value

/obj/item/spacecash/bundle/c1
	value = 1
	icon_state = "credit1"

/obj/item/spacecash/bundle/c5
	value = 5
	icon_state = "credit5"

/obj/item/spacecash/bundle/c10
	value = 10
	icon_state = "credit10"

/obj/item/spacecash/bundle/c20
	value = 20
	icon_state = "credit20"

/obj/item/spacecash/bundle/c50
	value = 50
	icon_state = "credit50"

/obj/item/spacecash/bundle/c100
	value = 100
	icon_state = "credit100"

/obj/item/spacecash/bundle/c200
	value = 200
	icon_state = "credit200"

/obj/item/spacecash/bundle/c500
	value = 500
	icon_state = "credit500"

/obj/item/spacecash/bundle/c1000
	value = 1000
	icon_state = "credit1000"

/obj/item/spacecash/bundle/c10000
	value = 10000
	icon_state = "credit1000"

/obj/item/spacecash/bundle/pocketchange/Initialize()
	value = rand(10, 100)
	icon_state = "credit100"
	. = ..()

/obj/item/spacecash/bundle/smallrand/Initialize()
	value = rand(100, 500)
	icon_state = "credit200"
	. = ..()

/obj/item/spacecash/bundle/mediumrand/Initialize()
	value = rand(500, 3000)
	icon_state = "credit500"
	. = ..()

/obj/item/spacecash/bundle/loadsamoney/Initialize()
	value = rand(2500, 6000)
	icon_state = "credit1000"
	. = ..()
