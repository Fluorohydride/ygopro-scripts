--宝玉の祝福
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.flipcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.fliptg)
	e2:SetOperation(s.flipop)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetSequence()<5
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,math.min(ft,2),nil,e,tp)
	if #g==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local atk=Duel.GetOperatedGroup():GetSum(Card.GetBaseAttack)
	Duel.Recover(tp,atk,REASON_EFFECT)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and (Duel.GetDecktopGroup(tp,1):IsExists(Card.IsAbleToHand,1,nil)
			or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp)
				and not Duel.IsPlayerAffectedByEffect(tp,63060238)) end
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=tc:IsAbleToHand()
	local b2=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if tc:IsSetCard(0x1034) and tc:IsType(TYPE_MONSTER) and (b1 or b2) then
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.DisableShuffleCheck()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
