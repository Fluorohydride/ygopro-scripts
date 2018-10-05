--スクラップ・デスデーモン
function c45815891.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c,nil),1)
	c:EnableReviveLimit()
end
