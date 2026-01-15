--戦場の惨劇
function c42228966.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetCountLimit(1,42228966)
	e2:SetCondition(c42228966.sscon)
	e2:SetCost(c42228966.sscost)
	e2:SetTarget(c42228966.sstg)
	e2:SetOperation(c42228966.ssop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c42228966.tgcon)
	e3:SetTarget(c42228966.tgtg)
	e3:SetOperation(c42228966.tgop)
	c:RegisterEffect(e3)
	if not c42228966.global_check then
		c42228966.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c42228966.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c42228966.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget() then Duel.RegisterFlagEffect(0,42228966,RESET_PHASE+PHASE_END,0,1) end
end
function c42228966.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,42228966)==0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c42228966.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c42228966.ssfilter(c)
	return c:IsCode(42228966) and c:IsSSetable()
end
function c42228966.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42228966.ssfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c42228966.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c42228966.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
function c42228966.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,42228966)>0
end
function c42228966.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,Duel.GetTurnPlayer(),5)
end
function c42228966.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(Duel.GetTurnPlayer(),5,REASON_EFFECT)
end
