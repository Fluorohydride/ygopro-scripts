--フォトン・サークラー
function c64145892.initial_effect(c)
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetValue(aux.ChangeBattleDamage(0,HALF_DAMAGE))
	c:RegisterEffect(e1)
end
