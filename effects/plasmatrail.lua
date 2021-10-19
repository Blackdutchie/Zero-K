return {
	["halberd_trail"] = {
		usedefaultexplosions = false,
		glow = {
			air                = true,
			class              = [[explspike]],
			count              = 12,
			ground             = true,
			water              = true,
			properties = {
				alpha              = 1,
				alphadecay         = 0.125,
				alwaysvisible      = false,
				color              = [[0,0.1,1]],
				dir                = [[-4 r8, -4 r8, -4 r8]],
				length             = 1,
				lengthgrowth       = 1,
				width              = 4,
			},
		},
		white = {
			air                = true,
			class              = [[explspike]],
			count              = 2,
			ground             = true,
			water              = true,
			properties = {
				alpha              = 1,
				alphadecay         = 0.125,
				alwaysvisible      = false,
				color              = [[1,1,1]],
				dir                = [[-2 r4, -2 r4, -2 r4]],
				length             = 1,
				lengthgrowth       = 1,
				width              = 2,
			},
		},
	},
	["plasma_cannon_muzzle_blue"] = {
		alwaysvisible        = false,
		usedefaultexplosions = false,
		shaft                = {
			air        = true,
			class      = [[CBitmapMuzzleFlame]],
			count      = 1,
			ground     = true,
			underwater = 1,
			water      = true,
			properties = {
				colormap     = [[1 1 1 0.025 0 0.1 1 0.01    0 0.1 1 0.01    0 0 0 0.01]],
				dir          = [[dir]],
				frontoffset  = 0,
				fronttexture = [[muzzlefront]],
				length       = 32,
				sidetexture  = [[muzzleside]],
				size         = 24,
				sizegrowth   = -0.5,
				ttl          = 16,
			},
		},
	},
	["plasmatrail_yellow_small"]  = {
		alwaysvisible        = false,
		usedefaultexplosions = false,
		head                 = {
			air        = true,
			class      = [[heatcloud]],
			count      = 2,
			ground     = true,
			water      = true,
			underwater = 1,
			unit       = 1,
			properties = {
				alwaysvisible = false,
				heat          = 100,
				heatfalloff   = 15,
				maxheat       = 100,
				pos           = [[0 0 0]],
				size          = 10,
				sizegrowth    = -2.5,
				speed         = [[0 0 0]],
				texture       = [[redexplo]],
			},
		},
		shaft                = {
			air        = true,
			class      = [[CBitmapMuzzleFlame]],
			count      = 1,
			ground     = true,
			underwater = 1,
			water      = true,
			properties = {
				colormap     = [[1 0.7 0.2 0.01    1 0.7 0.2 0.01    0 0 0 0.01]],
				dir          = [[dir]],
				frontoffset  = 0,
				fronttexture = [[muzzlefront]],
				length       = -3,
				sidetexture  = [[muzzleside]],
				size         = 4,
				sizegrowth   = -0.3,
				ttl          = 4,
			},
		},
		sparks               = {
			class      = [[CSimpleParticleSystem]],
			count      = 1,
			ground     = true,
			air        = true,
			unit       = 1,
			water      = true,
			underwater = true,
			properties = {
				airdrag             = 0.7,
				alwaysvisible       = false,
				colormap            = [[1 0.7 0.2 0.01    1 0.7 0.2 0.01    0 0 0 0.01]],
				directional         = true,
				emitrotspread       = 0.1,
				emitvector          = [[dir]],
				gravity             = [[0 -0.01 0]];
				numparticles        = 2,
				particlelife        = 10,
				particlelifespread  = 10,
				particlesize        = 2.5,
				particlesizespread  = 0.5,
				particlespeed       = -0.25,
				particlespeedspread = 0.2,
				pos                 = [[-2r4 -2r4 -2r4]],
				sizegrowth          = 0,
				sizemod             = 0.95,
				texture             = [[redexplo]],
			},
		},
	},
	["plasmatrail_blue_small"]    = {
		alwaysvisible        = false,
		usedefaultexplosions = false,
		head                 = {
			class      = [[CSimpleParticleSystem]],
			count      = 1,
			ground     = true,
			air        = true,
			unit       = true,
			water      = true,
			underwater = true,
			properties = {
				airdrag             = 0.8,
				alwaysvisible       = false,
				colormap            = [[1 1 1 0.05   0.01 0.005 0.02 0.01]],
				directional         = true,
				emitrotspread       = 0,
				emitvector          = [[dir]],
				gravity             = [[0 0 0]];
				numparticles        = 1,
				particlelife        = 6,
				particlelifespread  = 0,
				particlesize        = [[6r4]],
				particlesizespread  = 0,
				particlespeed       = 0,
				particlespeedspread = 0.5,
				pos                 = [[0 0 0]],
				sizegrowth          = 0,
				sizemod             = 0.5,
				texture             = [[bluenovaexplo]],
			},
		},
		shaft                = {
			air        = true,
			class      = [[CBitmapMuzzleFlame]],
			count      = 1,
			ground     = true,
			underwater = 1,
			water      = true,
			properties = {
				colormap     = [[0 0.1 1 0.01    0 0.1 1 0.01    0 0 0 0.01]],
				dir          = [[dir]],
				frontoffset  = 0,
				fronttexture = [[null]],
				length       = -4,
				sidetexture  = [[lightb]],
				size         = 4,
				sizegrowth   = -0.3,
				ttl          = 5,
			},
		},
		menacing_spikes = {
			air                = true,
			class              = [[explspike]],
			count              = 12,
			ground             = true,
			water              = true,
			properties = {
				alpha              = 1,
				alphadecay         = 0.5,
				alwaysvisible      = false,
				color              = [[0,0.1,1]],
				dir                = [[-4 r8, -4 r8, -4 r8]],
				length             = 12,
				lengthgrowth       = -3,
				width              = 4,
			},
		},
		sparks               = {
			class      = [[CSimpleParticleSystem]],
			count      = 1,
			ground     = true,
			air        = true,
			unit       = 1,
			water      = true,
			underwater = true,
			properties = {
				airdrag             = 0.6,
				alwaysvisible       = false,
				colormap            = [[0 0.1 1 0.01    0 0.1 1 0.01    0 0 0 0.01]],
				directional         = true,
				emitrot             = 180,
				emitrotspread       = 2,
				emitvector          = [[0 0 0]],
				gravity             = [[0 0 0]];
				numparticles        = [[r5]],
				particlelife        = 20,
				particlelifespread  = 5,
				particlesize        = 10,
				particlesizespread  = 0.5,
				particlespeed       = 1.5,
				particlespeedspread = 0,
				pos                 = [[-2r4 -2r4 -2r4]],
				sizegrowth          = 0.1,
				sizemod             = 0.8,
				texture             = [[lightb]],
			},
		},
	}
}

