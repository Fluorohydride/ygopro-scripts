--宝玉の先導者
function c87475570.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c87475570.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87475570,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c87475570.cost)
	e2:SetTarget(c87475570.target)
	e2:SetOperation(c87475570.operation)
	c:RegisterEffect(e2)
end
function c87475570.tgtg(e,c)
	return c:IsSetCard(0x1034) or (c:IsLocation(LOCATION_MZONE) and (c:IsCode(79407975) or c:IsCode(79856792)))
end
function c87475570.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c87475570.filter(c)
	return (((c:IsSetCard(0x1034) or c:IsCode(79856792) or c:IsCode(79407975)) and c:IsType(TYPE_MONSTER))
		or (c:IsSetCard(0x34) and c:IsType(TYPE_SPELL+TYPE_TRAP))) and c:IsAbleToHand()
end
function c87475570.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87475570.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87475570.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87475570.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
