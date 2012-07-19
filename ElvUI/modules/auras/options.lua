local E, L, V, P, G, _ = unpack(select(2, ...)); --Import: Engine, Locales, ProfileDB, GlobalDB
local A = E:GetModule('Auras')

E.Options.args.auras = {
	type = 'group',
	name = BUFFOPTIONS_LABEL,
	get = function(info) return E.db.auras[ info[#info] ] end,
	set = function(info, value) E.db.auras[ info[#info] ] = value; A:UpdateAllHeaders() end,
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L['AURAS_DESC'],
		},
		enable = {
			order = 2,
			type = 'toggle',
			name = L['Enable'],
		},
		consolidedBuffs = {
			order = 3,
			name = L['Consolidated Buffs'],
			desc = L['Display the consolidated buffs bar.'],
			type = 'toggle',
			set = function(info, value) 
				E.db.auras[ info[#info] ] = value
				E:GetModule('Minimap'):UpdateSettings()
				A:UpdateAllHeaders()
			end,					
		},
		general = {
			order = 4,
			type = 'group',
			guiInline = true,
			name = L['General'],
			args = {
				size = {
					type = 'range',
					name = L['Size'],
					desc = L['Set the size of the individual auras.'],
					min = 16, max = 40, step = 2,
					set = function(info, value) 
						E.db.auras[ info[#info] ] = value; 
						E:StaticPopup_Show("CONFIG_RL")
					end,						
				},
				wrapAfter = {
					type = 'range',
					name = L['Wrap After'],
					desc = L['Begin a new row or column after this many auras.'],
					min = 1, max = 40, step = 1,
				},		
				xSpacing = {
					type = 'range',
					name = L['X Spacing'],
					min = 1, max = 60, step = 1,				
				},
				ySpacing = {
					type = 'range',
					name = L['Y Spacing'],
					min = 1, max = 60, step = 1,				
				},				
			},
		},
		buffs = {
			order = 5,
			type = 'group',
			guiInline = true,
			name = L['Buffs'],
			get = function(info) return E.db.auras.buffs[ info[#info] ] end,
			set = function(info, value) E.db.auras.buffs[ info[#info] ] = value; A:UpdateAllHeaders() end,			
			args = {
				sortMethod = {
					name = L['Sort Method'],
					desc = L['Defines how the group is sorted.'],
					type = 'select',
					values = {
						['INDEX'] = L['Index'],
						['TIME'] = L['Time'],
						['NAME'] = L['Name'],
					},
				},
				sortDir = {
					name = L['Sort Direction'],
					desc = L['Defines the sort order of the selected sort method.'],
					type = 'select',
					values = {
						['+'] = '+',
						['-'] = '-',
					},				
				},
				maxWraps = {
					name = L['Max Wraps'],
					desc = L['Limit the number of rows or columns.'],
					type = 'range',
					min = 0, max = 40, step = 1,
				},
				seperateOwn = {
					name = L['Seperate'],
					desc = L['Indicate whether buffs you cast yourself should be separated before or after.'],
					type = 'select',
					values = {
						[-1] = L["Other's First"],
						[0] = L['No Sorting'],
						[1] = L['Your Auras First'],
					},
					order = -1,
				},
			},
		},	
		debuffs = {
			order = 6,
			type = 'group',
			guiInline = true,
			name = L['Debuffs'],
			get = function(info) return E.db.auras.debuffs[ info[#info] ] end,
			set = function(info, value) E.db.auras.debuffs[ info[#info] ] = value; A:UpdateAllHeaders() end,				
			args = {
				sortMethod = {
					name = L['Sort Method'],
					desc = L['Defines how the group is sorted.'],
					type = 'select',
					values = {
						['INDEX'] = L['Index'],
						['TIME'] = L['Time'],
						['NAME'] = L['Name'],
					},
				},
				sortDir = {
					name = L['Sort Direction'],
					desc = L['Defines the sort order of the selected sort method.'],
					type = 'select',
					values = {
						['+'] = '+',
						['-'] = '-',
					},				
				},
				maxWraps = {
					name = L['Max Wraps'],
					desc = L['Limit the number of rows or columns.'],
					type = 'range',
					min = 0, max = 40, step = 1,
				},
			},
		},				
	},
}