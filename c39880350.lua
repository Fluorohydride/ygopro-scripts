--聖天樹の精霊
---@param c Card
function c39880350.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c39880350.mfilter,2,2,c39880350.lcheck)
	c:EnableReviveLimit()
	--cannot be battle traget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39880350,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c39880350.spcon)
	e2:SetTarget(c39880350.sptg)
	e2:SetOperation(c39880350.spop)
	c:RegisterEffect(e2)
end
function c39880350.mfilter(c)
	return c:IsLinkRace(RACE_PLANT)
end
function c39880350.lcheck(g)
	return g:IsExists(c39880350.lcfilter,1,nil)
end
function c39880350.lcfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x2158)
end
function c39880350.spfilter(c,e,tp)
	return c:IsSetCard(0x1158) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c39880350.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c39880350.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39880350.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,ev)
end
function c39880350.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,ev,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c39880350.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
