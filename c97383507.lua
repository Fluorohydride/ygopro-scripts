--ダークナイト＠イグニスター
function c97383507.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c97383507.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97383507,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,97383507)
	e1:SetCondition(c97383507.spcon1)
	e1:SetTarget(c97383507.sptg1)
	e1:SetOperation(c97383507.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97383507,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,97383508)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c97383507.sptg2)
	e2:SetOperation(c97383507.spop2)
	c:RegisterEffect(e2)
end
function c97383507.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c97383507.cfilter(c,lg)
	return lg:IsContains(c)
end
function c97383507.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c97383507.cfilter,1,nil,lg)
end
function c97383507.spfilter1(c,e,tp,zone)
	return c:IsLevelBelow(4) and c:IsSetCard(0x135) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c97383507.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c97383507.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97383507.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if zone==0 or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c97383507.spfilter1),tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c97383507.spfilter2(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97383507.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c97383507.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97383507.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c97383507.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
