/datum/food_processor_process
	var/input
	var/output
	var/time = 40
	var/required_machine = /obj/machinery/processor
	var/multiplier = 1 //This multiplies the number of products produced per object processed.

/datum/food_processor_process/meat
	input = /obj/item/reagent_containers/food/snacks/meat/slab
	output = /obj/item/reagent_containers/food/snacks/meatball

/datum/food_processor_process/bacon
	input = /obj/item/reagent_containers/food/snacks/meat/rawcutlet
	output = /obj/item/reagent_containers/food/snacks/meat/rawbacon

/datum/food_processor_process/sweetpotato
	input = /obj/item/reagent_containers/food/snacks/grown/sweet_potato
	output = /obj/item/reagent_containers/food/snacks/yakiimo

/datum/food_processor_process/potato
	input = /obj/item/reagent_containers/food/snacks/grown/potato
	output = /obj/item/reagent_containers/food/snacks/fries

/datum/food_processor_process/carrot
	input = /obj/item/reagent_containers/food/snacks/grown/carrot
	output = /obj/item/reagent_containers/food/snacks/carrotfries

/datum/food_processor_process/soybeans
	input = /obj/item/reagent_containers/food/snacks/grown/soybeans
	output = /obj/item/reagent_containers/food/snacks/soydope

/datum/food_processor_process/spaghetti
	input = /obj/item/reagent_containers/food/snacks/doughslice
	output = /obj/item/food/spaghetti/raw

/datum/food_processor_process/corn
	input = /obj/item/reagent_containers/food/snacks/grown/corn
	output = /obj/item/reagent_containers/food/snacks/tortilla

/datum/food_processor_process/tortilla
	input = /obj/item/reagent_containers/food/snacks/tortilla
	output = /obj/item/reagent_containers/food/snacks/cornchips

/datum/food_processor_process/parsnip
	input = /obj/item/reagent_containers/food/snacks/grown/parsnip
	output = /obj/item/reagent_containers/food/snacks/roastparsnip

/datum/food_processor_process/towercap
	input = /obj/item/grown/log
	output = /obj/item/popsicle_stick
	multiplier = 3
