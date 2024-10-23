--天威の鬼神
function c5402805.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c5402805.lcheck)
	c:EnableReviveLimit()
end
function c5402805.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
