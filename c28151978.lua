--SRドミノバタフライ
function c28151978.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c28151978.splimit)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28151978,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,28151978)
	e2:SetCost(c28151978.thcost)
	e2:SetTarget(c28151978.thtg)
	e2:SetOperation(c28151978.thop)
	c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(c28151978.synlimit)
	c:RegisterEffect(e3)
	--synchro material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetValue(LOCATION_REMOVED)
	e4:SetCondition(c28151978.rmcon)
	c:RegisterEffect(e4)
end
function c28151978.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsAttribute(ATTRIBUTE_WIND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c28151978.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsDiscardable()
end
function c28151978.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28151978.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c28151978.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c28151978.thfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28151978.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c28151978.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28151978.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c28151978.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c28151978.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c28151978.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WIND) or not c:IsRace(RACE_DRAGON+RACE_MACHINE)
end
function c28151978.rmcon(e)
	local c=e:GetHandler()
	return c:GetSummonLocation()==LOCATION_EXTRA
		and bit.band(c:GetReason(),REASON_MATERIAL+REASON_SYNCHRO)==REASON_MATERIAL+REASON_SYNCHRO
end
