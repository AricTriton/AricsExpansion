extends Node

var traits = {
	"Foul Mouth": {
		"name": "Foul Mouth",
		"description": "All too often, $name uses words more suited for construction workers and sailors. \n\n[color=aqua]Vocal occupations are less effective. Max Charm -25. [/color]",
		"effect": {
			"code": "foul_mouth",
			"charm_max": -25,
			"charm": 0
		},
		"tags": [
			"mental",
			"detrimental",
			"convotraits"
		],
		"conflict": [
			"Mute"
		]
	},
	"Mute": {
		"name": "Mute",
		"description": "$name can't speak in a normal way and only uses signs and moans to communicate. \n\n[color=aqua]Obedience growth +25%. Can't work at occupations requiring speech. [/color]",
		"effect": {
			"code": "mute",
			"obed_mod": 0.25
		},
		"tags": [
			"mental",
			"detrimental",
			"convotraits"
		],
		"conflict": [
			"Foul Mouth",
			"Pretty voice",
			"Lisp",
			"Stutter"
		]
	},
	"Devoted": {
		"name": "Devoted",
		"description": "$name trusts you to a great degree. $His willingness to follow you caused $him to find new strengths in $his character. \n\n[color=aqua]Max Courage +25. Max Wit +25. Min Loyalty: 80.[/color]",
		"effect": {
			"code": "devoted",
			"cour_max": 25,
			"wit_max": 25,
			"loyal_min": 80,
			"loyal": 0
		},
		"tags": [
			"mental",
			"secondary"
		],
		"conflict": [
			""
		]
	},
	"Passive": {
		"name": "Passive",
		"description": "$name prefers to go with the flow and barely tries to proactively affect $his surroundings. \n\n[color=aqua]Can't take management related jobs. Obedience growth +25%. [/color]",
		"effect": {
			"code": "passive",
			"obed_mod": 0.25
		},
		"tags": [
			"mental"
		],
		"conflict": [
			""
		]
	},
	"Masochist": {
		"name": "Masochist",
		"description": "$name enjoys pain far more than $he should. \n\n[color=aqua]Physical punishments are more effective and cause lust to grow. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy",
			"lockedtrait"
		],
		"conflict": [
		]
	},
	"Deviant": {
		"name": "Deviant",
		"description": "$name has a fondness for very unusual sexual practices. A cat or dog is fine for $him too. \n\n[color=aqua]Degrading sexual actions have no penalty. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy",
			"secondary",
		],
		"conflict": [
			"Prude"
		]
	},
	"Slutty": {
		"name": "Slutty",
		"description": "Your influence over $name caused $him to accept sex in many forms and enjoy $his body to the fullest. \n\n[color=aqua]Max Confidence +25. Max Charm +25. Min Loyalty: 80. [/color]",
		"effect": {
			"code": "slutty",
			"charm_max": 25,
			"conf_max": 25,
			"loyal_min": 80,
			"loyal": 0
		},
		"tags": [
			"mental",
			"sexual",
			"perversy",
			"secondary"
		],
		"conflict": [
			""
		]
	},
	"Bisexual": {
		"name": "Bisexual",
		"description": "$name is open to having affairs with people of the same sex. \n\n[color=aqua]Same-sex encounters are easier to accept. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"sexualitytrait",
			"lockedtrait"
		],
		"conflict": [
			"Homosexual",
		]
	},
	"Homosexual": {
		"name": "Homosexual",
		"description": "$name is only expecting to have same-sex affairs. \n\n[color=aqua]Same-sex encounters have no penalty, opposite sex actions are unpreferred. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"secondary",
			"sexualitytrait",
			"lockedtrait"
		],
		"conflict": [
			"Bisexual",
		]
	},
	"Monogamous": {
		"name": "Monogamous",
		"description": "$name does not favor random encounters and believes there is one true partner in life for $him. \n\n[color=aqua]Refuses to work as prostitute. Loyalty builds faster from sex with master. Sleeping with other partners is more stressful. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental"
		],
		"conflict": [
			"Fickle"
		]
	},
	"Pretty voice": {
		"name": "Pretty voice",
		"description": "$name's voice is downright charming, making surrounding people just want to hear more of it.\n\n[color=aqua]Vocal occupations are more effective. Charm +20. [/color]",
		"effect": {
			"code": "pretty_voice",
			"charm": 20
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Mute"
		]
	},
	"Clingy": {
		"name": "Clingy",
		"description": "$name gets easily attached to people. However, this behavior is rarely met with acceptance, which in turn annoys $him. \n\n[color=aqua]Loyalty growth +35%. Obedience drops quickly if constantly ignored. [/color]",
		"effect": {
			"code": "clingy",
			"loyal_mod": 0.35
		},
		"tags": [
			"mental"
		],
		"conflict": [
			""
		]
	},
	"Fickle": {
		"name": "Fickle",
		"description": "$name prefers having as many sexual partners as possible, unable to stay confined to only one person for long. \n\n[color=aqua]Prostitution job bonus, multiple partners are unlocked by default. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental"
		],
		"conflict": [
			"Monogamous",
		]
	},
	"Weak": {
		"name": "Weak",
		"description": "$name is rather weak compared to others. \n\n[color=aqua]Strength -2[/color]",
		"effect": {
			"code": "weak",
			"str_mod": -2,
			"str_max": 0,
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Strong"
		]
	},
	"Strong": {
		"name": "Strong",
		"description": "$name has been blessed with greater strength than most. $He also appears to be harder to tame. \n\n[color=aqua]Strength +2, Obedience growth -20%[/color]",
		"effect": {
			"code": "strong",
			"str_mod": 2,
			"str_max": 0,
			"obed_mod": -0.2
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Weak"
		]
	},
	"Clumsy": {
		"name": "Clumsy",
		"description": "$name's reflexes are somewhat slower, than the others. \n\n[color=aqua]Agility -2, physical occupations are less effective[/color]",
		"effect": {
			"code": "clumsy",
			"agi_mod": -2,
			"agi_max": 0
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Quick"
		]
	},
	"Quick": {
		"name": "Quick",
		"description": "$name is very active whenever $he does something. However, it also makes $his nervous system less stable. \n\n[color=aqua]Agility +2, Stress change +20%[/color]",
		"effect": {
			"code": "quick",
			"agi_mod": 2,
			"agi_max": 0,
			"stress_mod": 0.2
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Clumsy"
		]
	},
	"Magic Deaf": {
		"name": "Magic Deaf",
		"description": "$name's senses are very dull when it comes to magic. \n\n[color=aqua]Magic Affinity -2[/color]",
		"effect": {
			"code": "magicdeaf",
			"maf_mod": -2,
			"maf_max": 0
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Responsive"
		]
	},
	"Responsive": {
		"name": "Responsive",
		"description": "$name is in touch with raw energy, making $him potentially useful in magic area. \n\n[color=aqua]Magic Affinity +2, Toxicity change +20%[/color]",
		"effect": {
			"code": "responsive",
			"maf_mod": 2,
			"maf_max": 0,
			"tox_mod": 0.2
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Magic Deaf"
		]
	},
	"Frail": {
		"name": "Frail",
		"description": "$name's body is much less durable than most. $His physical potential is severely impaired. \n\n[color=aqua]Endurance -2[/color]",
		"effect": {
			"code": "frail",
			"end_mod": -2,
			"end_max": 0
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Robust"
		]
	},
	"Robust": {
		"name": "Robust",
		"description": "$name's physique is way better than most. \n\n[color=aqua]Endurance +2, Fear change -20%[/color]",
		"effect": {
			"code": "robust",
			"end_mod": 2,
			"end_max":0,
			"fear_mod": -0.2
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Frail"
		]
	},
	"Scarred": {
		"name": "Scarred",
		"description": "$name's body is covered in massive burn scars. Besides being terrifying to look at, this also makes $him suffer from low confidence.\n\n[color=aqua]Charm -30. Beauty -30. [/color]",
		"effect": {
			"code": "scarred",
			"charm": -30,
			"beautybase": -30
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			""
		]
	},
	"Blemished": {
		"name": "Blemished",
		"description": "$name's skin is covered in a lot of imperfections. Besides being unappealing to look at, this also makes $him suffer from low self esteem.\n\n[color=aqua]Charm -10. Beauty -10. [/color]",
		"effect": {
			"code": "blemished",
			"charm": -10,
			"beautybase": -10
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Natural Beauty"
		]
	},
	"Natural Beauty": {
		"name": "Natural Beauty",
		"description": "$name is unusually pretty since $his birth and often was an object of envy. \n\n[color=aqua]Beauty +35. [/color]",
		"effect": {
			"code": "beauty",
			"beautybase": 35
		},
		"tags": [
			"physical",
		],
		"conflict": [
			"Blemished"
		]
	},
	"Coward": {
		"name": "Coward",
		"description": "$name is of a meek character and has a difficult time handling $himself in physical confrontations. \n\n[color=aqua]Physical punishments build fear quicker, stress in combat grows twice as fast. [/color]",
		"effect": {
			"code": "coward",
			"cour_max": -20,
			"cour": -20,
		},
		"tags": [
			"detrimental",
			"mental"
		],
		"conflict": [
			""
		]
	},
	"Alcohol Intolerance": {
		"name": "Alcohol Intolerance",
		"description": "$name does not stomach alcoholic beverages too well. \n\n[color=aqua]Alcohol intake makes slave drunker a lot quicker. [/color]",
		"effect": {
		},
		"tags": [
			"detrimental",
			"physical"
		],
		"conflict": [
			""
		]
	},
	"Prude": {
		"name": "Prude",
		"description": "$name is very intolerant of many sexual practices, believing there are many inappropriate behaviors which shouldn't be practiced.\n\n[color=aqua]Sexual actions are harder to initiate and are less impactful. Refuses to work on sex-related jobs. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental"
		],
		"conflict": [
			"Pervert",
			"Deviant",
			"Fickle"
		]
	},
	"Pervert": {
		"name": "Pervert",
		"description": "$name has a pretty broad definition of stuff $he finds enjoyable.\n\n[color=aqua]Sexual actions are easier to unlock. Fetishist actions have no penalty. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy"
		],
		"conflict": [
			"Prude"
		]
	},
	"Clever": {
		"name": "Clever",
		"description": "$name is more prone to creative thinking than an average person, which makes $him learn faster. \n\n[color=aqua]Teach effectiveness increased by 25%. [/color]",
		"effect": {
		},
		"tags": [
			"mental"
		],
		"conflict": [
			"Ditzy"
		]
	},
	"Pliable": {
		"name": "Pliable",
		"description": "$name is still naive and can be swayed one way or another... \n\n[color=aqua]Has room for changes and growth. [/color]",
		"effect": {
			
		},
		"tags": [
			"mental"
		],
		"conflict": [
			""
		]
	},
	"Dominant": {
		"name": "Dominant",
		"description": "$name really prefers to be in control, instead of being controlled. \n\n[color=aqua]Obedience growth -20%. Confidence +25. Max Confidence +15.	[/color]",
		"effect": {
			"code": "dominant",
			"conf_max": 15,
			"conf": 25,
			"obed_mod": -0.2
		},
		"tags": [
			"mental",
			"lockedtrait"
		],
		"conflict": [
		]
	},
	"Submissive": {
		"name": "Submissive",
		"description": "$name is very comfortable when having someone $he can rely on. \n\n[color=aqua]Obedience growth +40%. No penalty for rape actions as long as loyalty is above average. Confidence -10. Max Confidence -30. [/color]",
		"effect": {
			"code": "submissive",
			"conf_max": -30,
			"conf": -10,
			"obed_mod": 0.4
		},
		"tags": [
			"mental",
			"lockedtrait"
		],
		"conflict": [
		]
	},
	"Infertile": {
		"name": "Infertile",
		"description": "$name appear to have a rare condition making $him much less likely to have children. \n\n[color=aqua]Impregnation chance greatly reduced. [/color]",
		"effect": {
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Fertile",
			"Virility 1",
			"Virility 2",
			"Virility 3",
			"Virility 4",
			"Virility 5",
			"Egg Strength 1",
			"Egg Strength 2",
			"Egg Strength 3",
			"Egg Strength 4",
			"Egg Strength 5",
		]
	},
	"Infirm": {
		"name": "Infirm",
		"description": "$name's wounds require additional care. \n\n[color=aqua]Natural regeneration is greatly reduced. [/color]",
		"effect": {
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			""
		]
	},
	"Uncivilized": {
		"name": "Uncivilized",
		"description": "$name has spent most of $his lifetime in the wilds barely interacting with modern society and acting more like an animal. As a result, $he can't realistically fit into common groups and be accepted there. \n\n[color=aqua]Social jobs disabled. Max Wit -50. Max Obedience -30. Max Loyalty -65. [/color]",
		"effect": {
			"code": "uncivilized",
			"wit_max": -50,
			"wit": 0,
			"obed_max": -30,
			"obed": 0,
			"loyal_max": -65,
			"loyal": 0
		},
		"tags": [
			"secondary"
		],
		"conflict": [
			""
		]
	},
	"Regressed": {
		"name": "Regressed",
		"description": "Due to some circumstances, $name's mind reversed to infantile state. $He's barely capable of normal tasks, but $he's a lot more responsive to social training.\n\n[color=aqua]Social jobs disabled. [/color]",
		"effect": {
			"code": "regressed"
		},
		"tags": [
			"secondary",
			"mental"
		],
		"conflict": [
			""
		]
	},
	"Sex-crazed": {
		"name": "Sex-crazed",
		"description": "$name barely can keep $his mind off dirty stuff. $His perpetual excitement makes $him look and enjoy nearly everything at the cost of $his sanity. \n\n[color=aqua]Max Wit -80. Max Confidence -60. Min Lust +50. No penalty from any sexual activity. Brothel assignments are more effective. [/color]",
		"effect": {
			"code": "sexcrazed",
			"wit_max": -80,
			"wit": 0,
			"conf_max": -60,
			"conf": 0,
			"lust_min": 50,
			"lust": 0
		},
		"tags": [
			"secondary",
			"mental",
			"perversy",
			"detrimental"
		],
		"conflict": [
			""
		]
	},
	"Likes it rough": {
		"name": "Likes it rough",
		"description": "$name secretly enjoys being treated badly and taken by force. \n\n[color=aqua]Rape actions cause no loyalty and obedience reduction. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy"
		],
		"conflict": [
			""
		]
	},
	"Enjoys Anal": {
		"name": "Enjoys Anal",
		"description": "$name is quite comfortable with $his ass being used for pleasure and even favors it. \n\n[color=aqua]Anal actions are more effective and preferred. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy",
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Ascetic": {
		"name": "Ascetic",
		"description": "$name cares little about luxury around $him. \n\n[color=aqua]Luxury demands are lowered. [/color]",
		"effect": {
			
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Spoiled"
		]
	},
	"Spoiled": {
		"name": "Spoiled",
		"description": "$name cares a great deal about the environment around $him and expects to be treated well. \n\n[color=aqua]Luxury demands are increased. [/color]",
		"effect": {
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Ascetic"
		]
	},
	"Small Eater": {
		"name": "Small Eater",
		"description": "[color=aqua]Food consumption reduced to 1/3. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"unique",
		],
		"conflict": [
			""
		]
	},
	"Hard Worker": {
		"name": "Hard Worker",
		"description": "[color=aqua]+15% gold from non-sexual occupations. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"mental",
			"unique",
		],
		"conflict": [
			""
		]
	},
	"Sturdy": {
		"name": "Sturdy",
		"description": "[color=aqua]Takes 15% less damage in combat [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"unique",
		],
		"conflict": [
			""
		]
	},
	"Influential": {
		"name": "Influential",
		"description": "[color=aqua]Selling slaves worth 20% more gold. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Gifted": {
		"name": "Gifted",
		"description": "[color=aqua]+20% upgrade points received. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Scoundrel": {
		"name": "Scoundrel",
		"description": "[color=aqua]+15 gold per day. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"unique",
		],
		"conflict": [
			""
		]
	},
	"Nimble": {
		"name": "Nimble",
		"description": "[color=aqua]+25% to hit chances. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"unique",
		],
		"conflict": [
			""
		]
	},
	"Authority": {
		"name": "Authority",
		"description": "[color=aqua]If obedience is above 95, all other slaves gain +5 obedience per day. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Mentor": {
		"name": "Mentor",
		"description": "[color=aqua]Slaves below level 3 gain +5 exp points per day[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Experimenter": {
		"name": "Experimenter",
		"description": "[color=aqua]Produces a random potion once in a while[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]
	},
	"Grateful": {
		"name": "Grateful",
		"description": "Due to your actions, $name will overlook certain hardships in order to stay close to you.\n\n [color=aqua]No luxury requirements. [/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
		],
		"conflict": [
			""
		]		
	},
###---Added by Expansion---###
#Physical Traits
	"Fertile": {
		"name": "Fertile",
		"description": "$name's body seems to crave bearing children. $He is far more likely to get pregnant than most.\n\n[color=aqua]Impregnation chance greatly improved. [/color]",
		"effect": {
			"code": "fertile",
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Infertile",
			"Impenetrable Eggs"
		]
	},
	"Soaker": {
		"name": "Soaker",
		"description": "$name's pussy gets extremely wet when $he is aroused.\n\n[color=aqua]Lubrication doubled when over 50%.[/color]",
		"effect": {
			"code": "soaker",
		},
		"tags": [
			"physical",
			"sexual",
			"lockedtrait",
		],
		"conflict": [
			""
		]
	},
#Mental and Quirky Traits
	"Ditzy": {
		"name": "Ditzy",
		"description": "$name is very pretty but a life of getting by on looks has left $his wit lacking.\n\n[color=aqua]Natural Beauty increased by 40.\n[/color][color=red]Max Wit decreased by 20. [/color]",
		"effect": {
			"code": "ditzy",
			"beautybase": 40,
			"wit_max": -20,
			"wit": 0,
			"wit_base": -20
		},
		"tags": [
			"expansiontrait",
			"convotrait",
			"detrimental",
			"physical",
			"unique",
		],
		"conflict": [
			"Clever"
		]		
	},
	"Lisp": {
		"name": "Lisp",
		"description": "$name has some oversized lips and/or has sucked too many dicks. $He can't help but lisp $his words now. It makes $him sound ridiculous when trying to excercize authority.\n\n[color=red]Speech: Lisp\nConfidence reduced by 20[/color]",
		"effect": {
			"code": "lisp",
			"conf_max": -20,
			"conf": -20,
			"conf_base": -20,
		},
		"tags": [
			"expansiontrait",
			"convotrait",
			"detrimental",
			"physical"
		],
		"conflict": [
			"Mute"
		]		
	},
	"Stutter": {
		"name": "Stutter",
		"description": "$name has a fairly bad stutter that crops up at inconvenient times. It can sometimes get frustrating to converse with.\n\n[color=red]Speech: Stutter\nCharm reduced by 20[/color]",
		"effect": {
			"code": "stutter",
			"charm_max": -20,
			"charm": -20,
			"charm_base": -20,
		},
		"tags": [
			"expansiontrait",
			"convotrait",
			"detrimental",
			"physical"
		],
		"conflict": [
			"Mute"
		]		
	},
	"Sadist": {
		"name": "Sadist",
		"description": "$name enjoys inflicting pain far more than $he should and it makes $him really turned on. \n\n[color=aqua]May request to punish $his sexual parners. [/color]",
		"effect": {
			
		},
		"tags": [
			"sexual",
			"mental",
			"perversy",
			"lockedtrait"
		],
		"conflict": [
		]
	},
	"Undiscovered Trait": {
		"name": "Undiscovered Trait",
		"description": "$name acts strangely sometimes. You suspect that $he has a [color=aqua]Fetish[/color] influencing $him that you have not discovered by talking to $him yet.\n\n[color=aqua]Hidden Trait: Talk to $him about Fetishes to Reveal[/color]",
		"effect": {
			
		},
		"tags": [
			"expansiontrait",
			"lockedtrait",
		],
		"conflict": [
		]
	},
	#Movement Traits
	"Movement: Flying": {
		"name": "Movement: Flying",
		"description": "$name is currently flapping $his wings and hovering around.\n\n[color=green]Attack and Speed increased by 125%\n[/color]\n[color=aqua]Will Fly until under 50 Energy[/color]",
		"effect": {
			"code": "flying",
		},
		"tags": [
			"expansiontrait",
			"secondary",
			"lockedtrait",
			"movetrait"
		],
		"conflict": [
			"Movement: Walking",
			"Movement: Crawling",
			"Movement: Immobilized"
		]		
	},
	"Movement: Walking": {
		"name": "Movement: Walking",
		"description": "$name is walking around like normal.\n\n[color=aqua]Normal Movement.[/color]",
		"effect": {
			"code": "walking",
		},
		"tags": [
			"expansiontrait",
			"secondary",
			"lockedtrait",
			"movetrait"
		],
		"conflict": [
			"Movement: Flying",
			"Movement: Crawling",
			"Movement: Immobilized"
		]		
	},
	"Movement: Crawling": {
		"name": "Movement: Crawling",
		"description": "Either due to low energy, restraints, $his unnatural breast size, or your rules, $name is currently crawling on the ground.\n\n[color=red]Only able to Crawl.\nUnable to travel in the Party.\nUnable to work many jobs.[/color]",
		"effect": {
			"code": "crawling",
		},
		"tags": [
			"expansiontrait",
			"secondary",
			"lockedtrait",
			"movetrait"
		],
		"conflict": [
			"Movement: Flying",
			"Movement: Walking",
			"Movement: Immobilized"
		]		
	},
	"Movement: Immobilized": {
		"name": "Movement: Immobilized",
		"description": "Either due to low energy, restraints, $his unnatural breast size, or a physical detriment, $name is currently unable to move at all.\n\n[color=red]Unable to Move.\nUnable to travel in the Party.\nUnable to work many jobs.[/color]",
		"effect": {
			"code": "immobilized",
		},
		"tags": [
			"expansiontrait",
			"secondary",
			"lockedtrait",
			"movetrait"
		],
		"conflict": [
			"Movement: Flying",
			"Movement: Walking",
			"Movement: Crawling"
		]		
	},
	"Sexuality: Fully Straight": {
		"name": "Sexuality: Fully Straight",
		"description": "$name is as straight as straight can be, only enjoying sexual relations with members of the opposite sex.\n\n[color=aqua]No chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]Guaranteed chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "fullystraight",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Mostly Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Truly Bisexual",
			"Sexuality: Occassionally Straight",
			"Sexuality: Mostly Gay",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Mostly Straight": {
		"name": "Sexuality: Mostly Straight",
		"description": "$name is pretty straight, but a particularly attractive member of the same sex may sway them.\n\n[color=aqua]Slight chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]High chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "mostlystraight",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Truly Bisexual",
			"Sexuality: Occassionally Straight",
			"Sexuality: Mostly Gay",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Occassionally Gay": {
		"name": "Sexuality: Occassionally Gay",
		"description": "$name is generally straight, but $he has had some homosexual experiences in the past and isn't opposed to them.\n\n[color=aqua]Low chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]Decent chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "rarelygay",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Mostly Straight",
			"Sexuality: Truly Bisexual",
			"Sexuality: Occassionally Straight",
			"Sexuality: Mostly Gay",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Truly Bisexual": {
		"name": "Sexuality: Truly Bisexual",
		"description": "$name identifies as truly bisexual and will consider sex with anyone of any gender.\n\n[color=aqua]Low chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Low chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "bi",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Mostly Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Occassionally Straight",
			"Sexuality: Mostly Gay",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Occassionally Straight": {
		"name": "Sexuality: Occassionally Straight",
		"description": "$name is generally homosexual, but $he has had some straight experiences in the past and isn't opposed to them.\n\n[color=red]Decent chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Low chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "rarelystraight",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Mostly Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Truly Bisexual",
			"Sexuality: Mostly Gay",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Mostly Gay": {
		"name": "Sexuality: Mostly Gay",
		"description": "$name is pretty homosexual, but a particularly attractive member of the opposite sex may sway them.\n\n[color=red]High chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Slight chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "mostlygay",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Mostly Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Truly Bisexual",
			"Sexuality: Occassionally Straight",
			"Sexuality: Fully Gay"
		]		
	},
	"Sexuality: Fully Gay": {
		"name": "Sexuality: Fully Gay",
		"description": "$name is as gay as gay can be, only enjoying sexual relations with members of the same sex.\n\n[color=red]Guaranteed chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]No chance of arousal penalty to any members of the same sex.[/color]",
		"effect": {
			"code": "fullygay",
		},
		"tags": [
			"sexual",
			"secondary",
			"expansiontrait",
			"lockedtrait",
			"sexualitytrait"
		],
		"conflict": [
			"Sexuality: Fully Straight",
			"Sexuality: Mostly Straight",
			"Sexuality: Occassionally Gay",
			"Sexuality: Truly Bisexual",
			"Sexuality: Occassionally Straight",
			"Sexuality: Mostly Gay"
		]		
	},
