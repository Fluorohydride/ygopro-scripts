--レプティレス・ラミフィケーション
---@param c Card
function c81615450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81615450,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81615450+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81615450.cost)
	e1:SetTarget(c81615450.target)
	e1:SetOperation(c81615450.activate)
	c:RegisterEffect(e1)
end
function c81615450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c81615450.thfilter1(c)
	return c:IsSetCard(0x3c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c81615450.thfilter2(c)
	return c:IsSetCard(0x3c) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(81615450)
end
function c81615450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c81615450.thfilter1,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(81615450,1)
		opval[off]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c81615450.thfilter2,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(81615450,2)
		opval[off]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(81615450,3)
		opval[off]=3
		off=off+1
	end
	if chk==0 then return off>2 end
	local sel=Duel.SelectOption(tp,table.unpack(ops))+1
	local op=opval[sel]
	table.remove(ops,sel)
	table.remove(opval,sel)
	sel=Duel.SelectOption(tp,table.unpack(ops))+1
	op=op+(opval[sel]<<4)
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81615450.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local op1=op&0xf
	local op2=op>>4
	if op1==1 or op2==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81615450.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op1==2 or op2==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81615450.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op1==3 or op2==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
