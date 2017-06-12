--超重魔獣キュウ－B
function c85528209.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x9a),1)
	c:EnableReviveLimit()
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c85528209.sccon)
	e3:SetValue(c85528209.adval)
	c:RegisterEffect(e3)
end
function c85528209.sccon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c85528209.adval(e,c)
	return Duel.GetMatchingGroupCount(c85528209.ctfilter,c:GetControler(),0,LOCATION_MZONE,nil)*900
end
function c85528209.ctfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
