--捕食惑星
function c51858200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c51858200.regop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51858200,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,51858200)
	e2:SetCondition(c51858200.thcon)
	e2:SetTarget(c51858200.thtg)
	e2:SetOperation(c51858200.thop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--fusion summon
	local e3=aux.AddFusionEffectProcUltimate(c,{
		mat_filter=aux.FilterBoolFunction(Card.IsSetCard,0x10f3),
		reg=false
	})
	e3:SetDescription(aux.Stringid(51858200,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	c:RegisterEffect(e3)
end
function c51858200.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x1041)>0
end
function c51858200.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c51858200.cfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c51858200.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c51858200.thfilter(c)
	return c:IsSetCard(0xf3) and c:IsAbleToHand()
end
function c51858200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51858200.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51858200.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
