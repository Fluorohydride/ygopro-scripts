--堕天使ルシフェル
function c25451652.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25451652,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c25451652.spcon)
	e2:SetTarget(c25451652.sptg)
	e2:SetOperation(c25451652.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	e3:SetCondition(c25451652.tgcon)
	c:RegisterEffect(e3)
	--discard deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25451652,1))
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c25451652.distg)
	e4:SetOperation(c25451652.disop)
	c:RegisterEffect(e4)
end
function c25451652.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c25451652.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c25451652.spfilter(c,e,tp)
	return c:IsSetCard(0xef) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25451652.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c25451652.ctfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c25451652.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c25451652.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c25451652.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c25451652.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local ct=5
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,g1:GetCount(),Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g2:Select(tp,1,ct,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c25451652.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xef)
end
function c25451652.tgcon(e)
	return Duel.IsExistingMatchingCard(c25451652.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c25451652.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c25451652.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
end
function c25451652.ctfilter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xef)
end
function c25451652.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c25451652.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct1>0 then
		if Duel.DiscardDeck(tp,ct1,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local ct2=og:FilterCount(c25451652.ctfilter2,nil)
			if ct2>0 then
				Duel.Recover(tp,ct2*500,REASON_EFFECT)
			end
		end
	end
end
