--No.90 銀河眼の光子卿
---@param c Card
function c8165596.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c8165596.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8165596,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,8165596)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c8165596.negcon)
	e2:SetCost(c8165596.negcost)
	e2:SetTarget(c8165596.negtg)
	e2:SetOperation(c8165596.negop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(8165596,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,8165597)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c8165596.condition)
	e3:SetTarget(c8165596.target)
	e3:SetOperation(c8165596.operation)
	c:RegisterEffect(e3)
end
aux.xyz_number[8165596]=90
function c8165596.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x55)
end
function c8165596.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c8165596.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c8165596.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and e:GetLabelObject():IsSetCard(0x7b) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c8165596.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabelObject():IsSetCard(0x7b) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c8165596.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c8165596.filter(c,mc)
	return c:IsSetCard(0x55,0x7b) and (c:IsAbleToHand() or (mc:IsType(TYPE_XYZ) and c:IsCanOverlay()))
end
function c8165596.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8165596.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
end
function c8165596.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c8165596.filter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(8165596,2))==1) then
			Duel.Overlay(c,Group.FromCards(tc))
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
