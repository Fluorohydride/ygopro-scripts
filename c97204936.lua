--大地の騎士ガイアナイト
---@param c Card
function c97204936.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
end
