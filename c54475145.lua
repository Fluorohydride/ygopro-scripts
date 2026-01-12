--心宿りし青眼竜
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,37613663)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(37613663) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,id)==0 then
		Duel.RegisterFlagEffect(rp,id,0,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetOperation(s.rsop)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,rp)
	end
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject()==re then
		Duel.ResetFlagEffect(tp,id)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c)
	return c:IsCode(37613663) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.tdfilter(c,tp,e)
	return (c:IsAttackAbove(3000) or c:IsLevelAbove(8)) and c:IsFaceup() and c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(s.tdfilter,nil,tp)
	if chk==0 then return Duel.GetMZoneCount(tp,g,tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsType,nil,TYPE_MONSTER)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
