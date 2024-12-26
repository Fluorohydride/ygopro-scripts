--レドレミコード・ドリーミア
---@param c Card
function c92610868.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c92610868.distg)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92610868,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,92610868)
	e2:SetCondition(c92610868.spcon)
	e2:SetTarget(c92610868.sptg)
	e2:SetOperation(c92610868.spop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c92610868.repcon)
	e3:SetTarget(c92610868.reptg)
	e3:SetValue(c92610868.repval)
	c:RegisterEffect(e3)
end
function c92610868.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c92610868.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x162)
end
function c92610868.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c92610868.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c92610868.pfilter(c)
	return c:GetCurrentScale()%2~=0
end
function c92610868.repcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c92610868.pfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c92610868.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x162) and c:GetOriginalType()&TYPE_PENDULUM~=0
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE)
end
function c92610868.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c92610868.repfilter,1,c,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local sg=eg:Filter(c92610868.repfilter,c,tp)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(92610868,1))
			sg=sg:Select(tp,1,1,nil)
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		Duel.Destroy(c,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c92610868.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
