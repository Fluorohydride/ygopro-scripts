--ロスタイム
function c72453068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72453068+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72453068.condition)
	e1:SetOperation(c72453068.activate)
	c:RegisterEffect(e1)
end
function c72453068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)>=4000 and Duel.GetLP(tp)~=Duel.GetLP(1-tp)-1000
end
function c72453068.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)>=4000 and Duel.GetLP(tp)~=Duel.GetLP(1-tp)-1000 then
		Duel.SetLP(tp,Duel.GetLP(1-tp)-1000)
	end
end
