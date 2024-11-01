--無限起動ロードローラー
---@param c Card
function c5205146.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5205146,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,5205146)
	e1:SetLabelObject(e0)
	e1:SetCondition(c5205146.spcon)
	e1:SetTarget(c5205146.sptg)
	e1:SetOperation(c5205146.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--gain effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c5205146.matcheck)
	e3:SetTarget(c5205146.postg)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(-1000)
	c:RegisterEffect(e4)
end
function c5205146.cfilter(c,se)
	if c:IsLocation(LOCATION_REMOVED)
		and not (c:IsReason(REASON_RELEASE) or c:IsFaceup()) then return false end
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return c:GetPreviousAttributeOnField()&ATTRIBUTE_EARTH>0 and c:GetPreviousRaceOnField()&RACE_MACHINE>0
	else
		return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
	end
end
function c5205146.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c5205146.cfilter,1,nil,se) and not eg:IsContains(c)
end
function c5205146.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c5205146.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c5205146.matcheck(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c5205146.postg(e,c)
	return c:IsFaceup()
end
