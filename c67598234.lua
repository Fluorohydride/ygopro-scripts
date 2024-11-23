--電影の騎士ガイアセイバー
---@param c Card
function c67598234.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
end
