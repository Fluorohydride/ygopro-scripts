--絆醒師セームベル
---@param c Card
function c46999905.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46999905,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,46999905)
	e1:SetCondition(c46999905.spcon)
	e1:SetTarget(c46999905.sptg)
	e1:SetOperation(c46999905.spop)
	c:RegisterEffect(e1)
	--SpecialSummon_Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46999905,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,46999906)
	e2:SetCondition(c46999905.spcon2)
	e2:SetTarget(c46999905.sptg2)
	e2:SetOperation(c46999905.spop2)
	c:RegisterEffect(e2)
end
function c46999905.filter(c,mc)
	return c:IsLevel(mc:GetLevel())
end
function c46999905.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c46999905.filter,tp,LOCATION_PZONE,0,1,e:GetHandler(),e:GetHandler())
end
function c46999905.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c46999905.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c46999905.cfilter(c,tp)
	return c:IsControler(tp)
end
function c46999905.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c46999905.cfilter,1,nil,tp)
end
function c46999905.spfilter2(c,e,tp,tc)
	return c:IsLevel(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46999905.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c46999905.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c46999905.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c46999905.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
