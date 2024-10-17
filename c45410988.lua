--レッドアイズ・トランスマイグレーション
---@param c Card
function c45410988.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,19025379,nil,c45410988.mfilter)
end
function c45410988.mfilter(c)
	return c:IsSetCard(0x3b)
end
