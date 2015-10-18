--Superheavy Maju Kyu-B
function c85528209.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x9a),1)
	c:EnableReviveLimit()
	--defence attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENCE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c85528209.sccon)
	e2:SetValue(c85528209.adval)
	c:RegisterEffect(e2)
end
function c85528209.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c85528209.adval(tp,c)
	return Duel.GetMatchingGroupCount(c85528209.ctfilter,tp,0,LOCATION_MZONE,nil)*900
end
function c85528209.ctfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:GetControler()~=e:GetHandler():GetControler()
end
