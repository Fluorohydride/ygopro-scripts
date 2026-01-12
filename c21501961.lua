--恐依のペアルックマ！！
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_DECK)==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.pfilter(c)
	return c:IsCode(id) and not c:IsPublic()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.pfilter,tp,0,LOCATION_HAND+LOCATION_DECK,1,nil)
		and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(1-tp,s.pfilter,1-tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		Duel.ConfirmCards(tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.ShuffleHand(1-tp)
		else
			Duel.ShuffleDeck(1-tp)
		end
		Duel.Recover(tp,2000,REASON_EFFECT,true)
		Duel.Recover(1-tp,2000,REASON_EFFECT,true)
		Duel.RDComplete()
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,c)
	end
end