#Traits by Rendrassa
	"Anxious": {
	"name": "Anxious",
		"description": "$name is always a little worried about things. \n\n[color=aqua]Fear and stress gain +10%. [/color]",
		"effect": {
			"code": "anxious",
			"fear_mod": 0.1,
			"stress_mod": 0.1
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Dominant",
			"Fearless",
			"Stoic"
		]
	},
	"Paranoid": {
		"name": "Paranoid",
		"description": "$name is always worrying about things. \n\n[color=aqua]Fear and stress gain +20%. [/color]",
		"effect": {
			"code": "paranoid",
			"fear_mod": 0.2,
			"stress_mod": 0.2
		},
		"tags": [
			"mental"
		],
		"conflict": [
			"Dominant",
			"Fearless",
			"Stoic"
		]
	},
	"Observant": {
		"name": "Observant",
		"description": "$name has the potential for above average intelligence. \n\n[color=aqua]Increased Wit cap. [/color]",
		"effect": {
			"code": "observant",
			"wit_max": +20,
		},
		"tags": [
			"mental"
		],
		"conflict": [
			"Ditzy"
		]
	},
	"Fearless": {
		"name": "Fearless",
		"description": "$name is very courageous and isn't easily frightened. \n\n[color=aqua] Fear is much harder to inflict. [/color]",
		"effect": {
			"code": "fearless",
			"fear_mod": -0.3,
			"cour": 25,
			"conf": 25
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Anxious",
			"Paranoid",
			"Coward",
			"Stoic",
			"Passive"
		]
	},
	"Stoic": {
		"name": "Stoic",
		"description": "$name's mental state isn't as easily affected. \n\n[color=aqua] Stress and fear accumulates slower. [/color]",
		"effect": {
			"code": "stoic",
			"fear_mod": -0.1,
			"stress_mod": -0.1
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Anxious",
			"Paranoid",
			"Coward",
			"Fearless"
		]
	},
	"Composed": {
		"name": "Composed",
		"description": "$name doesn't let the strain of things get to $him easily. \n\n[color=aqua]Stress increases slower.[/color]",
		"effect": {
			"code": "composed",
			"stress_mod": -0.25
		},
		"tags": [
			"mental",
		],
		"conflict": [
			"Anxious",
			"Paranoid",
			"Coward"
		]
	},
	"Natural Cleansing": {
		"name": "Natural Cleansing",
		"description": "$name has a very healthy body and is able to detoxify $his body better than others. \n\n[color=aqua]Toxicity recovers 20% faster.[/color]",
		"effect": {
			"code": "naturalcleansing",
			"tox_mod": -1
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Responsive",
			"Frail"
		]
	},
	"Hearty": {
		"name": "Hearty",
		"description": "$name is an incredibly healthy individual. \n\n[color=aqua]+20 HP.[/color]",
		"effect": {
			"code": "hearty",
			"health_bonus": 20
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Infirm",
			"Frail",
			"Weak",
			"Wimpy"
		]
	},
	"Wimpy": {
		"name": "Wimpy",
		"description": "$name is a less healthy individual. \n\n[color=aqua]-20 HP.[/color]",
		"effect": {
			"code": "wimpy",
			"health_bonus": -20
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Hearty",
			"Robust",
			"Sturdy"
		]
	},
	"Vigorous": {
		"name": "Vigorous",
		"description": "$name is a rather energetic person. \n\n[color=aqua]+25 daily energy.[/color]",
		"effect": {
			"code": "vigorous",
			"energy_mod": 25
		},
		"tags": [
			"physical"
		],
		"conflict": [
			"Torpid",
			"Frail"
		]
	},
	"Torpid": {
		"name": "Torpid",
		"description": "$name seems to have trouble with energy. \n\n[color=aqua]-25 daily energy.[/color]",
		"effect": {
			"code": "torpid",
			"energy_mod": -25
		},
		"tags": [
			"physical",
			"detrimental"
		],
		"conflict": [
			"Vigrous",
			"Robust"
		]
	},
	#Lactation Trait Line
	"Lactating": {
		"name": "Lactating",
		"description": "$name's breasts are swollen and lactating.\n\n[color=aqua]Primary Trait for Lactation Trait Line.[/color]",
		"effect": {
			
		},
		"tags": [
			"expansiontrait",
			"lockedtrait",
			"lactation-trait",
		],
		"conflict": [
			""
		]		
	},
	"Weak Milk Flow": {
		"name": "Weak Milk Flow",
		"description": "$name produces far less milk than average for their race. \n\n [color=red]Milk production reduced by 50%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"negative-trait",
		],
		"conflict": [
			"Milk Flow 1",
			"Milk Flow 2",
			"Milk Flow 3",
			"Milk Flow 4",
			"Milk Flow 5",
		]		
	},
	"Milk Flow 1": {
		"name": "Milk Flow 1",
		"description": "[color=aqua]Good Milk Flow[/color]: $name produces just slightly more milk than someone of $his race. \n\n [color=green]Milk production increased by 20%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"rank1",
		],
		"conflict": [
			"Weak Milk Flow",
			"Milk Flow 2",
			"Milk Flow 3",
			"Milk Flow 4",
			"Milk Flow 5"
		]		
	},
	"Milk Flow 2": {
		"name": "Milk Flow 2",
		"description": "[color=aqua]Steady Milk Production[/color]: $name produces slightly more milk than others of $his race. \n\n [color=green]Milk production increased by 40%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"rank2",
		],
		"conflict": [
			"Weak Milk Flow",
			"Milk Flow 1",
			"Milk Flow 3",
			"Milk Flow 4",
			"Milk Flow 5"
		]		
	},
	"Milk Flow 3": {
		"name": "Milk Flow 3",
		"description": "[color=aqua]Leaking Nipples[/color]: $name produces far more milk than others of $his race. This may lead to embarrassing moments.\n\n [color=green]Milk production increased by 60%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"rank3",
		],
		"conflict": [
			"Weak Milk Flow",
			"Milk Flow 1",
			"Milk Flow 2",
			"Milk Flow 4",
			"Milk Flow 5"
		]		
	},
	"Milk Flow 4": {
		"name": "Milk Flow 4",
		"description": "[color=aqua]Spurting Nipples[/color]: $name can't stop dripping milk. This causes a lot of embarrassing moments and minor pain if not milked regularly.\n\n[color=green]Milk production increased by 80%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"rank4",
		],
		"conflict": [
			"Weak Milk Flow",
			"Milk Flow 1",
			"Milk Flow 2",
			"Milk Flow 3",
			"Milk Flow 5"
		]		
	},
	"Milk Flow 5": {
		"name": "Milk Flow 5",
		"description": "[color=aqua]Gushing Nipples[/color]: $name spurts milk everywhere $he goes and $his breasts ache when not being drained of the milk.\n\n[color=green]Milk production increased by 100%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"regentrait",
			"rank5",
		],
		"conflict": [
			"Weak Milk Flow",
			"Milk Flow 1",
			"Milk Flow 2",
			"Milk Flow 3",
			"Milk Flow 4"
		]		
	},
	"Small Milk Glands": {
		"name": "Small Milk Glands",
		"description": "$name can't hold as much milk in $his breasts as normal due to tiny milk glands.\n\n [color=red]Breasts can only store 50% the normal amount of milk[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"negative-trait",
		],
		"conflict": [
			"Milk Storage 1",
			"Milk Storage 2",
			"Milk Storage 3",
			"Milk Storage 4",
			"Milk Storage 5",
		]		
	},
	"Milk Storage 1": {
		"name": "Milk Storage 1",
		"description": "[color=aqua]Firm Breasts[/color]: $name has glands that can hold more milk than average in $his glands, causing a constant firmness to them when full.\n\n [color=green]Milk storage increased by 20%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"rank1",
		],
		"conflict": [
			"Small Milk Glands",
			"Milk Storage 2",
			"Milk Storage 3",
			"Milk Storage 4",
			"Milk Storage 5"
		]		
	},
	"Milk Storage 2": {
		"name": "Milk Storage 2",
		"description": "[color=aqua]Lumpy Breasts[/color]: $name has glands that can hold more milk than average in $his glands causing a slight lumpiness from the glands when full.\n\n [color=green]Milk storage increased by 40%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"rank2",
		],
		"conflict": [
			"Small Milk Glands",
			"Milk Storage 1",
			"Milk Storage 3",
			"Milk Storage 4",
			"Milk Storage 5"
		]		
	},
	"Milk Storage 3": {
		"name": "Milk Storage 3",
		"description": "[color=aqua]Swollen Breasts[/color]: $name has glands that can hold far more milk than average in $his glands causing a very noticable swelling to their shape when full.\n\n [color=green]Milk storage increased by 60%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"rank3",
		],
		"conflict": [
			"Small Milk Glands",
			"Milk Storage 1",
			"Milk Storage 2",
			"Milk Storage 4",
			"Milk Storage 5"
		]		
	},
	"Milk Storage 4": {
		"name": "Milk Storage 4",
		"description": "[color=aqua]Bulging Breasts[/color]: $name has glands that can hold far more milk than average in $his glands causing a severe bulbousness to their shape when full.\n\n [color=green]Milk storage increased by 80%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"rank4",
		],
		"conflict": [
			"Small Milk Glands",
			"Milk Storage 1",
			"Milk Storage 2",
			"Milk Storage 3",
			"Milk Storage 5"
		]		
	},
	"Milk Storage 5": {
		"name": "Milk Storage 5",
		"description": "[color=aqua]Distended Breasts[/color]: $name has glands that can grow to twice their normal size, causing the breasts to painfully double in size when full of milk.\n\n [color=green]Milk storage increased by 100%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"expansiontrait",
			"lactation-trait",
			"storagetrait",
			"rank5",
		],
		"conflict": [
			"Small Milk Glands",
			"Milk Storage 1",
			"Milk Storage 2",
			"Milk Storage 3",
			"Milk Storage 4"
		]		
	},
	"Impenetrable Eggs": {
		"name": "Impenetrable Eggs",
		"description": "$name's eggs are extremely hard for sperm to penetrate.\n\n [color=red]Virility of Cum in Pussy reduced by 50%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"negative-trait",
		],
		"conflict": [
			"Egg Strength 1",
			"Egg Strength 2",
			"Egg Strength 3",
			"Egg Strength 4",
			"Egg Strength 5",
		]		
	},
	"Egg Strength 1": {
		"name": "Egg Strength 1",
		"description": "[color=aqua]Weakened Egg Walls[/color]: $name's egg walls are slightly weaker than average during ovulation.\n\n [color=green]Virility of Cum in Pussy increased by 20%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"rank1",
		],
		"conflict": [
			"Impenetrable Eggs",
			"Egg Strength 2",
			"Egg Strength 3",
			"Egg Strength 4",
			"Egg Strength 5",
		]		
	},
	"Egg Strength 2": {
		"name": "Egg Strength 2",
		"description": "[color=aqua]Receptive Eggs[/color]:$name's egg walls are weaker than average during ovulation.\n\n [color=green]Virility of Cum in Pussy increased by 40%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"rank2",
		],
		"conflict": [
			"Impenetrable Eggs",
			"Egg Strength 1",
			"Egg Strength 3",
			"Egg Strength 4",
			"Egg Strength 5",
		]		
	},
	"Egg Strength 3": {
		"name": "Egg Strength 3",
		"description": "[color=aqua]Fertile Eggs[/color]: $name's egg walls are weaker than most of $his race and easier for sperm to penetrate.\n\n [color=green]Virility of Cum in Pussy increased by 60%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"rank3",
		],
		"conflict": [
			"Impenetrable Eggs",
			"Egg Strength 1",
			"Egg Strength 2",
			"Egg Strength 4",
			"Egg Strength 5",
		]		
	},
	"Egg Strength 4": {
		"name": "Egg Strength 4",
		"description": "[color=aqua]Highly Fertile Eggs[/color]: $name's egg walls are incredible weak-shelled and easily penetrated by sperm.\n\n [color=green]Virility of Cum in Pussy increased by 80%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"rank4",
		],
		"conflict": [
			"Impenetrable Eggs",
			"Egg Strength 1",
			"Egg Strength 2",
			"Egg Strength 3",
			"Egg Strength 5",
		]		
	},
	"Egg Strength 5": {
		"name": "Egg Strength 5",
		"description": "[color=aqua]Defenseless Egg Walls[/color]: $name's egg walls are so weak even the weakest sperm can get into them. They have a high pregnancy chance.\n\n [color=green]Virility of Cum in Pussy increased by 100%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"eggstrtrait",
			"rank5",
		],
		"conflict": [
			"Impenetrable Eggs",
			"Egg Strength 1",
			"Egg Strength 2",
			"Egg Strength 3",
			"Egg Strength 4",
		]		
	},
	"Weak Virility": {
		"name": "Weak Virility",
		"description": "$name has far weaker potency in $his sperm than most.\n\n [color=red]Virility of Semen reduced by 50%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"negative-trait",
		],
		"conflict": [
			"Virility 1",
			"Virility 2",
			"Virility 3",
			"Virility 4",
			"Virility 5",
		]		
	},
	"Virility 1": {
		"name": "Virility 1",
		"description": "[color=aqua]Increased Virility[/color]: $name is slightly more virile than average.\n\n [color=green]Virility of Semen increased by 150%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"rank1",
		],
		"conflict": [
			"Weak Virility",
			"Virility 2",
			"Virility 3",
			"Virility 4",
			"Virility 5",
		]		
	},
	"Virility 2": {
		"name": "Virility 2",
		"description": "[color=aqua]Enhanced Virility[/color]: $name is much more virile than average.\n\n [color=green]Virility of Semen increased by 200%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"rank2",
		],
		"conflict": [
			"Weak Virility",
			"Virility 1",
			"Virility 3",
			"Virility 4",
			"Virility 5",
		]		
	},
	"Virility 3": {
		"name": "Virility 3",
		"description": "[color=aqua]Exceptional Virility[/color]: $name has sperm than really put in the extra mile.\n\n [color=green]Virility of Semen increased by 300%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"rank3",
		],
		"conflict": [
			"Weak Virility",
			"Virility 1",
			"Virility 2",
			"Virility 4",
			"Virility 5",
		]		
	},
	"Virility 4": {
		"name": "Virility 4",
		"description": "[color=aqua]Incredible Virility[/color]: $name is so virile that a firm handshake could impregnate someone.\n\n [color=green]Virility of Semen increased by 400%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"rank4",
		],
		"conflict": [
			"Weak Virility",
			"Virility 1",
			"Virility 2",
			"Virility 3",
			"Virility 5",
		]		
	},
	"Virility 5": {
		"name": "Virility 5",
		"description": "[color=aqua]Unnatural Virility[/color]: $name's sperm could impregnate someone just by looking at them.\n\n [color=green]Virility of Semen increased by 500%[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"fertility-trait",
			"virilitytrait",
			"rank5",
		],
		"conflict": [
			"Weak Virility",
			"Virility 1",
			"Virility 2",
			"Virility 3",
			"Virility 4",
		]		
	},
	"Rigid Pliability": {
		"name": "Rigid Pliability",
		"description": "[color=aqua]Unyielding[/color]: $name's holes yield for no penis, no matter the size.\n\n [color=red]50% Higher chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"negative",
		],
		"conflict": [
			"Pliability 1",
			"Pliability 2",
			"Pliability 3",
			"Pliability 4",
			"Pliability 5",
		]		
	},
	"Pliability 1": {
		"name": "Pliability 1",
		"description": "[color=aqua]Firm[/color]: $name's holes are very slightly yielding, lessening the chance of tearing.\n\n [color=green]20% lower chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"rank1",
		],
		"conflict": [
			"Rigid Pliability",
			"Pliability 2",
			"Pliability 3",
			"Pliability 4",
			"Pliability 5",
		]		
	},
	"Pliability 2": {
		"name": "Pliability 2",
		"description": "[color=aqua]Yielding[/color]: $name's holes are somewhat yielding, lessening the chance of tearing.\n\n [color=green]40% lower chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"rank2",
		],
		"conflict": [
			"Rigid Pliability",
			"Pliability 1",
			"Pliability 3",
			"Pliability 4",
			"Pliability 5",
		]		
	},
	"Pliability 3": {
		"name": "Pliability 3",
		"description": "[color=aqua]Springy[/color]: $name's holes are fairly yielding, lessening the chance of tearing.\n\n [color=green]60% lower chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"rank3",
		],
		"conflict": [
			"Rigid Pliability",
			"Pliability 1",
			"Pliability 2",
			"Pliability 4",
			"Pliability 5",
		]
	},
	"Pliability 4": {
		"name": "Pliability 4",
		"description": "[color=aqua]Stretchy[/color]: $name's holes are quite yielding, greatly lessening the chance of tearing.\n\n [color=green]80% lower chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"rank4",
		],
		"conflict": [
			"Rigid Pliability",
			"Pliability 1",
			"Pliability 2",
			"Pliability 3",
			"Pliability 5",
		]
	},
	"Pliability 5": {
		"name": "Pliability 5",
		"description": "[color=aqua]Super Stretchy[/color]: $name's holes are very stretchy, almost eliminating the chance of tearing.\n\n [color=green]100% lower chance to Tear during Penetration[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"pliabilitytrait",
			"rank5",
		],
		"conflict": [
			"Rigid Pliability",
			"Pliability 1",
			"Pliability 2",
			"Pliability 3",
			"Pliability 4",
		]		
	},
	"Rigid Elasticity": {
		"name": "Rigid Elasticity",
		"description": "[color=aqua]Very Poor Elasticity[/color]: $name's holes stay the size they were fucked into.\n\n [color=red]50% Higher chance to remain loosened[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"negative",
		],
		"conflict": [
			"Elasticity 1",
			"Elasticity 2",
			"Elasticity 3",
			"Elasticity 4",
			"Elasticity 5",
		]		
	},
	"Elasticity 1": {
		"name": "Elasticity 1",
		"description": "[color=aqua]Tightening[/color]: $name's holes may recover some of their original size.\n\n [color=green]20% chance to regain shape and recover from the 'Torn' condition if a hole orgasms while unoccupied during sex.[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"rank1",
		],
		"conflict": [
			"Rigid Elasticity",
			"Elasticity 2",
			"Elasticity 3",
			"Elasticity 4",
			"Elasticity 5",
		]		
	},
	"Elasticity 2": {
		"name": "Elasticity 2",
		"description": "[color=aqua]Quick Tightening[/color]: $name's holes have a decent chance to recover some of their original size.\n\n [color=green]40% chance to regain shape and recover from the 'Torn' condition if a hole orgasms while unoccupied during sex.[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"rank2",
		],
		"conflict": [
			"Rigid Elasticity",
			"Elasticity 1",
			"Elasticity 3",
			"Elasticity 4",
			"Elasticity 5",
		]		
	},
	"Elasticity 3": {
		"name": "Elasticity 3",
		"description": "[color=aqua]Elastic[/color]: $name's holes have a better chance to recover their original size than most.\n\n [color=green]60% chance to regain shape and recover from the 'Torn' condition if a hole orgasms while unoccupied during sex.[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"rank3",
		],
		"conflict": [
			"Rigid Elasticity",
			"Elasticity 1",
			"Elasticity 2",
			"Elasticity 4",
			"Elasticity 5",
		]		
	},
	"Elasticity 4": {
		"name": "Elasticity 4",
		"description": "[color=aqua]Very Elastic[/color]: $name's holes have a great chance to recover their original size.\n\n [color=green]80% chance to regain shape and recover from the 'Torn' condition if a hole orgasms while unoccupied during sex.[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"rank4",
		],
		"conflict": [
			"Rigid Elasticity",
			"Elasticity 1",
			"Elasticity 2",
			"Elasticity 3",
			"Elasticity 5",
		]		
	},
	"Elasticity 5": {
		"name": "Elasticity 5",
		"description": "[color=aqua]Super Elastic[/color]: $name's holes will almost definitely return to their original size.\n\n [color=green]100% chance to regain shape and recover from the 'Torn' condition if a hole orgasms while unoccupied during sex.[/color]",
		"effect": {
			
		},
		"tags": [
			"secondary",
			"sexual",
			"expansiontrait",
			"sextrait",
			"elasticitytrait",
			"rank5",
		],
		"conflict": [
			"Rigid Elasticity",
			"Elasticity 1",
			"Elasticity 2",
			"Elasticity 3",
			"Elasticity 4",
		]		
	},
}
###---Expansion End---###
