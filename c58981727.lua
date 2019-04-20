--妖仙獣 侍郎風
function c58981727.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,58981727)
	e1:SetCondition(c58981727.thcon)
	e1:SetTarget(c58981727.thtg)
	e1:SetOperation(c58981727.thop)
	c:RegisterEffect(e1)
	--to field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,58981728)
	e2:SetTarget(c58981727.tftg)
	e2:SetOperation(c58981727.tfop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c58981727.regop)
	c:RegisterEffect(e3)
end
function c58981727.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb3)
end
function c58981727.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c58981727.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c58981727.thfilter(c)
	return c:IsSetCard(0xb3) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c58981727.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58981727.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c58981727.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c58981727.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c58981727.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb3) and c:IsAbleToDeck()
end
function c58981727.tffilter(c)
	return c:IsCode(62681049,79861914) and not c:IsForbidden()
end
function c58981727.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c58981727.tdfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c58981727.tdfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c58981727.tffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c58981727.tdfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c58981727.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sc=Duel.SelectMatchingCard(tp,c58981727.tffilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc then
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c58981727.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetTarget(c58981727.rettg)
	e1:SetOperation(c58981727.retop)
	e1:SetReset(RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c58981727.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c58981727.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
