--聖天樹の灰樹精
---@param c Card
function c44478599.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,3,c44478599.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44478599,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c44478599.spcon)
	e1:SetTarget(c44478599.sptg)
	e1:SetOperation(c44478599.spop)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44478599,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c44478599.mtcon)
	e3:SetTarget(c44478599.mttg)
	e3:SetOperation(c44478599.mtop)
	c:RegisterEffect(e3)
end
function c44478599.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c44478599.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c44478599.spfilter(c,e,tp)
	return c:IsCode(27520594) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44478599.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44478599.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c44478599.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44478599.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c44478599.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c44478599.cfilter(c,g)
	return c:IsSetCard(0x1158) and c:IsType(TYPE_LINK) and g:IsContains(c)
end
function c44478599.valfilter(c)
	return c:IsSetCard(0x2158) and c:IsType(TYPE_LINK)
end
function c44478599.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c44478599.cfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c44478599.cfilter,tp,LOCATION_MZONE,0,1,nil,lg)
		and Duel.GetMatchingGroupCount(c44478599.valfilter,tp,LOCATION_MZONE,0,nil)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c44478599.cfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c44478599.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c44478599.valfilter,tp,LOCATION_MZONE,0,nil)
	if tc:IsRelateToEffect(e) then
		if ct>1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(ct-1)
			tc:RegisterEffect(e1)
		elseif ct==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
