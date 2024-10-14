--ジェムナイト・パール
---@param c Card
function c71594310.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
end
