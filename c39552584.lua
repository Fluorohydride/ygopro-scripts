--暗黒界の龍神王 グラファ
function c39552584.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,34230233,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,true,true)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39552584,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,39552584)
	e1:SetCondition(c39552584.chcon)
	e1:SetTarget(c39552584.chtg)
	e1:SetOperation(c39552584.chop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39552584,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c39552584.spcon)
	e2:SetTarget(c39552584.sptg)
	e2:SetOperation(c39552584.spop)
	c:RegisterEffect(e2)
end
function c39552584.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER)
		or (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c39552584.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,rp,0,LOCATION_HAND,1,nil,REASON_EFFECT) end
end
function c39552584.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c39552584.repop)
end
function c39552584.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c39552584.spfilter(c,e,tp)
	return c:IsCode(34230233) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c39552584.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c39552584.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c39552584.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function c39552584.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c39552584.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
