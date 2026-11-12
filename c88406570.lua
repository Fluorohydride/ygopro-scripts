--剛鬼デストロイ・オーガ
function c88406570.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfc),2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c88406570.indtg)
	e1:SetValue(c88406570.indct)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88406570,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88406570)
	e2:SetTarget(c88406570.sptg)
	e2:SetOperation(c88406570.spop)
	c:RegisterEffect(e2)
end
function c88406570.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c88406570.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c88406570.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88406570.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xfc) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c88406570.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return zone~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
			and Duel.IsExistingMatchingCard(c88406570.spfilter1,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
			and Duel.IsExistingMatchingCard(c88406570.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function c88406570.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)
	if ft>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft=1 end
		if ft>1 then ft=2 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(1-tp,c88406570.spfilter1,1-tp,LOCATION_GRAVE,0,1,ft,nil,e,1-tp)
		if g1:GetCount()>0 then
			local ct=Duel.SpecialSummon(g1,0,1-tp,1-tp,false,false,POS_FACEUP)
			local zone=c:GetLinkedZone(tp)
			ct=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)),ct)
			if zone~=0 and ct>0 and c:IsRelateToEffect(e) then
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,c88406570.spfilter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp,zone)
				if g2:GetCount()>0 then
					Duel.BreakEffect()
					Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP,zone)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88406570.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88406570.splimit(e,c)
	return not c:IsSetCard(0xfc)
end
