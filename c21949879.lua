--EMジェントルード
local s,id,o=GetID()
function c21949879.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21949879,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,21949879)
	e1:SetCondition(c21949879.scon)
	e1:SetTarget(c21949879.stg)
	e1:SetOperation(c21949879.sop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21949879,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21949879+o)
	e2:SetTarget(c21949879.pentg)
	e2:SetOperation(c21949879.penop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21949879,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,21949879+o)
	e3:SetCondition(c21949879.thcon)
	e3:SetCost(c21949879.thcost)
	e3:SetTarget(c21949879.thtg)
	e3:SetOperation(c21949879.thop)
	c:RegisterEffect(e3)
end
function c21949879.cfilter(c)
	return c:IsCode(58938528)
end
function c21949879.gfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c21949879.scon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return Duel.IsExistingMatchingCard(c21949879.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and (g:GetCount()==0 or g:FilterCount(c21949879.gfilter,nil)==g:GetCount())
end
function c21949879.sfilter(c)
	return c:IsSetCard(0x99) and c:IsAbleToHand()
end
function c21949879.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21949879.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21949879.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21949879.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21949879.penfilter(c)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM) and not c:IsCode(21949879) and not c:IsForbidden()
end
function c21949879.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c21949879.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21949879.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c21949879.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c21949879.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c21949879.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsDiscardable()
end
function c21949879.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21949879.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c21949879.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c21949879.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c21949879.thfilter(c)
	return c:IsSetCard(0x9f,0x99) and c:IsAbleToHand()
end
function c21949879.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c21949879.thfilter,tp,LOCATION_PZONE,0,nil)
		if c:IsLocation(LOCATION_HAND) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21949879,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
