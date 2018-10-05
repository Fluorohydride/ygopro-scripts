--大地の騎士ガイアナイト
function c97204936.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c,nil),1)
	c:EnableReviveLimit()
end
