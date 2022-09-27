--いたずら風のフィードラン
function c92597893.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92597893,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,92597893)
	e1:SetTarget(c92597893.pctg)
	e1:SetOperation(c92597893.pcop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92597893,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_END_PHASE)
	e3:SetCountLimit(1,92597894)
	e3:SetCondition(c92597893.poscon)
	e3:SetTarget(c92597893.postg)
	e3:SetOperation(c92597893.posop)
	c:RegisterEffect(e3)
end
function c92597893.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c92597893.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c92597893.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c92597893.posfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c92597893.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c92597893.posfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c92597893.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and c:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c92597893.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c92597893.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 and c:IsRelateToEffect(e) and c:IsAbleToHand() then
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
