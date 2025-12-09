local distributionTable = VehicleDistributions[1]

VehicleDistributions.McLarenF1GloveBox = {
    rolls = 7,
    items ={
        "Pistol", 0.3,
        "Gloves_LeatherGloves", 1,
        "Glasses_Aviators", 2,
    }
}

VehicleDistributions.McLarenF1Misc = {
    rolls = 10,
    items ={

        "FirstAidKit", 0.3,
        "Shotgun", 0.3,
        "Purse", 5,
    }
}

VehicleDistributions.McLarenF1 = {

	GloveBox = VehicleDistributions.McLarenF1GloveBox;
	TruckBed = VehicleDistributions.McLarenF1Misc;
}

distributionTable["McLarenF1"] = { Normal = VehicleDistributions.McLarenF1; }


