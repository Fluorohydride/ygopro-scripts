--無の畢竟 オールヴェイン
---@param c Card
function c3544583.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_NORMAL),2,true)
end
