--ワルキューレ・アルテスト
function c66809920.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66809920,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,66809920)
	e1:SetCondition(c66809920.thcon)
	e1:SetTarget(c66809920.thtg)
	e1:SetOperation(c66809920.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66809920,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66809921)
	e2:SetCondition(c66809920.rmcon)
	e2:SetTarget(c66809920.rmtg)
	e2:SetOperation(c66809920.rmop)
	c:RegisterEffect(e2)
end
c66809920.listed_names={92182447}
function c66809920.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c66809920.thfilter(c)
	return c:IsCode(92182447) and c:IsAbleToHand()
end
function c66809920.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66809920.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66809920.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66809920.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66809920.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c66809920.cfilter(c)
	return c:IsSetCard(0x122) and not c:IsCode(66809920)
end
function c66809920.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66809920.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66809920.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66809920.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66809920.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c66809920.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.SelectMatchingCard(tp,c66809920.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
	if rc then
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(rc:GetBaseAttack())
			c:RegisterEffect(e1)
		end
	end
end
