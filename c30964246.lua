--ARG☆S－GiantKilling
local s,id,o=GetID()
function s.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg1)
	e2:SetOperation(s.thop1)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x1c1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_WARRIOR)
end
function s.chkfilter(c)
	return c:IsAllTypes(TYPE_CONTINUOUS|TYPE_TRAP) and c:IsFaceup() and
		(c:IsLocation(LOCATION_MZONE) or
			c:IsEffectProperty(aux.EffectCategoryFilter(CATEGORY_SPECIAL_SUMMON)) and
			(c:GetOriginalLevel()>0
			or bit.band(c:GetOriginalRace(),0x3fffffff)~=0
			or bit.band(c:GetOriginalAttribute(),0x7f)~=0
			or c:GetBaseAttack()>0
			or c:GetBaseDefense()>0))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			Duel.ShuffleHand(tp)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function s.filter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function s.thfilters(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsAllTypes(TYPE_CONTINUOUS|TYPE_TRAP) and c:IsSetCard(0x1c1)
end
function s.sgselect(g,tp)
	return g:IsExists(s.thfilters,1,nil,tp)
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(s.sgselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,s.sgselect,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
