--デス・クラーケン
---@param c Card
function c69436288.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69436288,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69436288)
	e1:SetCondition(c69436288.spcon)
	e1:SetTarget(c69436288.sptg)
	e1:SetOperation(c69436288.spop)
	c:RegisterEffect(e1)
	--NegateAttack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69436288,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,69436289)
	e2:SetCondition(c69436288.thcon)
	e2:SetTarget(c69436288.thtg)
	e2:SetOperation(c69436288.thop)
	c:RegisterEffect(e2)
end
function c69436288.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22702055)
end
function c69436288.thfilter(c)
	return c:IsFaceup() and not c:IsCode(69436288) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c69436288.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c69436288.thfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c69436288.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69436288.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=g:GetFirst()
		if tc==hc then tc=g:GetNext() end
		if hc:IsRelateToEffect(e) and hc:IsControler(tp)
			and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND)
			and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c69436288.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c69436288.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c69436288.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.NegateAttack()
	end
end
