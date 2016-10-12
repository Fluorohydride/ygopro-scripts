--スクラップ・デスデーモン
function c45815891.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.Tuner(nil),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
end
