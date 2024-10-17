--エアー・トルピード
---@param c Card
function c45943123.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45943123,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,45943123)
	e1:SetTarget(c45943123.target)
	e1:SetOperation(c45943123.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45943123,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,45943123)
	e2:SetCost(c45943123.drcost)
	e2:SetTarget(c45943123.drtg)
	e2:SetOperation(c45943123.drop)
	c:RegisterEffect(e2)
end
function c45943123.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c45943123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if b then ct=ct-1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c45943123.cfilter(chkc,tp) end
	if chk==0 then
		return Duel.IsExistingTarget(c45943123.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) and ct>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c45943123.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c45943123.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ct>0 then
			local atk=Duel.Damage(1-tp,ct*400,REASON_EFFECT)
			if tc:IsFaceup() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c45943123.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c45943123.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c45943123.drfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c45943123.drfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c45943123.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c45943123.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
