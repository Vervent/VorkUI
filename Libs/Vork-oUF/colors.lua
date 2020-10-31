local _, ns = ...
local oUF = ns.oUF

oUF.colors.absorbs = {
    damageAbsorb = { 27/255, 86/255, 206/255 },
    healAbsorb = {255/255, 44/255, 79/255}
}

oUF.colors.prediction = {
    myHeal = { 60/255, 164/255, 126/255 },
    otherHeal = { 27/255, 87/255, 208/255 },
    power = { 186/255, 225/255, 238/255 }
}

oUF.colors.smooth = {
    230/255, 40/255, 71/255,
    215/255, 161/255, 46/255,
    --31/255, 140/255, 90/255
    --124/255, 169/255, 70/255
    --143/255, 188/255, 87/255
    147/255, 189/255, 47/255
}

--oUF.colors.power.MANA = { 120/255, 179/255, 209/255 }
--oUF.colors.power.MANA = { 20/255, 75/255, 179/255 }
oUF.colors.power.MANA = { 31/255, 177/255, 171/255 }
--oUF.colors.power.MANA = { 27/255, 86/255, 206/255 }