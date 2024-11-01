--天威の拳僧
---@param c Card
function c32519092.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c32519092.matfilter,1,1)
	c:EnableReviveLimit()
end
function c32519092.matfilter(c)
	return c:IsLinkSetCard(0x12c) and not c:IsLinkType(TYPE_LINK)
end
