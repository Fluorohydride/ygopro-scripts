--フォトン・リタデイション
function c8653757.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8653757,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c8653757.target)
	e1:SetOperation(c8653757.activate)
	c:RegisterEffect(e1)
	--end turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_ACTIVATE_CONDITION)
	e2:SetCondition(c8653757.etcon)
	e2:SetOperation(c8653757.etop)
	c:RegisterEffect(e2)
end
function c8653757.filter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x55,0x7b)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp)))
end
function c8653757.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8653757.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c8653757.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c8653757.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsForbidden() or not tc:CheckUniqueOnField(tp) or Duel.SelectOption(tp,1190,aux.Stringid(8653757,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c8653757.cfilter(c)
	return c:IsFaceup() and (c:IsCode(93717133) or (c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,93717133)))
end
function c8653757.etcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
		and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c8653757.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c8653757.etop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
