--No.101 S·H·Ark Knight－ソウル・アサイラム
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--search & material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetTarget(s.dreptg)
	e2:SetOperation(s.drepop)
	c:RegisterEffect(e2)
end
aux.xyz_number[id]=101
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
	ct:CreateEffectRelation(e)
end
function s.filter1(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c) and c:IsLevel(4)
end
function s.thfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and not c:IsCode(tc:GetCode()) and c:IsLevel(4)
end
function s.filter2(c)
	return c:IsCanOverlay()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then
			return false
		else
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter2(chkc)
		end
	end
	local ct=e:GetLabelObject()
	local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,ct,tp)
	local b2=Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local ct=e:GetLabelObject()
		if not ct:IsRelateToChain() then ct=nil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,ct,tp)
		if tg:GetCount()>0 then
			Duel.HintSelection(tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tg:GetFirst())
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		local c=e:GetHandler()
		if c:IsRelateToChain() and tc:IsRelateToChain() and not tc:IsImmuneToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsCanOverlay() then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end
function s.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.drepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
