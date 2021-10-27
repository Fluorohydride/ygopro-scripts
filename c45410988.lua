--レッドアイズ・トランスマイグレーション
function c45410988.initial_effect(c)
	local e0=aux.AddRitualProcGreaterCode(c,19025379,nil,c45410988.mfilter)
	c:RegisterEffect(e0)
end
function c45410988.mfilter(c)
	return c:IsSetCard(0x3b)
end
