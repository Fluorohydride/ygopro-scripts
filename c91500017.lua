--トゥーンのしおり
---@param c Card
function c91500017.initial_effect(c)
	aux.AddCodeList(c,15259703)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,91500017+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c91500017.target)
	e1:SetOperation(c91500017.activate)
	c:RegisterEffect(e1)
	--Prevent Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c91500017.reptg)
	e2:SetValue(c91500017.repval)
	e2:SetOperation(c91500017.repop)
	c:RegisterEffect(e2)
end
function c91500017.filter(c)
	return aux.IsCodeOrListed(c,15259703) and not c:IsCode(91500017) and c:IsAbleToHand()
end
function c91500017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91500017.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c91500017.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c91500017.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c91500017.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsCode(15259703)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c91500017.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c91500017.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c91500017.repval(e,c)
	return c91500017.repfilter(c,e:GetHandlerPlayer())
end
function c91500017.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
