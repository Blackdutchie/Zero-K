unitDef = {
  unitname                      = [[mahlazer]],
  name                          = [[Starlight]],
  description                   = [[Planetary Energy Chisel]],
  acceleration                  = 0,
  activateWhenBuilt             = true,
  brakeRate                     = 0,
  buildAngle                    = 32700,
  buildCostEnergy               = 40000,
  buildCostMetal                = 40000,
  builder                       = false,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 11,
  buildingGroundDecalSizeY      = 11,
  buildingGroundDecalType       = [[mahlazer_aoplane.dds]],
  buildPic                      = [[mahlazer.png]],
  buildTime                     = 40000,
  canAttack                     = true,
  category                      = [[SINK]],
  collisionVolumeOffsets        = [[0 0 0]],
  collisionVolumeScales         = [[120 120 120]],
  collisionVolumeTest           = 1,
  collisionVolumeType           = [[ellipsoid]],
  corpse                        = [[DEAD]],

  customParams                  = {
    description_fr = [[Lazer ? Charge ?liptique]],
	description_de = [[Planetarischer Energiemeißel]],
	description_pl = [[Laser Orbitalny]],
    helptext       = [[This large scale tool is used to shape terrain for terraforming projects. Also useful as a cleanser of obstacles such as pesky enemy units and bases.]],
    helptext_fr    = [[Le Starlight est un b?timent abritant un puissant g?n?rateur de faisceau laser ?liptique, dont l'impact est param?trable. Sa puissance est telle qu'il coupe tout sur son passage, y compris les alli?s. Pensez ? pr?voir un espace d?gag? autour de lui pour ?viter que le laser ne coupe votre base en deux en d?marrant.]],
	helptext_de    = [[Diese gigantische Waffe nutzt ihren energetischen Strahl, um große Gräben im Terrain zu hinterlassen und dabei alles, was sich ihr in den Weg stellt, auszulöschen. Ebenfalls als Auslöscher von störenden Hindernissen, wie zum Beispiel nervtötende feindliche Enheiten und Basen, sehr nützlich.]],
	helptext_pl    = [[Starlight to precyzyjne narzedzie przeznaczone do szybkiego niszczenia celow w dowolnym miejscu na mapie.]],
	modelradius    = [[60]],
	select_no_rotate   = [[1]], -- tells selection widgets to treat the unit as if it has no rotation.
  },

  explodeAs                     = [[ATOMIC_BLAST]],
  footprintX                    = 8,
  footprintZ                    = 8,
  iconType                      = [[mahlazer]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  mass                          = 2013,
  maxDamage                     = 10000,
  maxSlope                      = 18,
  maxVelocity                   = 0,
  maxWaterDepth                 = 0,
  minCloakDistance              = 150,
  noChaseCategory               = [[FIXEDWING LAND SHIP SATELLITE SWIM GUNSHIP SUB HOVER]],
  objectName                    = [[lazer.3do]],
  script                        = [[mahlazor.lua]],
  onoffable                     = true,
  seismicSignature              = 4,
  selfDestructAs                = [[ATOMIC_BLAST]],

  sfxtypes                      = {

    explosiongenerators = {
      [[custom:IMMA_LAUNCHIN_MAH_LAZER]],
    },

  },

  side                          = [[ARM]],
  sightDistance                 = 660,
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  workerTime                    = 0,
  yardMap                       = [[oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo]],

  weapons                       = {

    {
      def                = [[TARGETER]],
      badTargetCategory  = [[FIXEDWING GUNSHIP SATELLITE]],
      onlyTargetCategory = [[SWIM LAND SINK TURRET FLOAT SHIP HOVER FIXEDWING GUNSHIP SATELLITE]],
    },  
  
    {
      def                = [[LAZER]],
      onlyTargetCategory = [[NONE]],
    },
	
	{
      def                = [[RELAYLAZER]],
      onlyTargetCategory = [[NONE]],
    },
	
	{
      def                = [[CUTTER]],
      onlyTargetCategory = [[NONE]],
    },
	
	{
      def                = [[RELAYCUTTER]],
      onlyTargetCategory = [[NONE]],
    },
  },


  weaponDefs                    = {

    TARGETER = {
      name                    = [[Aimer (fake)]],
      alwaysVisible           = 18,
      areaOfEffect            = 56,
      avoidFeature            = false,
      avoidFriendly           = false,
      avoidNeutral            = false,
      avoidGround             = false,
      beamTime                = 0.001,
      coreThickness           = 0.5,

      damage                  = {
        default = -0.00001,
      },

      explosionGenerator      = [[custom:NONE]],
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 12,
      minIntensity            = 1,
      range                   = 9000,
      reloadtime              = 20,
      rgbColor                = [[0.25 0 1]],
      soundStart              = [[weapon/laser/heavy_laser4]],
      soundTrigger            = true,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 0,
      tolerance               = 65536,
      turret                  = true,
      waterWeapon             = true,
      weaponType              = [[BeamLaser]],
    },
  
	LAZER    = {
      name                    = [[Craterpuncher]],
      alwaysVisible           = 0,
      areaOfEffect            = 140,
      avoidFeature            = false,
      avoidNeutral            = false,
      avoidGround             = false,
      beamTime                = 0.001,
      coreThickness           = 0.5,
      craterBoost             = 4,
      craterMult              = 8,

	  customParams        	  = {
		stats_damage = 3000,
	  },

      damage                  = {
        default = 180,
      },

      explosionGenerator      = [[custom:FLASHLAZER]],
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 12,
      minIntensity            = 1,
      range                   = 9000,
      reloadtime              = 20,
      rgbColor                = [[0.25 0 1]],
	  scrollSpeed             = 8,
      soundStartVolume        = 1,
      soundTrigger            = true,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 100,
      tolerance               = 65536,
	  tileLength              = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponType              = [[BeamLaser]],
    },
	
	RELAYLAZER    = {
      name                    = [[Relay Craterpuncher (fake)]],
      alwaysVisible           = 18,
      areaOfEffect            = 56,
      avoidFeature            = false,
      avoidNeutral            = false,
      avoidGround             = false,
      beamTime                = 0.001,
      canattackground         = false,
      coreThickness           = 0.5,
      craterBoost             = 2,
      craterMult              = 4,

      damage                  = {
        default = 180,
      },

      explosionGenerator      = [[custom:FLASHLAZER]],
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 12,
      minIntensity            = 1,
      range                   = 9000,
      reloadtime              = 20,
      rgbColor                = [[0.25 0 1]],
	  scrollSpeed             = 8,
      soundTrigger            = true,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 100,
      tolerance               = 65536,
	  tileLength              = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponType              = [[BeamLaser]],
    },
	
	CUTTER    = {
      name                    = [[Groovecutter]],
      alwaysVisible           = 0,
      areaOfEffect            = 140,
      avoidFeature            = false,
      avoidNeutral            = false,
      avoidGround             = false,
      beamTime                = 0.001,
      coreThickness           = 0.5,
      craterBoost             = 4,
      craterMult              = 8,

      damage                  = {
        default = 180,
      },

      explosionGenerator      = [[custom:FLASHLAZER]],
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 12,
      minIntensity            = 1,
      range                   = 9000,
      reloadtime              = 20,
      rgbColor                = [[0.25 0 1]],
	  scrollSpeed             = 8,
      soundStartVolume        = 1,
      soundTrigger            = true,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 50,
      tolerance               = 65536,
	  tileLength              = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponType              = [[BeamLaser]],
    },
	
	RELAYCUTTER    = {
      name                    = [[Relay Cutter (fake)]],
      alwaysVisible           = 18,
      areaOfEffect            = 56,
      avoidFeature            = false,
      avoidNeutral            = false,
      avoidGround             = false,
      beamTime                = 0.001,
      canattackground         = false,
      coreThickness           = 0.5,
      craterBoost             = 2,
      craterMult              = 4,

      damage                  = {
        default = 180,
      },

      explosionGenerator      = [[custom:FLASHLAZER]],
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 12,
      minIntensity            = 1,
      range                   = 9000,
      reloadtime              = 20,
      rgbColor                = [[0.25 0 1]],
	  scrollSpeed             = 8,
      soundTrigger            = true,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 50,
      tolerance               = 65536,
	  tileLength              = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponType              = [[BeamLaser]],
    },
  },


  featureDefs                   = {

    DEAD  = {
      description      = [[Wreckage - Starlight]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 10000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[40]],
      hitdensity       = [[100]],
      metal            = 16000,
      object           = [[starlight_d.dae]],
      reclaimable      = true,
      reclaimTime      = 16000,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Starlight]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 10000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 8000,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 8000,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ mahlazer = unitDef })
