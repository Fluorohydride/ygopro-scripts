--テセウスの魔棲物
---@param c Card
function c96334243.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_TUNER),2,true)
end
