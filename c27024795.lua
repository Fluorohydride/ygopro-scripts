--極星霊アルヴィース
---@param c Card
function c27024795.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27024795,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c27024795.spcon)
	e1:SetTarget(c27024795.sptg)
	e1:SetOperation(c27024795.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27024795,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27024795+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c27024795.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27024795.sptg2)
	e2:SetOperation(c27024795.spop2)
	c:RegisterEffect(e2)
end
function c27024795.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst()==e:GetHandler() and re and re:IsActiveType(TYPE_LINK) and re:GetHandler():IsSetCard(0x42)
end
function c27024795.matfilter(c)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsLevelAbove(1)
end
function c27024795.fgoal(sg,e,tp)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==2 and sg:GetSum(Card.GetLevel)==10
		and Duel.IsExistingMatchingCard(c27024795.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function c27024795.spfilter(c,e,tp,mg)
	return c:IsSetCard(0x4b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c27024795.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c27024795.matfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
		return mg:CheckSubGroup(c27024795.fgoal,3,3,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27024795.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c27024795.matfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,c27024795.fgoal,false,3,3,e,tp)
	if sg and Duel.SendtoGrave(sg,REASON_EFFECT)==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c27024795.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c27024795.cfilter(c,tp)
	return c:IsPreviousSetCard(0x4b) and c:IsPreviousControler(tp)
end
function c27024795.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c27024795.cfilter,1,nil,tp)
end
function c27024795.spfilter2(c,e,tp)
	return c:IsSetCard(0x4b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c27024795.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27024795.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27024795.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27024795.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
