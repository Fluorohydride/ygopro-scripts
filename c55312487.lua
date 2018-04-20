--クルセイド・パラディオン
function c55312487.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,55312487+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c55312487.target)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c55312487.atcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c55312487.atlimit)
	c:RegisterEffect(e3)
end
function c55312487.spfilter1(c,e,tp)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x116)) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c55312487.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalCode())
end
function c55312487.spfilter2(c,e,tp,code)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x116)) and c:GetOriginalCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55312487.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckReleaseGroup(tp,c55312487.spfilter1,1,nil,e,tp)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(55312487,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c55312487.activate)
		local rg=Duel.SelectReleaseGroup(tp,c55312487.spfilter1,1,1,nil,e,tp)
		e:SetLabel(rg:GetFirst():GetOriginalCode())
		Duel.Release(rg,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c55312487.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55312487.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c55312487.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsType(TYPE_LINK)
end
function c55312487.atcon(e)
	return Duel.IsExistingMatchingCard(c55312487.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c55312487.atlimit(e,c)
	return c:IsFacedown() or not c:IsType(TYPE_LINK)
end
