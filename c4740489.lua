--マグネット・フィールド
function c4740489.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4740489,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,4740489)
	e2:SetCondition(c4740489.spcon)
	e2:SetTarget(c4740489.sptg)
	e2:SetOperation(c4740489.spop)
	c:RegisterEffect(e2)
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4740489,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c4740489.atcon)
	e3:SetOperation(c4740489.atop)
	c:RegisterEffect(e3)
end
function c4740489.cfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsRace(RACE_ROCK) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c4740489.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4740489.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c4740489.spfilter(c,e,tp)
	return c:IsSetCard(0x2066) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4740489.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4740489.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4740489.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4740489.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4740489.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4740489.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsRace(RACE_ROCK) and d:IsAttribute(ATTRIBUTE_EARTH)
			and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
	elseif a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsRace(RACE_ROCK) and a:IsAttribute(ATTRIBUTE_EARTH)
			and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
	end
	return false
end
function c4740489.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
