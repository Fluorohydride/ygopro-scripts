--捕食植物スパイダー・オーキッド
function c30537973.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c30537973.reg)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30537973,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,30537973)
	e2:SetCondition(c30537973.descon)
	e2:SetTarget(c30537973.destg)
	e2:SetOperation(c30537973.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30537973,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30537974)
	e3:SetCost(c30537973.thcost)
	e3:SetTarget(c30537973.thtg)
	e3:SetOperation(c30537973.thop)
	c:RegisterEffect(e3)
	if not c30537973.global_check then
		c30537973.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(30537973)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(30537973)
		Duel.RegisterEffect(ge2,0)
	end
end
function c30537973.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(30537973,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c30537973.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(30537973)~=0
end
function c30537973.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c30537973.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c30537973.costfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsDiscardable()
end
function c30537973.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(30537973)~=0
		and Duel.IsExistingMatchingCard(c30537973.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c30537973.costfilter,1,1,REASON_DISCARD+REASON_COST)
	e:GetHandler():ResetFlagEffect(30537973)
end
function c30537973.thfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c30537973.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30537973.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30537973.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30537973.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
